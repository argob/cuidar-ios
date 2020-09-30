//
//  HTTPCliente.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

enum HTTPMetodo: String, CaseIterable {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case trace = "TRACE"
}

protocol HTTPSolicitud {
    associatedtype Cuerpo: Codable
    associatedtype Respuesta: Codable
    
    var urlPath: String { get }
    var metodo: HTTPMetodo { get }
    var cuerpo: Cuerpo? { get }
    var encabezados: [String: String] { get }
}

struct HTTPRespuesta<Model> {
    enum Error: Swift.Error {
        case desconocido
        case tokenInvalido
        case noHayConexionAInternet
        case urlMalFormada
        case malaCodificacionDelCuerpo(error: Swift.Error)
        case malaDescodificacionDeLaRespuesta(error: Swift.Error)
        case errorDelServidor
        case errorHttp(error: Swift.Error?)
    }
    let urlRequest: URLRequest?
    let httpResponse: HTTPURLResponse?
    let resultado: Result<Model, Error>
}

extension HTTPSolicitud {
    var encabezados: [String: String] {
        return [:]
    }
}

protocol HTTPCliente: class {
    var baseURL: String { get set }
    var headersProvider: ProvedorDeEncabezados? { get set }
    
    func ejecutar<Solicitud: HTTPSolicitud>(solicitud: Solicitud,
                                            finalizacion: @escaping (HTTPRespuesta<Solicitud.Respuesta>) -> Void)
}

protocol ProvedorDeEncabezados: class {
    func getHeaders() -> [String: String]
}

final class URLSessionHTTPCliente {
    private let bodyEncoder: JSONEncoder
    private let respuestaDecoder: JSONDecoder
    private let urlSession: URLSession
    
    var baseURL: String
    weak var headersProvider: ProvedorDeEncabezados?
    
    init(baseURL: String,
         urlSession: URLSession,
         bodyEncoder: JSONEncoder = .init(),
         respuestaDecoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.bodyEncoder = bodyEncoder
        self.respuestaDecoder = respuestaDecoder
        self.urlSession = urlSession
    }
}

extension URLSessionHTTPCliente: HTTPCliente {
    private struct Constants {
        static let httpCodigoRangoExitoso = 200...299
    }
    
    func ejecutar<Solicitud: HTTPSolicitud>(
        solicitud: Solicitud,
        finalizacion: @escaping (HTTPRespuesta<Solicitud.Respuesta>) -> Void
    ) {
        let respuestaFactoria = HTTPRespuestaFactoria<Solicitud>()
        
        do {
            let urlRequest = try crearURLRequest(for: solicitud)
            let task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                respuestaFactoria.urlRequest = urlRequest
                guard
                    let self = self,
                    let httpResponse = urlResponse as? HTTPURLResponse
                else {
                    let noHayInternet = (error as NSError?)?.code == NSURLErrorNotConnectedToInternet
                    finalizacion(respuestaFactoria.crearRespuestaFallida(error: noHayInternet ? .noHayConexionAInternet : .desconocido))
                    return
                }
                respuestaFactoria.httpResponse = httpResponse
                
                guard Constants.httpCodigoRangoExitoso.contains(httpResponse.statusCode) else {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                         print("[DEBUG] Error Response: \(json)")
                    }
                   
                    if (httpResponse.statusCode == 401) {
                        finalizacion(respuestaFactoria.crearRespuestaFallida(error: .tokenInvalido))
                        return
                    }
                    
                    finalizacion(respuestaFactoria.crearRespuestaFallida(error: .errorHttp(error: error)))
                    return
                }
                // Se limpia el flag de alerta de otro dispositivo conectado.
                UserDefaults.standard.set(false, forKey: Constantes.INVALID_TOKEN)
                finalizacion(self.descodificarRespuesta(solicitud: solicitud,
                                                        urlRequest: urlRequest,
                                                        httpResponse: httpResponse,
                                                        data: data, error: error))
            }
            task.resume()
        } catch {
            guard let errorDetectado = error as? HTTPRespuesta<Solicitud.Respuesta>.Error else {
                finalizacion(respuestaFactoria.crearRespuestaFallida(error: .desconocido))
                return
            }
            finalizacion(respuestaFactoria.crearRespuestaFallida(error: errorDetectado))
        }
    }
}

private extension URLSessionHTTPCliente {
    func crearURLRequest<Solicitud: HTTPSolicitud>(for solicitud: Solicitud) throws -> URLRequest {
        guard let url = URL(string: baseURL + solicitud.urlPath) else {
            throw HTTPRespuesta<Solicitud.Respuesta>.Error.urlMalFormada
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = solicitud.metodo.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encabezados = (self.headersProvider?.getHeaders() ?? [:]).merging(solicitud.encabezados) { $1 }
        encabezados.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = solicitud.cuerpo {
            do {
                urlRequest.httpBody = try bodyEncoder.encode(body)
            } catch let error {
                throw HTTPRespuesta<Solicitud.Respuesta>.Error.malaCodificacionDelCuerpo(error: error)
            }
        }
        
        return urlRequest
    }
    
    func descodificarRespuesta<Solicitud: HTTPSolicitud>(
        solicitud: Solicitud,
        urlRequest: URLRequest,
        httpResponse: HTTPURLResponse?,
        data: Data?,
        error: Error?) -> HTTPRespuesta<Solicitud.Respuesta>
    {
        let respuestaFactoria = HTTPRespuestaFactoria<Solicitud>()
        respuestaFactoria.urlRequest = urlRequest
        respuestaFactoria.httpResponse = httpResponse
        
        switch (error: error, data: data) {
        case (error: .some(let requestError), data: _):
            return respuestaFactoria.crearRespuestaFallida(error: .errorHttp(error: requestError))
        case (error: .none, data: .some(let responseData)):
            do {
                #if QA || STG
                    let json = (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]) ?? [:]
                    print("---- [DEBUG] RECEIVED ---- \(json)")
                #endif
                let respuestaDescodificada = try respuestaDecoder.decode(Solicitud.Respuesta.self, from: responseData)
                return respuestaFactoria.crearRespuestaExitosa(respuesta: respuestaDescodificada)
            } catch let error {
                #if QA || STG
                    let json = (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]) ?? [:]
                    print("---- [DEBUG] ERROR RECEIVED: ----\n \(error) \n---- [DEBUG] WHILE PARSING ---- \n \(json)")
                #endif
                return respuestaFactoria.crearRespuestaFallida(error: .malaDescodificacionDeLaRespuesta(error: error))
            }
        case (error: .none, data: .none):
            return respuestaFactoria.crearRespuestaFallida(error: .errorDelServidor)
        }
    }
}

private final class HTTPRespuestaFactoria<Solicitud: HTTPSolicitud> {
    var urlRequest: URLRequest?
    var httpResponse: HTTPURLResponse?
    
    init() {
    }
    
    func crearRespuestaExitosa(respuesta: Solicitud.Respuesta) -> HTTPRespuesta<Solicitud.Respuesta> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     resultado: .success(respuesta))
    }
    
    func crearRespuestaFallida(error: HTTPRespuesta<Solicitud.Respuesta>.Error) -> HTTPRespuesta<Solicitud.Respuesta> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     resultado: .failure(error))
    }
}

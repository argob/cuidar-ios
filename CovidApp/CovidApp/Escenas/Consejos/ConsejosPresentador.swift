//
//  ConsejosPresentador.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol ConsejosPresentadorProtocolo {
    func terminoDeCargarWebView()
    func updateView()
}

extension MVPVista where Self: ConsejosVista {
    func inyectar() -> ConsejosPresentadorProtocolo {
        let presentador = ConsejosPresentador()
        presentador.vista = self
        return presentador
    }
}

final class ConsejosPresentador: MVPPresentador {
    
    weak var vista: ConsejosVista?
    var cantidadDeConsejos:Int?
    var directorio:String?
    
    private let usuario : UsuarioFachadaProtocolo = inyectar()

    init() {
    }
}

extension ConsejosPresentador : ConsejosPresentadorProtocolo {

    func terminoDeCargarWebView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.vista?.dismiss()
        }
    }
    
    func updateView() {
        let randomPage: Int = randomNumber(inRange: 1...cantidadDeConsejos!)
        let url = URL(string: directorio! + "consejo" + randomPage.description + ".svg")!
        DispatchQueue.main.async {
            self.vista?.configurarVista(url: url)
        }
    }
    func escenaAparecio() {
        self.vista?.centrarLoadingIndicator()
    }
    
    func escenaCargo() {
        let urlString = Constantes.CONSEJOS_CANTIDAD_DISPONIBLES

        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    try self.parse(jsonData: data)
                    self.updateView()
                } catch {
                    DispatchQueue.main.async {
                        self.vista?.dismiss()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.vista?.dismiss()
                }
            }
        }
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
    }
    
    private func parse(jsonData: Data) throws {
        let decodedData = try JSONDecoder().decode(Consejos.self,
                                                   from: jsonData)
        cantidadDeConsejos = decodedData.cantidad
        directorio = Constantes.CONSEJOS_URL
        
        let provinciaDelUsuario: String = self.usuario.obtenerUltimaSession()?.informacionDeUsuario?.domicilio?.provincia ?? ""
        
        
        if (decodedData.provinciales != nil && provinciaDelUsuario != "" ) {
            guard let cantidadProvincial = decodedData.provinciales?[provinciaDelUsuario]?.cantidad else {return}
            guard let directorioProvincial = decodedData.provinciales?[provinciaDelUsuario]?.directorio else {return}

            let mostrarConsejoProvincial = UserDefaults.standard.bool(forKey: "mostrarConsejoProvincial")
            
            if (!mostrarConsejoProvincial) {
                // Muestro consejos provinciales.
                cantidadDeConsejos = cantidadProvincial
                directorio = Constantes.CONSEJOS_URL + directorioProvincial
            }
            UserDefaults.standard.setValue(!mostrarConsejoProvincial, forKey: "mostrarConsejoProvincial")
        }
        
    }
    
    private func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
}

//
//  ServerFachada.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import TrustKit

final class ServidorFachada: NSObject, DominioFachada {
    struct Ambiente {
        
        #if PRD
            static let `default` = Ambiente.production
        #elseif QA
            static let `default` = Ambiente.qa
        #elseif DEV
            static let `default` = Ambiente.dev
        #elseif STG
            static let `default` = Ambiente.stage
        #elseif LOCAL
            static let `default` = Ambiente.local
        #endif
        
        static let production = Ambiente(baseURL: Keys.BASE_URL, trustPolicy: [
            kTSKIncludeSubdomains: true,
            kTSKEnforcePinning: true,
            kTSKPublicKeyHashes: ["UXt/pC5LL5LT5C2ajleIfKh8FUrseWflM+tcO+284+o=",
                                  "JSMzqOOrtyOT1kmau6zKhgT676hGgczD5VMdRMyJZFA=",
                                  "++MBgDH5WGvL9Bcn5Be30cRcL0f5O+NyoXuWtQdX1aI="]
        ])
        
        static let stage = Ambiente(baseURL: Keys.BASE_URL)
        static let qa = Ambiente(baseURL: Keys.BASE_URL)
        static let dev = Ambiente(baseURL: Keys.BASE_URL)
        static let local = Ambiente(baseURL: Keys.BASE_URL)

        fileprivate var baseURL: String
        fileprivate var trustPolicy: [String: Any]
        
        fileprivate init(baseURL: String, trustPolicy: [String: Any] = [:]) {
            self.baseURL = baseURL
            self.trustPolicy = trustPolicy
        }
    }
    static let instancia = ServidorFachada()
    private var trustKit: TrustKit?
    
    var ambiente: Ambiente {
        didSet {
            httpCliente.baseURL = ambiente.baseURL
            configureSSLPinning()
        }
    }
    fileprivate lazy var httpCliente: HTTPCliente = {
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        let httpCliente = URLSessionHTTPCliente(baseURL: self.ambiente.baseURL, urlSession: urlSession)
        httpCliente.headersProvider = self
        configureSSLPinning()
        return httpCliente
    }()
    fileprivate let sesionPersitencia: SesionPersistencia
    
    private init(sesionPersitencia: SesionPersistencia = inyectar(), ambiente: Ambiente = .default) {
        self.sesionPersitencia = sesionPersitencia
        self.ambiente = ambiente
    }
}

extension DominioFachada {
    static func inyectar() -> HTTPCliente {
        return ServidorFachada.instancia.httpCliente
    }
}

extension ServidorFachada: ProvedorDeEncabezados {
    func getHeaders() -> [String : String] {
        var headers = [
            "X-App-Platform": "ios",
            "X-App-Version": Bundle.main.appVersion,
            "CovFF-MultipleCUCHs": "true"
        ]
        guard let sesion = sesionPersitencia.getSesion() else {
            return headers
        }
        headers["Authorization"] = "Basic \(sesion.authToken)"
        return headers
    }
}

extension ServidorFachada: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let pinningValidator = self.trustKit?.pinningValidator else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        if (!pinningValidator.handle(challenge, completionHandler: completionHandler)) {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

private extension ServidorFachada {
    func configureSSLPinning() {
        guard let host = URL(string: ambiente.baseURL)?.host, !self.ambiente.trustPolicy.isEmpty else {
            self.trustKit = nil
            return
        }
        self.trustKit = .init(configuration: [kTSKPinnedDomains: [host: ambiente.trustPolicy]])
    }
}


extension Bundle {
    var appVersion: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
}

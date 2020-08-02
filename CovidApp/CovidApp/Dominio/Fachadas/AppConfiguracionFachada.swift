//
//  AppConfiguracionFachada.swift
//  CovidApp
//
//  Created on 20/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol AppConfiguracionFachadaProtocolo {
    func validarSiLaAppNecesitaUpgrade(finalizacion: @escaping (_ necesitaUpgrade: Bool) -> Void)
}

extension MVPPresentador {
    static func inyectar() -> AppConfiguracionFachadaProtocolo {
        if DominioFachadaDebugging.mockFachadas {
            return MockAppConfiguracionFachada.instancia
        }
        return AppConfiguracionFachada.instancia
    }
}

private final class MockAppConfiguracionFachada: AppConfiguracionFachadaProtocolo {
    static let instancia = MockAppConfiguracionFachada()
    
    func validarSiLaAppNecesitaUpgrade(finalizacion: (Bool) -> Void) {
        finalizacion(false)
    }
}

private final class AppConfiguracionFachada: DominioFachada {
    static let instancia = AppConfiguracionFachada()
    private let httpCliente: HTTPCliente
    
    private init(httpCliente: HTTPCliente = inyectar()) {
        self.httpCliente = httpCliente
    }
}

extension AppConfiguracionFachada: AppConfiguracionFachadaProtocolo {
    func validarSiLaAppNecesitaUpgrade(finalizacion: @escaping (Bool) -> Void) {
        let solicitud = ObtenerVersion()
        let finalizacionEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        
        httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
            finalizacionEnElMainThread(respuesta.httpResponse?.statusCode == 426)
        }
    }
}

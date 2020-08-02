//
//  InformacionPBAPresentador.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol InformacionPBAPresentadorProtocolo {
    func volver()
    func irA(url:URL)
}

extension MVPVista where Self: InformacionPBAVista {
    func inyectar() -> InformacionPBAPresentadorProtocolo {
        let presentador = InformacionPBAPresentador()
        presentador.vista = self
        return presentador
    }
}

final class InformacionPBAPresentador: MVPPresentador {
    
    weak var vista: InformacionPBAVista?

    init() {
    
    }
}

extension InformacionPBAPresentador : InformacionPBAPresentadorProtocolo {
    func irA(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func escenaAparecera() {
        vista?.configurarBarraNavegacion(viewModel: .completa_pba)
    }
    
    func volver() {
        vista?.volverAtras()
    }
    func escenaCargo() {
        vista?.configurarVista()
    }
}

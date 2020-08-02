//
//  AutenticacionNumeroPresentador.swift
//  CovidApp
//
//  Created on 4/18/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol AutenticacionNumeroPresentadorProtocolo {
    func manejarBotonCerrar()
}

extension MVPVista where Self: AutenticacionNumeroTramiteVista {
    func inyectar() -> AutenticacionNumeroPresentadorProtocolo  {
        let presenter = AutenticacionNumeroPresentador()
        presenter.vista = self
        return presenter
    }
}

final class AutenticacionNumeroPresentador: MVPPresentador {
    weak var vista: AutenticacionNumeroTramiteVista?
}

extension AutenticacionNumeroPresentador: AutenticacionNumeroPresentadorProtocolo {
    
    func escenaCargo() {
        vista?.configurarVista(viewModel: crearViewModel())
    }
    
    func manejarBotonCerrar() {
        vista?.regresarAPantallaPrevia()
    }
}

private extension AutenticacionNumeroPresentador {

    func crearViewModel() -> AutenticacionNumeroTramiteViewModel {
        return AutenticacionNumeroTramiteViewModel(boton: .creatBotonTransparent(titulo: "CERRAR"),
                                                   titulo: .init(texto: "Número de trámite",
                                                                 apariencia: .init(fuente: .robotoMedium(tamaño: 20),
                                                                                   colorTexto: .grisPrincipal)))
    }
}

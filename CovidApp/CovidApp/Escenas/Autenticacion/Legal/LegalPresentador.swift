//
//  LegalPresentador.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol LegalPresentadorProtocolo {
    func aceptarTerminosYCondiciones()
    func manejarBotonAtras()
}


extension MVPVista where Self: LegalVista {
    func inyectar() -> LegalPresentadorProtocolo {
        let presenter = LegalPresentador()
        presenter.vista = self
        return presenter
    }
}

final class LegalPresentador: MVPPresentador {
    weak var vista: LegalVista?
}

extension LegalPresentador: LegalPresentadorProtocolo {
    func escenaCargo() {
        vista?.configurarVista(viewModel: formatearInformacion())
    }
    
    func escenaAparecera() {
        vista?.configurarBarraNavegacion(viewModel: .soloHeaderPrincipal)
    }
    
    func aceptarTerminosYCondiciones() {
        vista?.aceptarTerminosYCondiciones()
    }
    
    func manejarBotonAtras() {
        vista?.removerContenido()
    }
    
    func escenaDesaparecera() {
        vista?.addTransitionFromLeft()
    }
}

private extension LegalPresentador {
    func formatearInformacion() -> LegalViewModel {        
        return .init(titulo: crearTitulo(),
                     botonAceptar: .crearBotonAzul(titulo: "ENTENDIDO", estaHabilitado: true),
                     terminosUrl: crearTerminos())
    }
    
    func crearTitulo() -> LabelViewModel {
        return .init(texto: "Términos y Condiciones",
                     apariencia: .init(fuente: .robotoMedium(tamaño: 18),
                                       colorTexto: .negroPrimario))
    }
    
    func crearTerminos() -> URL? {
//      Terminos Static Web
        return URL(string: Keys.STATIC_WEB + "tyc/ultima.html")!
//        Terminos HardCode
//        return Bundle.main.url(forResource: Constantes.TERMINOS_Y_CONDICIONES_FILE_NAME, withExtension: Constantes.FILE_TYPE)
    }
}

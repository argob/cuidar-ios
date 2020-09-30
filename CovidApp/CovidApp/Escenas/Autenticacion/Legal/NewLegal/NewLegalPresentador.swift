//
//  NewLegalPresentador.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol NewLegalPresentadorProtocolo {
    func cancelar ()
}

extension MVPVista where Self: NewLegalVista {
    func inyectar() -> NewLegalPresentadorProtocolo {
        let presentador = NewLegalPresentador()
        presentador.vista = self
        return presentador
    }
}

final class NewLegalPresentador : MVPPresentador {
    weak var vista: NewLegalVista?

    private lazy var accionAbrirTerminos: (() -> Void) = { [weak self] in
        self?.vista?.mostrarTerminos()
    }

    private lazy var accionAceptarTerminos: ((Bool) -> Void) = { [weak self] (aceptado) in
        self?.vista?.cambioTerminos(aceptados: aceptado)
    }
    
    private let usuarioFachada : UsuarioFachadaProtocolo
    private let notificacionFachada: NotificacionFachadaProtocolo
    
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar(), notificacionFachada: NotificacionFachadaProtocolo = inyectar()
    ) {
        self.usuarioFachada = usuarioFachada
        self.notificacionFachada = notificacionFachada
    }
}

extension NewLegalPresentador : NewLegalPresentadorProtocolo {
    func cancelar() {
        self.notificacionFachada.desregistrarDispositivo()
        self.usuarioFachada.logout()
        vista?.logout()
    }
    
    func escenaCargo() {
        vista?.configurar(viewModel: crearTerminos())
    }
    
    func escenaDesaparecera() {
        vista?.addTransitionFromLeft()
    }
    
}

private extension NewLegalPresentador{
    func crearNuevosTerminosYCondiciones() -> URL? {
        return URL(string: Keys.STATIC_WEB + "tyc/ultima.html")!
    }
}

extension NewLegalPresentador {
    func crearTerminos() -> AceptarTerminosViewModel {
        return .init(preSeleccionado: true, accionAceptarTerminos: accionAceptarTerminos, accionMostrarTerminos: accionAbrirTerminos)
    }
}

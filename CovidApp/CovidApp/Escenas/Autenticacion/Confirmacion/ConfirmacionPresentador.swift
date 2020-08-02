//
//  ConfirmacionPresentador.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol ConfirmacionPresentadorProtocolo {
    func manejarAccionSiguiente()
    func manejarConfirmacionUsuario(viewModel: ConfirmacionUsuarioViewModel)
}

extension MVPVista where Self: ConfirmacionVista {
    func inyectar() -> ConfirmacionPresentadorProtocolo {
        let presentador = ConfirmacionPresentador()
        presentador.vista = self
        return presentador
    }
}

final class ConfirmacionPresentador: MVPPresentador {
    weak var vista: ConfirmacionVista?
    private let usuarioFachada: UsuarioFachadaProtocolo
    private var fechaNacimientoUsuario: String?
    
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar()) {
        self.usuarioFachada = usuarioFachada
    }
}

extension ConfirmacionPresentador: ConfirmacionPresentadorProtocolo {
    func manejarConfirmacionUsuario(viewModel: ConfirmacionUsuarioViewModel) {
        self.fechaNacimientoUsuario = viewModel.fechaNacimiento
    }

    func manejarAccionSiguiente() {
        vista?.irALaProximaSeccion()
    }
    
    func escenaAparecera() {
        guard let viewModel = generaViewModel() else { return }
        vista?.configurar(viewModel: viewModel)
    }
    
    private func generaViewModel() -> ConfirmacionViewModel? {
        guard let session = usuarioFachada.obtenerUltimaSession(),
            let informacionUsuario = session.informacionDeUsuario,
            let fechaNacimientoUsuario = fechaNacimientoUsuario
        else {
            return nil
        }
        let nombres = informacionUsuario.nombres
        let apellidos = informacionUsuario.apellidos
        let nombreCompleto = nombres + ", " + apellidos
        
        let titulo = LabelViewModel(texto: "Para continuar necesitamos que confirmes tus datos", apariencia: Constantes.CONFIRMACION_PRECENTADOR_TITULO)

        let botonSiguiente: BotonViewModelAccion = .crearBotonAzul(titulo: "SIGUIENTE") { [weak self] in
            self?.manejarAccionSiguiente()
        }
        
               let nombreUsuario = LabelViewModel(texto: nombreCompleto, apariencia: Constantes.CONFIRMACION_PRECENTADOR_VALOR)
        let etiquetaDNI = LabelViewModel(texto: "DNI:", apariencia: Constantes.CONFIRMACION_PRECENTADOR_ETIQUETA)
        let DNI = LabelViewModel(texto: session.dni.description, apariencia: Constantes.CONFIRMACION_PRECENTADOR_VALOR)
        let etiquetaNacimiento = LabelViewModel(texto: "Fecha de Nacimiento:", apariencia: Constantes.CONFIRMACION_PRECENTADOR_ETIQUETA)
        let fechaNacimiento = LabelViewModel(texto: fechaNacimientoUsuario.formatearFecha(de: .guiones, a: .diagonales),
                                             apariencia: Constantes.CONFIRMACION_PRECENTADOR_VALOR)
        let etiquetaGenero = LabelViewModel(texto: "Sexo:", apariencia: Constantes.CONFIRMACION_PRECENTADOR_ETIQUETA)
        let genero = LabelViewModel(texto: session.sexo.valorTexto, apariencia: Constantes.CONFIRMACION_PRECENTADOR_VALOR)
        let iconoUser = ImageViewModelo(imagen: "icon-user-dark")
        let viewModel = ConfirmacionViewModel(imagenUsuario: iconoUser,
                                              tituloPantalla: titulo,
                                              etiquetaDNI: etiquetaDNI,
                                              numeroDNI: DNI, fechaNacimiento: fechaNacimiento,
                                              genero: genero,
                                              etiquetaGenero: etiquetaGenero,
                                              etiquetaNacimiento: etiquetaNacimiento,
                                              nombreUsuario: nombreUsuario,
                                              botonSiguiente: botonSiguiente)
        
        return viewModel
    }
}

//
//  ResultadoPresentador.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

enum ResultadoModoPresentacion {
    case autoevaluacion
    case actualizar
}

protocol ResultadoPresentadorProtocolo {
    var modoPresentacion: ResultadoModoPresentacion { get set }
    func manejarBotonCerrar(esPresentado: Bool)
    func manejarBotonConIdentificador(identificador: Identificador, esPresentado: Bool)
}

extension MVPVista where Self: ResultadoVista {
    func inyectar() -> ResultadoPresentadorProtocolo  {
        let presenter = ResultadoPresentador()
        presenter.vista = self
        return presenter
    }
}

final class ResultadoPresentador: MVPPresentador {
    weak var vista: ResultadoVista?
    
    private let usuarioFachada : UsuarioFachadaProtocolo
    private var estrategia: ResultadoPresentadorEstrategia?
    var modoPresentacion: ResultadoModoPresentacion = .autoevaluacion {
        didSet {
            switch modoPresentacion{
            case .actualizar:
                self.estrategia = ResultadoMasInformación()
            case .autoevaluacion:
                self.estrategia = ResultadoAutodiagnosticoPresentador()
            }
        }
    }
       
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar()) {
        self.usuarioFachada = usuarioFachada
    }
}

extension ResultadoPresentador: ResultadoPresentadorProtocolo {
    func escenaCargo() {
        vista?.configurarTablaContenido()
        obtenerInformacion()
    }
    
    func manejarBotonCerrar(esPresentado: Bool) {
        if esPresentado {
            vista?.descartar()
        } else {
            vista?.resultadoTerminado()
        }
    }
    
    func manejarBotonConIdentificador(identificador: Identificador, esPresentado: Bool) {
        guard !esPresentado else {
            vista?.descartar()
            return
        }
        if identificador == .aceptar {
            vista?.resultadoTerminado()
        }
    }
}

private extension ResultadoPresentador {
    func obtenerInformacion() {
        guard let sesion = usuarioFachada.obtenerUltimaSession() else {
            fatalError("Nunca presentar esa pantalla cuando el usuario no ha sido diagnosticado")
        }
        self.configurarEscena(sesion: sesion)
    }
    
    func configurarEscena(sesion: Sesion) {
        guard
            let informacionUsuario = sesion.informacionDeUsuario,
            let estrategia = self.estrategia
        else { return }
        vista?.configurar(viewModel: estrategia.obtenerInformacion(informacionUsuario: informacionUsuario))
    }
}

protocol ResultadoPresentadorEstrategia {
    func obtenerInformacion(informacionUsuario: Sesion.InformacionDeUsuario) -> ResultadoViewModel
}

final class ResultadoAutodiagnosticoPresentador: ResultadoPresentadorEstrategia {
    func obtenerInformacion(informacionUsuario: Sesion.InformacionDeUsuario) -> ResultadoViewModel {
        let factoria = ResultadoFactoriaViewModels(nombre: informacionUsuario.nombres, coep: informacionUsuario.ultimoEstado.datosCoep)
        return factoria.crearViewModelResultado(diagnostico: informacionUsuario.ultimoEstado.diagnostico)
    }
}

final class ResultadoMasInformación: ResultadoPresentadorEstrategia {
    func obtenerInformacion(informacionUsuario: Sesion.InformacionDeUsuario) -> ResultadoViewModel {
        let factoria = ResultadoFactoriaViewModels(nombre: informacionUsuario.nombres, coep: informacionUsuario.ultimoEstado.datosCoep)
        return factoria.crearViewModelMasInformacion(diagnostico: informacionUsuario.ultimoEstado.diagnostico)
    }
}

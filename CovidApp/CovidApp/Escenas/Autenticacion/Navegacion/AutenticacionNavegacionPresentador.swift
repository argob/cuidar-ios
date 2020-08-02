//
//  AutenticacionNavegacionPresentador.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol AutenticacionNavegacionPresentadorProtocolo {
    func siguienteEtapa()
    func etapaAnterior()
    func iniciaIngresoManual()
    func obtenerEtapaInicial() -> AutenticacionVistasNavegacion 
}

enum DireccionNavegacion {
    case anterior(AutenticacionVistasNavegacion)
    case siguiente(AutenticacionVistasNavegacion)
}

extension MVPVista where Self: AutenticacionNavegacionVista {
    func inyectar() -> AutenticacionNavegacionPresentadorProtocolo {
        let presentador = AutenticacionNavegacionPresentador()
        presentador.vista = self
        return presentador
    }
}

private final class AutenticacionNavegacionPresentador: MVPPresentador {
    weak var vista: AutenticacionNavegacionVista?
    var etapasFlujo: [AutenticacionVistasNavegacion] = []
    private let usuarioFachada : UsuarioFachadaProtocolo
    private var etapaInicial: AutenticacionVistasNavegacion = .escanerDni
    
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar()) {
        self.usuarioFachada = usuarioFachada
    }
}

extension AutenticacionNavegacionPresentador: AutenticacionNavegacionPresentadorProtocolo {
    func obtenerEtapaInicial() -> AutenticacionVistasNavegacion {
        return etapaInicial
    }
    func etapaAnterior() {
        guard let etapaActual = etapasFlujo.popLast() else { return }
        switch etapaActual {
        case .escanerDni:
            return
        case .ingresoManual, .ingresoTelefono, .confirmacionDni:
            vista?.mostrarVista(modelo: .init(etapa: .primeraEtapa, direccion: .anterior(etapaActual)))
        case .ingresoDireccion:
            vista?.mostrarVista(modelo: .init(etapa: .segundaEtapa, direccion: .anterior(etapaActual)))
        }
    }
    
    func escenaCargo() {
        obtenerInformacion()
        etapasFlujo.append(etapaInicial)
        vista?.configurar(modelo: .init(colorHabilitado: .rosaPrincipal, colorDeshabilitado: .lightGray, etapa: .primeraEtapa))
        vista?.mostrarVista(modelo: .init(etapa: .primeraEtapa, direccion: .siguiente(etapaInicial)))
    }
    
    func escenaAparecera() {
        vista?.configurarBarraNavegacion(viewModel: .completa)
    }
    
    func siguienteEtapa() {
        guard let etapaActual = etapasFlujo.last else { return }
        switch etapaActual {
        case .escanerDni, .ingresoManual:
            etapasFlujo.append(.confirmacionDni)
            vista?.mostrarVista(modelo: .init(etapa: .primeraEtapa, direccion: .siguiente(.confirmacionDni)))
        case .confirmacionDni:
            etapasFlujo.append(.ingresoTelefono)
            vista?.mostrarVista(modelo: .init(etapa: .segundaEtapa, direccion: .siguiente(.ingresoTelefono)))
        case .ingresoTelefono:
            etapasFlujo.append(.ingresoDireccion)
            vista?.mostrarVista(modelo: .init(etapa: .terceraEtapa, direccion: .siguiente(.ingresoDireccion)))
        case .ingresoDireccion:
            return
        }
    }
    
    func iniciaIngresoManual() {
        etapasFlujo.append(.ingresoManual)
        vista?.mostrarVista(modelo: .init(etapa: .primeraEtapa, direccion: .siguiente(.ingresoManual)))
    }
}

private extension AutenticacionNavegacionPresentador {
    func obtenerInformacion() {
        guard let sesion = usuarioFachada.obtenerUltimaSession() else {
            return
        }
        self.definirEtapaInicial(sesion: sesion)
    }
    
    func definirEtapaInicial(sesion: Sesion) {
        let informacionDeUsuario = sesion.informacionDeUsuario?.terminoRegistro ?? false
        etapaInicial = informacionDeUsuario ? .ingresoTelefono : .escanerDni
    }
}


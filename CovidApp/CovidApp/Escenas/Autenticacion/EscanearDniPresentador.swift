//
//  EscanearDniPresentador.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import ZXingObjC

protocol EscanearDniPresentadorProtocolo: class{
    func recibirDatosEscaneados(resultado result: ZXResult)
}

enum BotonEscanear: String{
    case escanearFrente = "ESCANEAR FRENTE"
    case volverAEscanear = "VOLVER A ESCANEAR"
}

extension MVPVista where Self: EscanearDniVista {
    func inyectar() -> EscanearDniPresentadorProtocolo {
        let presentador = EscanearDniPresentador()
        presentador.vista = self
        return presentador
    }
}

private final class EscanearDniPresentador: MVPPresentador{
    weak var vista: EscanearDniVista?
    private let usuarioFachada : UsuarioFachadaProtocolo
    
    private lazy var accionAbrirTerminos: (() -> Void) = { [weak self] in
        self?.vista?.mostrarTerminos()
    }
    
    private lazy var accionAceptarTerminos: ((Bool) -> Void) = { [weak self] (aceptado) in
        self?.vista?.cambioTerminos(aceptados: aceptado)
    }
    
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar()) {
        self.usuarioFachada = usuarioFachada
    }
}

extension EscanearDniPresentador : EscanearDniPresentadorProtocolo {
    func escenaCargo() {
        vista?.configurar(viewModel: crearTerminos())
    }
    
    func recibirDatosEscaneados(resultado result: ZXResult) {
        let completeResult = result.text
        guard let resultComponents = completeResult?.components(separatedBy: "@"),
              resultComponents.count >= 5 else {
            return
        }
        let dni = Int(resultComponents[index: 4, default: "0"]) ?? Int(resultComponents[index: 4, default: "0"].dropFirst()) ?? 0
        let noTramite = resultComponents[index: 0, default: ""]
        let sexo: Usuario.Sexo = resultComponents[index: 3, default: "H"] == "M" ? .hombre : .mujer
        vista?.mostrarLoaderAutenticacion()
        usuarioFachada.validarRegistro(dni: dni, noTramite: Int(noTramite) ?? 0, sexo: sexo) { [weak self] (respuesta) in
            self?.formatear(estadoDelRegistro: respuesta, numeroDeTramite: noTramite)
            self?.vista?.removerLoaderAutenticacion()
        }
    }
}

private extension EscanearDniPresentador{
    func formatear(estadoDelRegistro: EstadoDelRegistro, numeroDeTramite: String) {
        switch estadoDelRegistro {
        case .habilitadoParaSerRegistrado(let usuario):
            let usuario = EscanearDniViewModels.DatosUsuario(usuario: usuario, numeroDeTramite: numeroDeTramite)
            vista?.mostrarResultadoEscaneo(resultado: .init(fechaNacimiento: usuario.fechaDeNacimiento))
        case .invalido:
            self.vista?.mostrarErrorEscaneo(estaEscondido: false, estadoBoton: BotonEscanear.volverAEscanear)
            break
        case .usuarioYaRegistrado(_):
            vista?.mostrarResultadoEscaneoUsuarioExistente()
        }
    }
}

private extension Array {
    subscript(index index: Index, default default: Element) -> Element {
        return indices.contains(index) ? self[index] : `default`
    }
}

extension EscanearDniPresentador {
    func crearTerminos() -> AceptarTerminosViewModel {
        return .init(preSeleccionado: true, accionAceptarTerminos: accionAceptarTerminos, accionMostrarTerminos: accionAbrirTerminos)        
    }
}

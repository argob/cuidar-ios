//
//  TelefonoContactoPresentador.swift
//  CovidApp
//
//  Created on 6/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol TelefonoContactoPresentadorProtocolo {
    func actualizarTelefono(telefono:String)
    func validarTelefono(identificador: TiposDeElementosDeFormulario, valor:String?)
}

extension MVPVista where Self: TelefonoContactoVista {
    func inyectar() -> TelefonoContactoPresentadorProtocolo {
        let presentador = TelefonoContactoPresentador()
        presentador.vista = self
        return presentador
    }
}


final class TelefonoContactoPresentador: MVPPresentador {
    weak var vista: TelefonoContactoVista?
    
    private let usuarioFachada: UsuarioFachadaProtocolo = inyectar()
    private let domicilioFachada: DomicilioFachadaProtolo = inyectar()
    private let validador: FormularioValidador = .init()

    var datosContacto: DatosDeContacto
    
    init() {
        datosContacto = DatosDeContacto(con: usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario)
    }
}
private extension TiposDeElementosDeFormulario {
    static let ingresoManualCasos: [TiposDeElementosDeFormulario] = [.telefono]
}

extension TelefonoContactoPresentador : TelefonoContactoPresentadorProtocolo {
    func escenaCargo() {
        self.vista?.configurarVista(modelo: TelefonoContactoViewModel(telefono: self.usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario?.telefono ?? ""))
    }
    
    func validarTelefono(identificador: TiposDeElementosDeFormulario, valor: String?) {
        guard let valor = valor else {
            return
        }
        var reglas:[Reglas]
        
        switch identificador {
        case .telefono:
            reglas = [.codigoPais, .noVacio, .telefonoValido]
        default:
            reglas = []
        }
        if let error = validador.validar(texto: valor, con: reglas){
            remover(identificador: identificador, mensaje: error)
        } else {
            procesar(identificador: identificador, valor: valor)
        }
    }
    
    func remover(identificador: TiposDeElementosDeFormulario, mensaje: String) {
        vista?.mostrarError(identificador: identificador, mensaje: mensaje)
        vista?.deshabilitarConfirmar(colorFondo: Constantes.COLOR_DESHABILITADO)
    }
    
    func procesar(identificador: TiposDeElementosDeFormulario, valor: String) {
        vista?.removerError(identificador: identificador)
        vista?.habilitarConfirmar(colorFondo:Constantes.COLOR_HABILITADO)
    }    
    
    func actualizarTelefono(telefono:String) {
        guard
            let numero = datosContacto.numero,
            let calle = datosContacto.calle,
            let localidad = datosContacto.localidad,
            let provincia = datosContacto.provincia,
            datosContacto.direccionEsValida(),
            !telefono.isEmpty
        else {
            return
        }
        if (telefono == datosContacto.telefono) {
            // No cambió el teléfono.
            self.vista?.telefonoConfirmado()
        } else {
            // Cambió el teléfono, hay que informar al backend.
            vista?.mostrarLoader()
            let domicilioEnFormulario = Domicilio(provincia: provincia,
                                                localidad: localidad,
                                                calle: calle,
                                                numero: numero,
                                                piso: datosContacto.piso,
                                                puerta: datosContacto.puerta,
                                                codigoPostal: datosContacto.codigoPostal,
                                                otros: datosContacto.otros)

            let domicilio = domicilioFachada.normalizar(domicilio: domicilioEnFormulario)
            // Intentamos actualizar el nuevo teléfono del
            // usuario en el backend.
            usuarioFachada.registrarUsuario(
              domicilio: domicilio,
              telefono: telefono
            ) { [weak self] (respuesta) in
                  if respuesta {
                    // OK, seguimos adelante.
                    self?.vista?.ocultarLoader()
                    self?.vista?.telefonoConfirmado()
                  } else {
                    // Reintentamos una vez.
                    self?.usuarioFachada.registrarUsuario(
                                 domicilio: domicilio,
                                 telefono: telefono
                               ) { [weak self] (respuesta) in
                                    // OK, seguimos adelante.
                                    self?.vista?.ocultarLoader()
                                    self?.vista?.telefonoConfirmado()
                               }
                    // Si falla el segundo intento, ignoramos.
                    // TODO: sugerirle al usuario que haga él el llamado.
                }
            }
        }
    }
}

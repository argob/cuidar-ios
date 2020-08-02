//
//  AlertaErrorEjecutarClienteViewModel.swift
//  CovidApp
//
//  Created on 4/18/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct AlertaErrorEjecutarClienteViewModel {
    let titulo: String
    let mensaje: String
    let tituloAceptar: String
    let tituloReintentar: String
    let accionAlReintentar: (() -> Void)?
}

extension AlertaErrorEjecutarClienteViewModel {
    static func crearAlertaDeConexion(accion: (() -> Void)?) -> AlertaErrorEjecutarClienteViewModel {
        return crearAlertaReintentable(mensaje: "Por favor, revise su conexion a internet", accion: accion)
    }
    
    static func crearAlertaReintentable(mensaje: String, accion: (() -> Void)?) -> AlertaErrorEjecutarClienteViewModel {
         return AlertaErrorEjecutarClienteViewModel(titulo: "COVID19 -\nMinisterio de Salud",
                                                    mensaje: mensaje,
                                                    tituloAceptar: "ACEPTAR",
                                                    tituloReintentar: "REINTENTAR",
                                                    accionAlReintentar: accion)
     }
}

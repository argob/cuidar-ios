//
//  AlertaDesvincularDNI.swift
//  CovidApp
//
//  Created on 20/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct AlertaDesvincularDNIViewModel {
    let titulo: String
    let mensaje: String
    let tituloAceptar: String
    let tituloCancelar: String
    let accionAceptar: (() -> Void)?
}

extension AlertaDesvincularDNIViewModel {
    
    static func CrearAlertaDesvincularDNI(mensaje: String, accion: (() -> Void)?) -> AlertaDesvincularDNIViewModel {
         return AlertaDesvincularDNIViewModel(titulo: "¿Desvincular el DNI?",
                                                    mensaje: mensaje,
                                                    tituloAceptar: "Aceptar",
                                                    tituloCancelar: "Cancelar",
                                                    accionAceptar: accion)
     }
}

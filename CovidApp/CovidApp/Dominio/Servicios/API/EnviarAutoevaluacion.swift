//
//  EnviarAutoevaluacion.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct EnviarAutoevaluacion: HTTPSolicitud {
    typealias Cuerpo = Autoevaluacion
    struct Respuesta: Codable {
        enum CodingKeys: String, CodingKey {
            case dni
            case sexo
            case estadoActual = "estado-actual"
        }
        var dni: Int
        var sexo: Usuario.Sexo
        var estadoActual: Estado
    }
    
    let urlPath: String
    let metodo: HTTPMetodo = .post
    let cuerpo: Cuerpo?
    
    init(dni: Int, sexo: Usuario.Sexo, autoevaluacion: Autoevaluacion) {
        urlPath = "/usuarios/\(dni)/autoevaluaciones?sexo=\(sexo.rawValue)"
        cuerpo = autoevaluacion
    }
}

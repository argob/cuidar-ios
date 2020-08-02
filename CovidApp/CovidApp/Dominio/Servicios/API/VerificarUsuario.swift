//
//  ObtenerUsuario.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct VerificarUsuario: HTTPSolicitud {
    typealias Respuesta = Usuario
    struct Cuerpo: Codable {
    }
    
    let urlPath: String
    let metodo: HTTPMetodo = .get
    let cuerpo: Cuerpo? = nil
    
    init(dni: Int, sexo: Usuario.Sexo) {
        urlPath = "/usuarios/\(dni)?sexo=\(sexo.rawValue)"
    }
}

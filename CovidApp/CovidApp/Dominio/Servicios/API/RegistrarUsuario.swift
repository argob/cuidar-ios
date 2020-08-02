//
//  RegistrarUsuario.swift
//  CovidApp
//
//  Created on 9/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct RegistrarUsuario: HTTPSolicitud {
    struct Cuerpo: Codable {
        enum CodingKeys: String, CodingKey {
            case telefono
            case domicilio
        }
        /// Telefono en formato +541122223333
        var telefono: String
        var domicilio: Domicilio
    }
    typealias Respuesta = Usuario
    
    let urlPath: String
    let cuerpo: Cuerpo?
    let metodo: HTTPMetodo = .patch
    
    init(dni: Int, sexo: Usuario.Sexo, cuerpo: Cuerpo) {
        urlPath = "/usuarios/\(dni)?sexo=\(sexo.rawValue)"
        self.cuerpo = cuerpo
    }
}

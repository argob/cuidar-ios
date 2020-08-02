//
//  ObtenerVersion.swift
//  CovidApp
//
//  Created on 20/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct ObtenerVersion: HTTPSolicitud {
    struct Cuerpo: Codable {
    }
    struct Respuesta: Codable {
        enum CodingKeys: String, CodingKey {
            case version = "version-ios"
        }
        
        var version: String
    }
    
    let urlPath: String = "/versiones"
    let metodo: HTTPMetodo = .get
    let cuerpo: Cuerpo? = nil
}

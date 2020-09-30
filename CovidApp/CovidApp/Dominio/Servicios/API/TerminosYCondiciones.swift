//
//  TerminosYCondiciones.swift
//  CovidApp
//
//  Created by Ivan Schaab on 9/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import Foundation

struct ObtenerTerminosYCondiciones: HTTPSolicitud {
    struct Cuerpo: Codable {
    }
    struct Respuesta: Codable {
        enum CodingKeys: String, CodingKey {
            case ultimoAceptado = "ultimo_aceptado"
            case ultimoDisponible = "ultimo_disponible"
            case delta = "delta"
        }
        
        var ultimoAceptado: Int
        var ultimoDisponible: Int
        var delta: String
    }
    let encabezados: [String : String]
    let urlPath: String = "/tyc"
    let metodo: HTTPMetodo = .get
    let cuerpo: Cuerpo? = nil
}

struct AceptarTerminosYCondiciones: HTTPSolicitud {
    struct Cuerpo: Codable {
    }
    
    struct Respuesta: Codable {
        enum CodingKeys: String, CodingKey {
            case ultimoAceptado = "ultimo_aceptado"
            case ultimoDisponible = "ultimo_disponible"
            case delta = "delta"
        }
        
        var ultimoAceptado: Int
        var ultimoDisponible: Int
        var delta: String
    }
    
    let encabezados: [String : String]
    let urlPath: String
    let metodo: HTTPMetodo = .put
    let cuerpo: Cuerpo? = nil
    
    init(version: Int, encabezados: [String : String]) {
        self.urlPath = "/tyc/\(version)"
        self.encabezados = encabezados
    }
}

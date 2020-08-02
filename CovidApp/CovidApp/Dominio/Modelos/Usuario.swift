//
//  Usuario.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct Usuario: Codable {
    enum CodingKeys: String, CodingKey {
        case dni
        case sexo
        case fechaDeNacimiento = "fecha-nacimiento"
        case nombres
        case apellidos
        case estadoActual = "estado-actual"
        case telefono
        case domicilio
    }
    enum Sexo: String, Codable {
        case hombre = "M"
        case mujer = "F"
        
        var valorTexto: String {
            switch self {
            case .hombre:
                return "Masculino"
            case .mujer:
                return "Femenino"
            }
        }
        func get() -> String {
            switch self {
            case .hombre:
                return "M"
            case .mujer:
                return "F"
            }
        }

    }
    var dni: Int
    var sexo: Sexo
    var fechaDeNacimiento: String // YYYY-MM-DD
    var nombres: String
    var apellidos: String
    var estadoActual: Estado
    
    var telefono: String?
    var domicilio: Domicilio?
}

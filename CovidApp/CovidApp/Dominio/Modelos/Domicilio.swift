//
//  Domicilio.swift
//  CovidApp
//
//  Created on 9/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct Domicilio: Codable {
    private enum CodingKeys: String, CodingKey {
        case provincia
        case localidad
        case departamento
        case calle
        case numero
        case piso
        case puerta
        case codigoPostal = "codigo-postal"
        case otros
    }
    var provincia: String = ""
    var localidad: String = ""
    var departamento: String = ""
    var calle: String = ""
    var numero: String = ""
    var piso: String?
    var puerta: String?
    var codigoPostal: String?
    var otros: String?

    func esValida() -> Bool {
        return provincia != "" &&
        localidad != "" &&
        calle != "" &&
        numero != ""
    }
}

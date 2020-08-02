//
//  Provincia.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct DatosProvincias: Codable {
    var provincias: [Provincia]
}

struct Provincia: CiudadProvincia, Codable, CountryRegionComparable {
    var id: String
    var nombre: String
    
    func obtenerIdentificador() -> String {
        return id
    }
    
    func obtenerNombre() -> String {
        return nombre
    }
}

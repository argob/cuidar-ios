//
//  Ciudad.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct DatosCiudades: Codable {
    var localidades: [Ciudad]
}

struct Ciudad: CiudadProvincia, Codable, CountryRegionComparable {
    enum CodingKeys: String, CodingKey {
        case id
        case nombre
        case departamentoID = "departamento_id"
        case departamentoNombre = "departamento_nombre"
        case localidadCensalID = "localidad_censal_id"
        case localidadCensalNombre = "localidad_censal_nombre"
        case provinciaID = "provincia_id"
        case provinciaNombre = "provincia_nombre"
    }
    private static let ciudadDepartamentoSeparador = " - "
    
    var id: String
    var nombre: String
    var departamentoID: String
    var departamentoNombre: String
    var localidadCensalID: String
    var localidadCensalNombre: String
    var provinciaID: String
    var provinciaNombre: String
    
    static func extraerCiudad(nombreCiudadDepartamento: String) -> String {
        return nombreCiudadDepartamento.components(separatedBy: Ciudad.ciudadDepartamentoSeparador).first ?? ""
    }
    
    static func extraerDepartamento(nombreCiudadDepartamento: String) -> String {
        return nombreCiudadDepartamento.components(separatedBy: Ciudad.ciudadDepartamentoSeparador).last ?? ""
    }
    
    func obtenerIdentificador() -> String {
        return id
    }
    
    func obtenerNombre() -> String {
        return nombre.capitalized + Ciudad.ciudadDepartamentoSeparador + departamentoNombre.capitalized
    }
}

//
//  CiudadProvincia.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol CiudadProvincia {
    func obtenerIdentificador() -> String
    func obtenerNombre() -> String
}

protocol CountryRegionComparable: Comparable {
    var id: String {get set}
    var nombre: String {get set}
}

extension CountryRegionComparable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.nombre < rhs.nombre
    }
}

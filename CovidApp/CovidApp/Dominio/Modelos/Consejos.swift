//
//  Consejos.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

struct Consejos: Codable {
    let cantidad: Int
    let provinciales: Dictionary<String,ConsejoProvincial>?
}

struct ConsejoProvincial: Codable {
    let cantidad: Int
    let directorio: String
}

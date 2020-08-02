//
//  ExtensionString.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

enum FormatoDeFechas: String {
    case diagonales = "dd/MM/yyyy"
    case guiones = "yyyy-MM-dd"
}

extension String {
    
    var boolValue: Bool? {
        switch self.lowercased() {
         case "true", "t", "yes", "y", "1":
             return true
         case "false", "f", "no", "n", "0":
             return false
         default:
             return nil
        }
    }
    
    func formatearFecha(de formatoActual: FormatoDeFechas, a nuevoFormato: FormatoDeFechas) -> String {
        let formateador = DateFormatter()
        formateador.dateFormat = formatoActual.rawValue
        guard let fecha = formateador.date(from: self) else {
            return self
        }
        
        formateador.dateFormat = nuevoFormato.rawValue
        return formateador.string(from: fecha)
    }
}

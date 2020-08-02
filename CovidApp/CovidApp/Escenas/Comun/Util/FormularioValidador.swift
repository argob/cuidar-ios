//
//  FormularioValidador.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

final class FormularioValidador {
    func validar(texto: String, con reglas: [Reglas]) -> String? {
        return reglas.compactMap({ $0.check(texto) }).first
    }

    func validar(input: UITextField, con reglas: [Reglas]) -> String? {
        guard let mensaje = validar(texto: input.text ?? "", con: reglas) else {
            return nil
        }

        return mensaje
    }
}

struct Reglas {

    let check: (String) -> String?

    static let noVacio = Reglas(check: {
        return $0.isEmpty ? "No debe estar vacío." : nil
    })

    static let longitudDNI = Reglas { (DNI) -> String? in
        let regex = #"[0-9]{7,8}"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: DNI) ? nil : "Debés ingresar entre 7 y 8 caracteres"
    }

    static let longitudNumeroTramite = Reglas {(tramite) -> String? in
        let regex = #"[0-9]{1,11}"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: tramite) ? nil : "Máximo 11 caracteres"
    }

    static let longitudCalle = Reglas {(calle) -> String? in
        guard 1...70 ~= calle.count else {
            return "Máximo 70 caracteres"
        }
        let regex = #"[A-ZÀ-ÖØ-öø-ÿa-z0-9_ ]{1,70}"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: calle) ? nil : "Caracteres inválidos"
    }

    static let longitudNumero = Reglas {(numero) -> String? in
        let regex = #"[0-9]{1,8}"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: numero) ? nil : "Máximo 8 caracteres"
    }

    static let longitudaCodigoPostal = Reglas {(codigo) -> String? in
        let regex = #"[0-9]{4}"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: codigo) ? nil : "Ingresá 4 caracteres"
    }

    static let longitudAlfanumerico20 = Reglas(check: {
        let emojiLimite = 0x238C
        guard $0.count <= 20 else {
            return "Máximo 20 caracteres"
        }
        let esValido = $0.unicodeScalars.filter { (scalar) -> Bool in
            scalar.properties.isEmoji && scalar.value > emojiLimite
        }.count == 0
        return esValido ? nil : "Caracteres inválidos"
    })

    static let longitudAlfanumerico70 = Reglas(check: {
        let emojiLimite = 0x238C
        guard $0.count <= 20 else {
            return "Máximo 20 caracteres"
        }
        let esValido = $0.unicodeScalars.filter { (scalar) -> Bool in
            scalar.properties.isEmoji && scalar.value > emojiLimite
        }.count == 0
        return esValido ? nil : "Caracteres inválidos"
    })

    static let emailValido = Reglas(check: {
        let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "Debe tener un email válido."
    })

    static let codigoPais = Reglas(check: {
        let regex = #"^\+\d+.*"#

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "Debe tener código de país."
    })
    
    static let soloNumeros = Reglas(check: {
        let regex = #"^[1-9][0-9]*$"#
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "No puede empezar con un cero."
    })

    static let telefonoValido = Reglas { (telefono) -> String? in
        let regex = "\\+54[0-9]{6,13}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: telefono) ? nil : "Este campo es obligatorio."
    }
}

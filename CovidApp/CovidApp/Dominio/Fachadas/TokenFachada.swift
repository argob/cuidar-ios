//
//  TokenFachada.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import SwiftOTP

protocol TokenFachadaProtocolo {
    func generarTokenDinamico() -> (token: String, segundoToken: String, tercerToken: String)?
}

extension MVPPresentador {
    static func inyectar() -> TokenFachadaProtocolo {
        return TokenFachada.instancia
    }
}

//Este código permite verificar a simple vista, aún sin escanear el QR y a una distancia razonable, que el usuario tiene instalada la aplicación con el objetivo de disminuir la posibilidad que una persona circule con una captura de pantalla.
//Es una alternativa más fácil de leer (3 dígitos hexadecimales grandes) a la fecha y hora del dispositivo para que sea visible a la medida de distanciamiento social recomendada.
private final class TokenFachada: TokenFachadaProtocolo {
    
    fileprivate static let instancia = TokenFachada()
    
    func generarTokenDinamico() -> (token: String, segundoToken: String, tercerToken: String)? {
        guard let tokens = crear(secreto: Obfuscator().reveal(key:Keys.TOKEN_KEY)) else {
            assertionFailure("Error con la generacion del token")
            return nil
        }
        return (tokens.posicion1.hexaStringed(), tokens.posicion2.hexaStringed(), tokens.posicion3.hexaStringed())
    }
}

private extension TokenFachada {
    func crear(secreto: String) -> (posicion1: Int, posicion2: Int, posicion3: Int)? {
        guard let data = base32DecodeToData(secreto),
            let topt = TOTP(secret: data, digits: Constantes.TOKEN_DIGITS, timeInterval: Constantes.TOKEN_TIME_INTERVAL),
            let otpString = topt.generate(time: Date()),
            let otpInt = Int(otpString) else {
                return nil
        }
        let token = otpInt & 0x0FFF
        return (((token & 0x0F00) / 0x100), ((token & 0xF0) / 0x10), (token & 0xF))
    }
}

fileprivate extension Int {
    func hexaStringed() -> String {
        return String(format: "%X", self)
    }
}

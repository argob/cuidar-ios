//
//  GenerarToken.swift
//  CovidApp
//
//  Created on 15/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import CryptoSwift

struct GenerarToken: HTTPSolicitud {
    struct Cuerpo: Codable {
        var dni: Int
        var sexo: Usuario.Sexo
        var tramite: Int
        var hash: String
    }
    struct Respuesta: Codable {
        var token: String
        var refresh_token: String
    }
    let urlPath: String = "/autorizacion_v3"
    let metodo: HTTPMetodo = .post
    let cuerpo: Cuerpo?
    
    init(dni: Int, sexo: Usuario.Sexo, tramite: Int) {
 
        let hash = (Obfuscator().reveal(key: Keys.API_KEY) + "-" + String(dni) + "-" + String(tramite) + "-" + sexo.get()).sha256()

        self.cuerpo = .init(dni: dni, sexo: sexo, tramite: tramite, hash: hash)

    }
}



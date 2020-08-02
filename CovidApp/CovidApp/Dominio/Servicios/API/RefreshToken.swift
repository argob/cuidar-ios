//
//  RefreshToken.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import Foundation

struct RefreshToken: HTTPSolicitud {
    struct Cuerpo: Codable {
        var hash: String
        var refresh_token: String
    }
    struct Respuesta: Codable {
        var token: String
    }
    let urlPath: String = "/refresh_token_v3"
    let metodo: HTTPMetodo = .post
    let cuerpo: Cuerpo?
    
    init(hash: String, refreshToken:String) {
        self.cuerpo = .init(Cuerpo.init(hash: hash, refresh_token: refreshToken))
    }
}



//
//  DesregistrarDispositivo.swift
//  CovidApp
//
//  Created on 20/05/2020.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct DesregistrarDispositivo: HTTPSolicitud {
    struct Cuerpo: Codable {
        enum CodingKeys: String, CodingKey {
            case deviceId = "id-app"
        }
        var deviceId: String
    }
    struct Respuesta: Codable {
    }
    
    let urlPath: String
    let cuerpo: Cuerpo?
    let metodo: HTTPMetodo = .post
    
    init(dni: Int, sexo: Usuario.Sexo, deviceId: String) {
        urlPath = "/usuarios/\(dni)/notificaciones/desregistrar?sexo=\(sexo.rawValue)"
        self.cuerpo = Cuerpo(deviceId: deviceId)
    }
}

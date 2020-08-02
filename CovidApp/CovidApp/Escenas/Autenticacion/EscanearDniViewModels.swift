//
//  EscanearDniViewModels.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct EscanearDniViewModels {
    struct DatosUsuario {
        var dni: String
        var numeroDeTramite: String
        var fechaDeNacimiento: String
        var genero: String
        var sexo: String
        var nombreCompleto: String
    }
}

extension EscanearDniViewModels.DatosUsuario {
    init(usuario: Usuario, numeroDeTramite: String) {
        self.numeroDeTramite = numeroDeTramite
        self.dni = String(usuario.dni)
        self.fechaDeNacimiento = usuario.fechaDeNacimiento
        self.sexo = usuario.sexo.descripcionParaElUsuario
        self.genero = "\(self.sexo)".capitalized
        self.nombreCompleto = usuario.nombres + " " + usuario.apellidos
    }
}

private extension Usuario.Sexo {
    var descripcionParaElUsuario: String {
        switch self {
        case .hombre:
            return "hombre"
        case .mujer:
            return "mujer"
        }

    }
}

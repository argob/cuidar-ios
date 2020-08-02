//
//  Session.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct Sesion: Codable {
    struct InformacionDeUsuario: Codable {
        var nombres: String
        var apellidos: String
        var ultimoEstado: Estado
        var terminoRegistro: Bool
        var fechaDeNacimiento: String
        var telefono: String?
        var domicilio: Domicilio?
        var edad: Int {
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd" // Formato: 2001-01-01
            let calendar = Calendar.current
            guard let fechaDeNacimientoDate = formater.date(from: fechaDeNacimiento) else { return 0 }
            let components = calendar.dateComponents([.year], from: fechaDeNacimientoDate, to: Date())
            return components.year ?? 0
        }
    }
    var dni: Int
    var sexo: Usuario.Sexo
    var authToken: String
    var hash: String
    var authRefreshToken: String
    var informacionDeUsuario: InformacionDeUsuario?
}

extension Sesion {
    func actualizarConUsuario(_ usuario: Usuario) -> Sesion {
        var nuevaSession = self
        nuevaSession.informacionDeUsuario = .init(usuario: usuario)
        return nuevaSession
    }
    
    func actualizarConEstado(_ estado: Estado) -> Sesion {
        var nuevaSession = self
        nuevaSession.informacionDeUsuario?.ultimoEstado = estado
        return nuevaSession
    }
}

extension Sesion.InformacionDeUsuario {
    init(usuario: Usuario) {
        self.init(
            nombres: usuario.nombres,
            apellidos: usuario.apellidos,
            ultimoEstado: usuario.estadoActual,
            terminoRegistro: usuario.domicilio != nil,
            fechaDeNacimiento: usuario.fechaDeNacimiento,
            telefono: usuario.telefono,
            domicilio: usuario.domicilio
        )
    }
}

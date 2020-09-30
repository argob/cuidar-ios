//
//  Estado.swift
//  CovidApp
//
//  Created on 9/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct Estado: Codable {
    private enum CodingKeys: String, CodingKey {
        case diagnostico = "nombre-estado"
        case vencimiento = "fecha-hora-vencimiento"
        case permisoDeCirculacion = "permiso-circulacion"
        case permisosDeCirculacion = "permisos-circulacion"
        case datosCoep = "datos-coep"
        case pims
    }
    enum Diagnostico: String, Codable, Equatable {
        case debeAutodiagnosticarse = "DEBE_AUTODIAGNOSTICARSE"
        case noInfectado = "NO_INFECTADO"
        case noContagioso = "NO_CONTAGIOSO"
        case infectado = "INFECTADO"
        case derivadoASaludLocal = "DERIVADO_A_SALUD_LOCAL"
    }
    struct Pims: Codable {
        var tag: String
        var motivo: String
    }
    struct PermisoDeCirculacion: Codable {
        private enum CodingKeys: String, CodingKey {
            case vencimiento = "fecha-vencimiento-permiso"
            case tipoActividad = "tipo-actividad"
            case motivoCirculacion = "motivo-circulacion"
            case idCertificado = "id-certificado"
            case patente = "patente"
            case sube = "sube"
            case qrURL = "url-qr"
        }
        var vencimiento: String? // Fecha de vencimiento, en formato YYYY-MM-DDTHH:mm:ss
        var tipoActividad: String?
        var motivoCirculacion: String?
        var idCertificado: Int?
        var patente: String?
        var sube: String?
        var qrURL: String?
    }
    struct DatosCoep: Codable {
        private enum CodingKeys: String, CodingKey {
            case provincia = "coep"
            case telefono = "informacionDeContacto"
        }
        var provincia: String
        var telefono: String
    }
    
    var diagnostico: Diagnostico
    var vencimiento: String?
    var permisoDeCirculacion: PermisoDeCirculacion?
    var permisosDeCirculacion: [PermisoDeCirculacion]?
    var datosCoep: DatosCoep?
    var pims: Pims?
}

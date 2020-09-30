//
//  Autoevaluacion.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct ItemAutoevaluable: Codable {
    var id: String
    var descripcion: String
    var descripcionDelUsuario: String
}

extension ItemAutoevaluable {
    init(id: String, descripcion: String) {
        self.id = id
        self.descripcion = descripcion
        self.descripcionDelUsuario = descripcion
    }
}

struct ItemAutoevaluado: Codable {
    var id: String
    var descripcion: String
    var valor: String?
    
    init(item: ItemAutoevaluable, valor: Bool?) {
        self.id = item.id
        self.descripcion = item.descripcion
        set(valor: valor)
    }
    
    mutating func set(valor: Bool?) {
        self.valor = valor.map { $0 ? "true" : "false" }
    }
    
    func getValor() -> Bool {
        guard let uValor = valor else { return false }
        return Bool(uValor) ?? false
    }
}

extension ItemAutoevaluable {
    private static let dolorDeGarganta = ItemAutoevaluable(
        id: "S_DDG",
        descripcion: "Dolor de garganta",
        descripcionDelUsuario: "¿Tenés dolor de garganta?"
    )
    private static let tos = ItemAutoevaluable(
       id: "S_TOS",
       descripcion: "Tos",
       descripcionDelUsuario: "¿Tenés tos?"
   )
    private static let dificultadRespiratoria = ItemAutoevaluable(
        id: "S_DRE",
        descripcion: "Dificultad respiratoria",
        descripcionDelUsuario: "¿Tenés dificultad respiratoria o falta de aire?"
    )
    private static let perdidaOlfato = ItemAutoevaluable(
        id: "S_PDO",
        descripcion: "Pérdida de olfato",
        descripcionDelUsuario: "¿Percibiste una marcada pérdida del olfato de manera repentina?"
    )
    private static let perdidaGusto = ItemAutoevaluable(
        id: "S_PDG",
        descripcion: "Pérdida de gusto",
        descripcionDelUsuario: "¿Percibiste una marcada pérdida del gusto (sabor de los alimentos) de manera repentina?"
    )
    private static let dolorCabeza = ItemAutoevaluable(
        id: "S_DDC",
        descripcion: "Dolor de cabeza",
        descripcionDelUsuario: "¿Tenés dolor de cabeza?"
    )
    private static let vomitos = ItemAutoevaluable(
        id: "S_VMT",
        descripcion: "Vómitos",
        descripcionDelUsuario: "¿Tenés vómitos?"
    )
    private static let diarrea = ItemAutoevaluable(
        id: "S_DRA",
        descripcion: "Diarrea",
        descripcionDelUsuario: "¿Tenés diarrea?"
    )
    private static let dolorMuscular = ItemAutoevaluable(
        id: "S_DMS",
        descripcion: "Dolor muscular",
        descripcionDelUsuario: "¿Tenés dolor muscular?"
    )
    static let sintomas: [ItemAutoevaluable] = [.perdidaOlfato, .perdidaGusto, .dolorDeGarganta, .tos, .dificultadRespiratoria, .dolorCabeza, .vomitos, .diarrea, .dolorMuscular]
}

extension ItemAutoevaluable {
    private static let emabarazada = ItemAutoevaluable(
        id: "A_EMB",
        descripcion: "Estoy embarazada"
    )
    private static let cancer = ItemAutoevaluable(
        id: "A_CAN",
        descripcion: "Tengo/tuve cáncer"
    )
    private static let diabetes = ItemAutoevaluable(
        id: "A_DIA",
        descripcion: "Tengo diabetes"
    )
    private static let enfermedadHepatica = ItemAutoevaluable(
        id: "A_HEP",
        descripcion: "Tengo enfermedad hepática",
        descripcionDelUsuario: "Tengo alguna enfermedad hepática"
    )
    private static let enfermedadRenal = ItemAutoevaluable(
        id: "A_REN",
        descripcion: "Tengo enfermedad renal crónica",
        descripcionDelUsuario: "Tengo enfermedad renal crónica"
    )
    private static let enfermedadRespiratoria = ItemAutoevaluable(
        id: "A_RES",
        descripcion: "Tengo enfermedad respiratoria",
        descripcionDelUsuario: "Tengo alguna enfermedad respiratoria"
    )
    private static let enfermedadCardiaca = ItemAutoevaluable(
        id: "A_CAR",
        descripcion: "Tengo enfermedad cardiológica",
        descripcionDelUsuario: "Tengo alguna enfermedad cardiológica"
    )
    private static let trabajoConPositivo = ItemAutoevaluable(
        id: "A_CE1",
        descripcion: "Trabajo o convivo con caso confirmado",
        descripcionDelUsuario: "¿Trabajás o convivís con una persona que actualmente sea caso confirmado COVID-19?"
    )
    private static let contactoCercano = ItemAutoevaluable(
        id: "A_CE2",
        descripcion: "Contacto estrecho esporádico con confirmado",
        descripcionDelUsuario: "¿Pasaste en los últimos 14 días al menos 15 minutos cerca de una persona que actualmente sea caso confirmado COVID-19?"
    )
    private static let bajaDefensas = ItemAutoevaluable(
       id: "A_BD",
       descripcion: "Tengo condición que baja las defensas",
       descripcionDelUsuario: "Tengo alguna condición que baja las defensas"
    )
    static let antecedentes: [ItemAutoevaluable] = [
        .trabajoConPositivo, .contactoCercano, .emabarazada, .cancer, .diabetes, .enfermedadHepatica, .enfermedadRenal, .enfermedadRespiratoria, .enfermedadCardiaca, .bajaDefensas
    ]
}

struct Autoevaluacion: Codable {
    
    enum CodingKeys: String, CodingKey {
        case temperatura, sintomas, antecedentes
        case coordenadas = "geo"
    }
    
    var temperatura: Double
    var sintomas: [ItemAutoevaluado]
    var antecedentes: [ItemAutoevaluado]
    var coordenadas: GeoLocalizacion?
}

//
//  FormateadorTiempoRestante.swift
//  CovidApp
//
//  Created on 16/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct TiempoRestante {
    var numero: Int
    var referencia: Calendar.Component
    var vencido: Bool
    
    init(numero: Int,
         referencia: Calendar.Component,
         vencido: Bool = false) {
        self.numero = numero
        self.referencia = referencia
        self.vencido = vencido
    }
}

final class FormateadorTiempoRestante {
    private lazy var formateadoresDeFecha: [DateFormatter] = {
        ["yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
         "yyyy-MM-dd'T'HH:mm:ssXXXXX"].map {
            let formater = DateFormatter()
            formater.locale = Locale(identifier: "en_US_POSIX")
            formater.dateFormat = $0
            return formater}
    }()
    
    func ejecutar(fecha: String) -> TiempoRestante? {
        guard
            let components = componentsFromDate(fecha: fecha)
            else {
                return nil
        }
        
        if let day = components.day, day >= 2 {
            return .init(numero: day, referencia: .day)
        } else if let horas = components.hour, horas >= 1 {
            return .init(numero: horas + ((components.day ?? 0) * 24), referencia: .hour)
        } else if let minutos = components.minute, minutos > 0 {
            return .init(numero: minutos, referencia: .minute)
        } else {
            return .init(numero: 0, referencia: .minute, vencido: true)
        }
    }
    
    func obtenerfechaDesdeString(fechaString: String) -> Date? {
        guard
            let fechaVigencia: Date = formateadoresDeFecha.reduce(into: nil, { $0 = $0 ?? $1.date(from: fechaString)})
            else {
                return nil
        }
        return fechaVigencia
    }
}

private extension FormateadorTiempoRestante {
    func componentsFromDate(fecha: String) -> DateComponents? {
        guard
            let fechaVigencia: Date = formateadoresDeFecha.reduce(into: nil, { $0 = $0 ?? $1.date(from: fecha)})
            else {
                return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: fechaVigencia)
        return components
    }
}

extension Calendar.Component {
    func description() -> String {
        switch self {
        case .minute:
            return "Minutos"
        case .hour:
            return "Horas"
        case .day:
            return "Días"
        default:
            return ""
        }
    }
}

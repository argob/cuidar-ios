//
//  DominioFachada.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol DominioFachada {
}

struct DominioFachadaDebugging {
    static var mockFachadas: Bool {
        return ProcessInfo.processInfo.arguments.contains("com.covid.usemockfachadas")
    }
}

extension DominioFachada {
    func finalizarEnElMainThread<Arg>(finalizacion: @escaping (Arg) -> Void) -> ((Arg) -> Void) {
        return { arg in
            DispatchQueue.main.async {
                finalizacion(arg)
            }
        }
    }
}

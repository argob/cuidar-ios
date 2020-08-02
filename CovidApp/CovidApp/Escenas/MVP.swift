//
//  MVP.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol MVPPresentador: class, EscenaObservador {
    associatedtype Vista
    
    var vista: Vista? { get }
}

protocol MVPVista: EscenaControlador {
    associatedtype Presentador
    
    var presentador: Presentador { get }
}

extension MVPVista  {
    var observador: EscenaObservador? {
        return presentador as? EscenaObservador
    }
}

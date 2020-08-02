//
//  AutenticacionNavegacionViewModels.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

enum AutenticacionVistasNavegacion {
    case ingresoManual
    case escanerDni
    case confirmacionDni
    case ingresoTelefono
    case ingresoDireccion
}

struct AutenticacionNavegacionViewModel {
    var colorHabilitado: UIColor
    var colorDeshabilitado: UIColor
    var etapa: NavegacionToolbar.Etapa
}

struct EstadoDireccionNavegacion {
    var etapa: NavegacionToolbar.Etapa
    var direccion: DireccionNavegacion
}

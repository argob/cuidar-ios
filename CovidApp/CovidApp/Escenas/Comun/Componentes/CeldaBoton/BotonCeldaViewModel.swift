//
//  BotonCeldaViewModel.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct BotonCeldaViewModel: PasaporteElemento, ResultadoElemento {
    var titulo: BotonViewModel
    var identificador: Identificador
}

enum Identificador {
    case habilitarCirculacion
    case aceptar
    case autodiagnostico
    case actualizar
    case volverAEmpezar
}

protocol BotonCeldaDelegado: class {
    func botonSeleccionado(conIdentificador: Identificador)
}

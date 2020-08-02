//
//  RadioGroupViewModel.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct RadioGroupViewModel {
    var textoOpcion1: String
    var textoOpcion2: String
    var valorOpcion1: String
    var valorOpcion2: String
    var identificador: TiposDeElementosDeFormulario
    var accion: ((TiposDeElementosDeFormulario, String?) -> Void)?
    
    init(textoOpcion1: String, textoOpcion2: String, valorOpcion1: String, valorOpcion2: String, identificador: TiposDeElementosDeFormulario, accion: @escaping ((TiposDeElementosDeFormulario, String?) -> Void)) {
        self.textoOpcion1 = textoOpcion1
        self.textoOpcion2 = textoOpcion2
        self.valorOpcion1 = valorOpcion1
        self.valorOpcion2 = valorOpcion2
        self.identificador = identificador
        self.accion = accion
    }
}

extension RadioButtonGroup {
    func configurar(modelo: RadioGroupViewModel) {
        textoOpcion1 = modelo.textoOpcion1
        textoOpcion2 = modelo.textoOpcion2
        valorOpcion1 = modelo.valorOpcion1
        valorOpcion2 = modelo.valorOpcion2
        accion = { modelo.accion?($0, $1) }
        identificador = modelo.identificador
        translatesAutoresizingMaskIntoConstraints = false
    }
}

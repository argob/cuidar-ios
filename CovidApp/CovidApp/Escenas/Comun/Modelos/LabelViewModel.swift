//
//  LabelViewModel.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct LabelViewModel {
    var texto: String
    var apariencia: LabelAppearance
}

struct LabelAppearance {
    var fuente: UIFont
    var colorTexto: UIColor
    var subrayado: Bool
    var colorFondo: UIColor?
    var numberLines: Int
    
    init(fuente: UIFont,
         numberLines: Int = 0,
         colorTexto: UIColor,
         subrayado: Bool = false,
         colorFondo: UIColor? = nil) {
        self.fuente = fuente
        self.colorTexto = colorTexto
        self.subrayado = subrayado
        self.colorFondo = colorFondo
        self.numberLines = numberLines
    }
}


extension UILabel {
    func configurar(modelo: LabelViewModel) {
        self.text = modelo.texto
        self.configurar(apariencia: modelo.apariencia)
    }
}

private extension UILabel {
    func configurar(apariencia: LabelAppearance) {
        self.font = apariencia.fuente
        self.numberOfLines = apariencia.numberLines
        self.textColor = apariencia.colorTexto
        
        if let fondo = apariencia.colorFondo {
            self.backgroundColor = fondo
        }
    }
}

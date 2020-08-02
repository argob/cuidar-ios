//
//  AttributedText.swift
//  CovidApp
//
//  Created on 13/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension LabelViewModel {
    var attributedText: NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: self.apariencia.colorTexto,
                          NSAttributedString.Key.font: self.apariencia.fuente]
        
        if self.apariencia.subrayado {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        return .init(string: self.texto,
                     attributes: attributes)
    }
}

extension BotonViewModel {
    var textosAtribuidos: [(texto: NSAttributedString, estado: UIControl.State)] {
        return titulos.map { (estado) -> (NSAttributedString, UIControl.State) in
            let color: UIColor = apariencia.tituloColores.first(where: { $0.estado == estado.estado })?.valor ?? .black
            var atributos: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color,
                                                            NSAttributedString.Key.font: apariencia.tituloFuente]
            if self.apariencia.subrayado {
                atributos[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            return (NSAttributedString(string: estado.valor, attributes: atributos), estado.estado)
        }
    }
}

extension UILabel {
    func configurarAttributedText(texts: [LabelViewModel]) {
        let attributed = NSMutableAttributedString()
        texts.forEach{ attributed.append($0.attributedText) }
        
        self.attributedText = attributed
    }
}


extension UIButton {
    func configurarAttributedText(viewModel: BotonViewModel) {
        viewModel.textosAtribuidos.forEach {
            setAttributedTitle($0.texto, for: $0.estado)
        }
    }
}

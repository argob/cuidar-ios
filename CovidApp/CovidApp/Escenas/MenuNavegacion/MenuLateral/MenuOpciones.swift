//
//  MenuOpciones.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class MenuOpciones: UITableView {
    private enum Borde {
        case superior
        case inferior
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        añadirBorde(color: .gray, grosor: 0.5, tipoBorde: .superior)
        añadirBorde(color: .gray, grosor: 0.5, tipoBorde: .inferior)
    }
    
    private func añadirBorde(color: UIColor, grosor: CGFloat, tipoBorde: Borde) {
        let ejeY = tipoBorde == .superior ? 0 : frame.size.height - grosor
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: ejeY, width: frame.size.width, height: grosor)
        layer.addSublayer(border)
    }
}

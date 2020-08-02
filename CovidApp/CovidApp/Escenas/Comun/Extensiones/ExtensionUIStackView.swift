//
//  ExtensionUIStackView.swift
//  CovidApp
//
//  Created on 5/21/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func agregarColorFondo(_ color: UIColor) {
        let vista = UIView(frame: bounds)
        vista.backgroundColor = color
        vista.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(vista, at: 0)
    }
}

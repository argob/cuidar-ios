//
//  MargenesEnCeldaProtocolo.swift
//  CovidApp
//
//  Created on 4/16/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol MargenesEnCeldaProtocolo {
    var margenSuperior: NSLayoutConstraint? { get set }
    var margenInferior: NSLayoutConstraint? { get set }
    var margenIzquierdo: NSLayoutConstraint? { get set }
    var margenDerecho: NSLayoutConstraint? { get set }
    
    func configurarMargenesEnCelda(con margen: UIEdgeInsets)
}

extension MargenesEnCeldaProtocolo where Self: UITableViewCell {
    func configurarMargenesEnCelda(con margen: UIEdgeInsets) {
        margenSuperior?.constant = margen.top
        margenInferior?.constant = -margen.bottom
        margenIzquierdo?.constant = margen.left
        margenDerecho?.constant = -margen.right
    }
}

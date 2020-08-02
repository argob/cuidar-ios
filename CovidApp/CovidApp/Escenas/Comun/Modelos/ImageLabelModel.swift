//
//  ImageLabelModel.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct ImageLabelViewModel {
    let mensaje: String
    let imagen: String
    let estaHabilitado: Bool
    let fuente: UIFont?
    let tag: Int = 0
}

extension ImageLabeView {
    func configurar(modelo: ImageLabelViewModel) {
        errorLabel.font = modelo.fuente
        errorLabel.text = modelo.mensaje
        imagenError.image = UIImage(imageLiteralResourceName: modelo.imagen)
        isHidden = !modelo.estaHabilitado
        tag = modelo.tag
    }
}

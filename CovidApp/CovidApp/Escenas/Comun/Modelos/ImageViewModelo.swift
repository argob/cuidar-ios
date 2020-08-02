//
//  ImageViewModelo.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct ImageViewModelo {
    var imagen: String
}

extension UIImageView {
    func configurar(modelo: ImageViewModelo) {
        image = UIImage(imageLiteralResourceName: modelo.imagen)
    }
}

//
//  UIView.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UIViewController {
    func agregar(_ vista: BaseViewController, vistaContenedor: UIView) {
        addChild(vista)
        vista.view.frame = vistaContenedor.bounds
        vistaContenedor.addSubview(vista.view)
        vista.didMove(toParent: self)
    }
    
    func remover(vista: BaseViewController) {
        vista.willMove(toParent: nil)
        vista.view.removeFromSuperview()
        vista.removeFromParent()
    }
}

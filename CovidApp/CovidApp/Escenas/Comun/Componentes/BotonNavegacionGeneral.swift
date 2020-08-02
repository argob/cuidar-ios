//
//  BotonNavegacionGeneral.swift
//  CovidApp
//
//  Created on 4/11/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol ManejoNavegacion: class {
    func habilitarBoton(colorFondo: UIColor)
    func deshabilitarBoton(colorFondo: UIColor)
}

@IBDesignable class BotonNavegacionGeneral: UIButton {
    private var accion: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2.0
    }
}

extension BotonNavegacionGeneral {
    @objc private func triggerActionHandler() {
        self.accion?()
    }
    
    func configurar(controlEvents control: UIControl.Event, accion: @escaping () -> Void) {
        self.accion = accion
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}

extension BotonNavegacionGeneral: ManejoNavegacion {
    func habilitarBoton(colorFondo: UIColor = .azulPrincipal) {
        backgroundColor = colorFondo
        isEnabled = true
    }
    
    func deshabilitarBoton(colorFondo: UIColor = .grisDeshabilitado) {
        backgroundColor = colorFondo
        isEnabled = false
    }
}

@IBDesignable class BotonNavegacionGeneralConBorde: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2.0
        layer.borderColor = self.tintColor.cgColor
    }
}

extension BotonNavegacionGeneralConBorde: ManejoNavegacion {
    func habilitarBoton(colorFondo: UIColor = .azulPrincipal) {
        backgroundColor = colorFondo
        isEnabled = true
        layer.borderWidth = 1.0
    }
    
    func deshabilitarBoton(colorFondo: UIColor = .grisDeshabilitado) {
        backgroundColor = colorFondo
        isEnabled = false
        layer.borderWidth = 0
    }
}

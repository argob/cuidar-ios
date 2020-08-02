//
//  CampoTextoConEventos.swift
//  CovidApp
//
//  Created on 4/12/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class CampoTextoConEventos: UITextField, UITextFieldDelegate {
    var accionTextoFueAgregado: ((String, String?) -> Void)?
    var accionTextoEmpiezaACambiar: (() -> Void)?
    var identificador: String?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        accionTextoFueAgregado?(identificador ?? "", textField.text)
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accionTextoFueAgregado?(identificador ?? "", textField.text)
        resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        accionTextoEmpiezaACambiar?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        añadirBorde(color: .black, grosor: 1.5)
    }
    
    private func añadirBorde(color: UIColor, grosor: CGFloat) {
        let ejeY = frame.size.height - grosor
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: ejeY, width: frame.size.width, height: grosor)
        layer.addSublayer(border)
    }
}

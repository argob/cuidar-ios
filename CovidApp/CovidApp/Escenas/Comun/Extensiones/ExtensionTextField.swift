//
//  ExtensionTextField.swift
//  CovidApp
//
//  Created on 4/12/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

@IBDesignable
extension UITextField {

    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    func agregarBotonParaCerrarTeclado() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: bounds.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:  .flexibleSpace, target: nil, action: nil)
        let botonDone = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self,
            action: #selector(cerrarTeclado)
        )
        toolbar.setItems([flexSpace, botonDone], animated: false)
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }
    
    @objc func cerrarTeclado() {
        resignFirstResponder()
    }

}

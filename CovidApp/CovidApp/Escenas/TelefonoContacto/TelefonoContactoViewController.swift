//
//  TelefonoContactoViewController.swift
//  CovidApp
//
//  Created on 6/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol TelefonoContactoVista: class , VisualizadorDeCarga {
    func telefonoConfirmado()
    func configurarVista(modelo:TelefonoContactoViewModel)
    func mostrarError(identificador: TiposDeElementosDeFormulario, mensaje: String)
    func removerError(identificador: TiposDeElementosDeFormulario)
    func deshabilitarConfirmar(colorFondo: UIColor)
    func habilitarConfirmar(colorFondo: UIColor)
    func presentarErrorEnFormulario(mensaje: String)
}

final class TelefonoContactoViewController: BaseViewController, MVPVista {
    

    @IBOutlet weak var registerPhoneMessage: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var formatInvalid: UILabel!
    
    lazy var presentador: TelefonoContactoPresentadorProtocolo = self.inyectar()
    
    lazy var enrutador: Enrutador = self.inyectar()
    
    @IBAction func continuarAction(_ sender: Any) {
        presentador.actualizarTelefono(telefono: phoneTextField.text!)
    }
}

extension TelefonoContactoViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        presentador.validarTelefono(identificador: .telefono, valor: textField.text)
        return true
    }
    
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Listo", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }

    @objc func donePressed() {
       view.endEditing(true)
    }
}

extension TelefonoContactoViewController : TelefonoContactoVista{
    func mostrarError(identificador: TiposDeElementosDeFormulario, mensaje: String) {
        switch identificador {
        case .telefono:
            formatInvalid.isHidden = false
        default:
            break
        }
    }

    func removerError(identificador: TiposDeElementosDeFormulario) {
        switch identificador {
        case .telefono:
            formatInvalid.isHidden = true
        default:
            break
        }
    }
    
    func deshabilitarConfirmar(colorFondo: UIColor) {
        continueButton.isEnabled = false
        continueButton.backgroundColor = colorFondo
    }
    
    func habilitarConfirmar(colorFondo: UIColor) {
        continueButton.isEnabled = true
        continueButton.backgroundColor = colorFondo
    }
    
    func configurarVista(modelo: TelefonoContactoViewModel) {
        continueButton.layer.cornerRadius = continueButton.frame.height / 2.0

        phoneTextField.keyboardType = UIKeyboardType.numberPad
        phoneTextField.delegate = self
        addToolBar(textField: phoneTextField)

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        if (modelo.telefono.isEmpty) {
            registerPhoneMessage.text = "Por favor confirmá tu número de teléfono"
        }
        phoneTextField.text = modelo.telefono
        
        registerPhoneMessage.text = "Tenemos registrado " + modelo.telefono + " como tu número de contacto."
    }
    
    func telefonoConfirmado() {
        enrutador.telefonoContactoConfirmado()
    }
    
    func presentarErrorEnFormulario(mensaje: String) {
        let alertaController = UIAlertController(title: "Error en formulario", message:
            mensaje, preferredStyle: .alert)
        alertaController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertaController, animated: true, completion: nil)
    }
}

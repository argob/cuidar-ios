//
//  CampoDeTextoSencilloView.swift
//  CovidApp
//
//  Created on 4/11/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol CampoDeTextoSencilloViewDelegate: class {
    func valorCampoDeTextoCambio(valor: String?, identificador: TiposDeElementosDeFormulario?)
    func campoDeTextoActivado(campoDeTexto: UITextField)
}

class CampoDeTextoSencilloView: UIView {
    private var viewModel: ElementoDeFormularioViewModel?
    
    var identificador: TiposDeElementosDeFormulario? {
        get {
            return viewModel?.identificador
        }
    }
    weak var delegadoCampoSencillo: CampoDeTextoSencilloViewDelegate?
    var toolbar: UIToolbar?
    @IBOutlet weak var vistaContenedor: UIView!
    @IBOutlet weak var campoDeTexto: NoneCopyPasteCutTextField!
    @IBOutlet weak var labelBajoCampo: UILabel!
    @IBOutlet weak var lineaCampoTexto: UIView!
    
    enum TipoTextoSecundario {
        case error
        case texto
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configurar(viewModel: ElementoDeFormularioViewModel) {
        self.viewModel = viewModel
        campoDeTexto.placeholder = viewModel.placeholderParaCampoDeTexto
        campoDeTexto.text = viewModel.textoParaCampoDeTexto
        campoDeTexto.font = viewModel.tipografiaCampoDeTexto.fuente
        campoDeTexto.textColor = viewModel.tipografiaCampoDeTexto.color
        
        labelBajoCampo.text = viewModel.textoBajoCampoDeTexto
        labelBajoCampo.font = viewModel.tipografiaEtiquetaBajoTexto.fuente
        labelBajoCampo.textColor = viewModel.tipografiaEtiquetaBajoTexto.color
        campoDeTexto.keyboardType = viewModel.tipoTeclado
    }
    
    func removerMensajeEnLinea(estado: TipoTextoSecundario = .texto) {
        labelBajoCampo.text = ""
        lineaCampoTexto.backgroundColor = estado == .error ? .rojoPrimario : .black
        labelBajoCampo.textColor = estado == .error ? .rojoPrimario : .black
    }
    
    func agregarMensajeEnLinea(mensaje: String, estado: TipoTextoSecundario) {
        lineaCampoTexto.backgroundColor = estado == .error ? .rojoPrimario : .black
        labelBajoCampo.textColor = estado == .error ? .rojoPrimario : .black
        labelBajoCampo.text = mensaje
    }
    
    @objc func cerrarTeclado() {
        campoDeTexto.resignFirstResponder()
    }
}

private extension CampoDeTextoSencilloView {
    func commonInit() {
        Bundle.main.loadNibNamed("CampoDeTextoSencilloView", owner: self, options: nil)
        addSubview(vistaContenedor)
        vistaContenedor.frame = self.bounds
        vistaContenedor.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        campoDeTexto.delegate = self
        if viewModel?.habilitado ?? true {
            agregarBotonParaCerrarTeclado()
        }
        campoDeTexto.addTarget(self, action: #selector(self.textoCambio), for: .editingChanged)
    }
    
    @objc func textoCambio(_ textField: UITextField) {
        delegadoCampoSencillo?.valorCampoDeTextoCambio(valor: textField.text, identificador: identificador)
    }
    
    func agregarBotonParaCerrarTeclado() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.vistaContenedor.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:  .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self,
            action: #selector(cerrarTeclado)
        )
        toolbar?.setItems([flexSpace, doneBtn], animated: false)
        toolbar?.sizeToFit()
        self.campoDeTexto.inputAccessoryView = toolbar
    }
}

extension CampoDeTextoSencilloView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let campoHabilitado = viewModel?.habilitado ?? true
        let campoEditable = viewModel?.editable ?? true
        if campoHabilitado {
            agregarBotonParaCerrarTeclado()
            textField.text = textField.text?.isEmpty ?? true ? viewModel?.prefijoCampoDeTexto : textField.text
            textField.tintColor = viewModel?.tipografiaCampoDeTexto.color
            delegadoCampoSencillo?.campoDeTextoActivado(campoDeTexto: textField)
            if !campoEditable {
                textField.tintColor = .clear
            }
        } else {
            textField.tintColor = .clear
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegadoCampoSencillo?.valorCampoDeTextoCambio(valor: textField.text, identificador: identificador)
        delegadoCampoSencillo?.campoDeTextoActivado(campoDeTexto: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegadoCampoSencillo?.valorCampoDeTextoCambio(valor: textField.text, identificador: identificador)
        return true
    }
    
    func textField(_ textField: UITextField,  shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let editable = viewModel?.editable,
            let texto = textField.text,
            let rango = Range(range, in: texto),
            let prefijo = viewModel?.prefijoCampoDeTexto else { return true }

        let textoFinal = texto.replacingCharacters(in: rango, with: string)
    
        return editable && textoFinal.starts(with: prefijo)
    }
}

//
//  CampoSeleccionadorViewDelegate.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol DelegadoPicker: class {
    func usuarioActivoPicker(identificador: TiposDeElementosDeFormulario?)
}

final class CampoSeleccionadorView: CampoDeTextoSencilloView {
    weak var delegadoPicker: DelegadoPicker?
    private var opciones: [CiudadProvincia] = []
    
    override func configurar(viewModel: ElementoDeFormularioViewModel) {
        super.configurar(viewModel: viewModel)
        campoDeTexto.inputView = UIView()
        campoDeTexto.inputAccessoryView = nil
        opciones = viewModel.datos ?? []
    }
    
    func actualizar(opciones: [CiudadProvincia]) {
        self.opciones = opciones
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        if !opciones.isEmpty {
            delegadoPicker?.usuarioActivoPicker(identificador: identificador)
        }
    }
}

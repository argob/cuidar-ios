//
//  AutenticacionNumeroTramiteViewController.swift
//  CovidApp
//
//  Created on 4/18/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol AutenticacionNumeroTramiteVista: class {
    func configurarVista(viewModel: AutenticacionNumeroTramiteViewModel)
    func regresarAPantallaPrevia()
}

final class AutenticacionNumeroTramiteViewController: BaseViewController, MVPVista {
    @IBOutlet weak var cerrarButton: UIButton!
    @IBOutlet weak var tituloLabel: UILabel!

    lazy var presentador: AutenticacionNumeroPresentadorProtocolo = self.inyectar()
    
    @IBAction func seleccionaBoton(_ sender: Any) {
        presentador.manejarBotonCerrar()
    }
}

extension AutenticacionNumeroTramiteViewController : AutenticacionNumeroTramiteVista {
    
    func configurarVista(viewModel: AutenticacionNumeroTramiteViewModel) {
        cerrarButton.configurar(modelo: viewModel.boton)
        tituloLabel.configurar(modelo: viewModel.titulo)
    }
    
    func regresarAPantallaPrevia() {
        dismiss(animated: true)
    }
}


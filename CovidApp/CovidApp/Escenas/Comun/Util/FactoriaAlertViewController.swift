//
//  FactoriaAlertViewController.swift
//  CovidApp
//
//  Created on 4/18/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct FactoriaAlertViewController {
    static func crearAlertController(viewModel: AlertaErrorEjecutarClienteViewModel) -> UIAlertController {
        let controlador = UIAlertController(title: viewModel.titulo,
                                            message: viewModel.mensaje,
                                            preferredStyle: .alert)
        
        let accionDeReintentar = UIAlertAction(title: viewModel.tituloReintentar,
                                               style: .default, handler: { (_) in
                                                viewModel.accionAlReintentar?()
        })
        let accionDeAceptar = UIAlertAction(title: viewModel.tituloAceptar, style: .default) { (_) in
            controlador.dismiss(animated: true)
        }
        controlador.addAction(accionDeReintentar)
        controlador.addAction(accionDeAceptar)
        return controlador
    }
    
    static func crearAlertDesvincularDNIController(viewModel: AlertaDesvincularDNIViewModel) -> UIAlertController {
        let controlador = UIAlertController(title: viewModel.titulo,
                                            message: viewModel.mensaje,
                                            preferredStyle: .alert)
        
        let accionDeAceptar = UIAlertAction(title: viewModel.tituloAceptar,
                                               style: .default, handler: { (_) in
                                                viewModel.accionAceptar?()
        })
        let accionDeCancelar = UIAlertAction(title: viewModel.tituloCancelar, style: .default) { (_) in
            controlador.dismiss(animated: true)
        }
        controlador.addAction(accionDeAceptar)
        controlador.addAction(accionDeCancelar)
        return controlador
    }
  
}

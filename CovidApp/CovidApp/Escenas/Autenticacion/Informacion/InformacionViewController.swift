//
//  InformacionViewController.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol InformacionVista: class {
    func configurar(viewModel: InformacionViewModel)
    func continuarSiguienteEtapa()
    func reintentar()
}

final class InformacionViewController: BaseViewController, MVPVista {
    @IBOutlet weak var encabezadoImagen: UIImageView!
    @IBOutlet weak var mensajeImagen: UIImageView!
    @IBOutlet weak var mensaje: UILabel!
    @IBOutlet weak var indicaciones: UILabel!
    @IBOutlet weak var botonContinuar: UIButton!

    lazy var presentador: InformacionPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    var accionReintentar: (() -> Void)?
    
    @objc func botonContinuarSeleccionado(_ sender: UIButton) {
        presentador.botonContinuarSeleccionado()
    }
}

extension InformacionViewController: InformacionVista {
    func configurar(viewModel: InformacionViewModel) {
        encabezadoImagen.image = viewModel.imagenEncabezado
        mensajeImagen.image = viewModel.imagenDeMensaje
        mensaje.configurar(modelo: viewModel.mensaje)
        indicaciones.configurar(modelo: viewModel.indicaciones)
        botonContinuar.configurar(modelo: viewModel.aparienciaBoton)
        botonContinuar.addTarget(self,
                                 action: #selector(botonContinuarSeleccionado),
                                 for: .touchUpInside)
    }
    
    func continuarSiguienteEtapa() {
        enrutador.continuarEtapaPostRegistro()
    }
    
    func reintentar() {
        accionReintentar?()
    }
}

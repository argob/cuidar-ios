//
//  ConfirmacionViewController.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol ConfirmacionVista: class {
    func configurar(viewModel: ConfirmacionViewModel)
    func irALaProximaSeccion()
}

protocol ManejardorDniDelegado: class {
    func recibirInfoUsuario(modelo: ConfirmacionUsuarioViewModel)
}

final class ConfirmacionViewController: BaseViewController, MVPVista {
    @IBOutlet weak var imagenUsuario: UIImageView!
    @IBOutlet weak var tituloPantalla: UILabel!
    @IBOutlet weak var etiquetaDNI: UILabel!
    @IBOutlet weak var numeroDNI: UILabel!
    @IBOutlet weak var fechaNacimiento: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var etiquetaGenero: UILabel!
    @IBOutlet weak var etiquetaNacimiento: UILabel!
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var botonSiguiente: BotonNavegacionGeneral!
    lazy var presentador: ConfirmacionPresentadorProtocolo = inyectar()
    weak var autenticacionNavegacionDelegado: AutenticacionNavegacionDelegado?
}

extension ConfirmacionViewController: ConfirmacionVista {
    func irALaProximaSeccion() {
        autenticacionNavegacionDelegado?.siguienteEtapa()
    }
    
    func configurar(viewModel: ConfirmacionViewModel) {
        configurar(etiqueta: etiquetaDNI, modelo: viewModel.etiquetaDNI)
        configurar(etiqueta: numeroDNI, modelo: viewModel.numeroDNI)
        configurar(etiqueta: fechaNacimiento, modelo: viewModel.fechaNacimiento)
        configurar(etiqueta: genero, modelo: viewModel.genero)
        configurar(etiqueta: etiquetaGenero, modelo: viewModel.etiquetaGenero)
        configurar(etiqueta: etiquetaNacimiento, modelo: viewModel.etiquetaNacimiento)
        configurar(etiqueta: nombreUsuario, modelo: viewModel.nombreUsuario)
        configurar(etiqueta: tituloPantalla, modelo: viewModel.tituloPantalla)
        configurar(boton: botonSiguiente, modelo: viewModel.botonSiguiente)
    }
}

private extension ConfirmacionViewController {
    func configurar(etiqueta: UILabel, modelo: LabelViewModel) {
        etiqueta.configurar(modelo: modelo)
    }
    func configurar(boton: BotonNavegacionGeneral, modelo: BotonViewModelAccion) {
        if let accion = modelo.accion {
            boton.configurar(controlEvents: .touchUpInside, accion: accion)
        }
        boton.configurar(modelo: modelo)
    }
}

extension ConfirmacionViewController: ManejardorDniDelegado {
    func recibirInfoUsuario(modelo: ConfirmacionUsuarioViewModel) {
        presentador.manejarConfirmacionUsuario(viewModel: modelo)
    }
}

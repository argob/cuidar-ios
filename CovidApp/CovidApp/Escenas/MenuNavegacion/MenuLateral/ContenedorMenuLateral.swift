//
//  ContenedorMenuLateral.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ContenedorMenuLateral: UIView, XIBInitiable {
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var DNI: UILabel!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var direccion2: UILabel!
    @IBOutlet weak var direccion3: UILabel!
    weak var delegado: MenuLateralDelegado?
    
    @IBOutlet var informacionStackViews: [UIStackView]!
    
    @IBOutlet weak var videoLlamadaOpcion: UIStackView!
    @IBOutlet weak var informacionOpcion: UIStackView!
    @IBOutlet weak var informacionRedesOpcion: UIStackView!
        
    @IBOutlet weak var pbaOpcion: UIStackView!
    
    func configurar(relativo vista: UIView, provincia:String) {
        translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: vista.leadingAnchor),
            trailingAnchor.constraint(equalTo: vista.trailingAnchor),
            topAnchor.constraint(equalTo: vista.topAnchor),
            bottomAnchor.constraint(equalTo: vista.bottomAnchor)
        ])
        
        videoLlamadaOpcion.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirOpcionVideollamada)))
        informacionOpcion.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirOpcionInformacion)))
        informacionRedesOpcion.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirOpcionRedes)))
        
        if provincia == "Buenos Aires" {
            pbaOpcion.isHidden = false
            pbaOpcion.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirOpcionPBA)))

        } else {
            pbaOpcion.isHidden = true
        }
         
        for stackView in informacionStackViews {
            stackView.agregarColorFondo(.celeste)
        }
        direccion.numberOfLines = 1
        direccion2.numberOfLines = 1
        direccion3.numberOfLines = 1
    }
    
    @objc func abrirOpcionVideollamada() {
        delegado?.opcionSeleccionada(.videoLlamada)
    }
    
    @objc func abrirOpcionInformacion() {
        delegado?.opcionSeleccionada(.informacion)
    }
    
    @objc func abrirOpcionRedes() {
        delegado?.opcionSeleccionada(.informacionRedes)
    }
    
    @objc func abrirOpcionPBA() {
        delegado?.opcionSeleccionada(.informacionPBA)
    }
    
    @IBAction func cerrarMenu(_ sender: Any) {
        delegado?.cerrarMenu()
    }
    @IBAction func cerrarSesion(_ sender: Any) {
        delegado?.opcionSeleccionada(.cerrarSesion)
    }
    @IBAction func editarInformacion(_ sender: Any) {
        delegado?.opcionSeleccionada(.editarInformacion)
    }
}

extension ContenedorMenuLateral {
    func configurar(viewModel: ViewModelMenuNavegacion) {
        nombreUsuario.configurar(modelo: viewModel.nombreUsuario)
        DNI.configurar(modelo: viewModel.DNI)
        telefono.configurar(modelo: viewModel.telefono)
        direccion.configurar(modelo: viewModel.direccion)
        direccion2.configurar(modelo: viewModel.direccion2)
        direccion3.configurar(modelo: viewModel.direccion3)
    }
}


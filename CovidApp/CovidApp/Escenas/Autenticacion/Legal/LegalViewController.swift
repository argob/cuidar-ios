//
//  LegalViewController.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit
import WebKit

protocol LegalVista: class {
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func configurarVista(viewModel: LegalViewModel)
    func aceptarTerminosYCondiciones()
    func removerContenido()
    func addTransitionFromLeft()
}

final class LegalViewController: BaseViewController, MVPVista {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var botonAceptar: UIButton!
    @IBOutlet weak var terminos: WKWebView!
    
    lazy var presentador: LegalPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
}

extension LegalViewController: LegalVista {
    func addTransitionFromLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.default)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
    
    func configurarVista(viewModel: LegalViewModel) {
        titulo.configurar(modelo: viewModel.titulo)
        botonAceptar.configurar(modelo: viewModel.botonAceptar)
        botonAceptar.layer.cornerRadius = 29
        
        if let url = viewModel.terminosUrl {
//            Terminos Static Web
//            Keys.STATIC_WEB + tyc/ultima.html
            terminos.load(URLRequest(url:url))
            
//            Terminos HardCode
//            terminos.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        botonAceptar.addTarget(self, action: #selector(botonAceptarSeleccionado), for: .touchUpInside)
    }
    
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        self.barraNavegacionPersonalizada.delegado = self
        self.barraNavegacionPersonalizada.configurarBarraNavegacion(viewModel: viewModel)
        self.barraNavegacionPersonalizada.modoVisible = true
        self.barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: false)
    }
    
    func aceptarTerminosYCondiciones() {
        enrutador.terminosYCondicionesAceptados()
    }
    
    @objc func botonAceptarSeleccionado(_ sender: UIButton) {
        aceptarTerminosYCondiciones()
    }
        
    func removerContenido() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LegalViewController: DelegadoBarraNavegacionPersonalizada {
    func botonIzquierdoAccionado() {
        presentador.manejarBotonAtras()
    }    
}

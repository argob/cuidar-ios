//
//  NewLegalViewController.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit

protocol NewLegalVista: class {
    func configurar(viewModel: AceptarTerminosViewModel)
    func mostrarTerminos()
    func cambioTerminos(aceptados: Bool)
    func logout()
    func addTransitionFromLeft()
}

final class NewLegalViewController:BaseViewController, MVPVista {
    
    @IBOutlet weak var botonCancelar: BotonNavegacionGeneralConBorde!
    @IBOutlet weak var botonContinuar: BotonNavegacionGeneral!
    @IBOutlet weak var vistaTerminos: UIView!
    @IBOutlet weak var deltaView: UITextView!
    
    lazy var presentador :NewLegalPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    
    @IBAction func continuarAction(_ sender: Any) {
        enrutador.nuevosTerminosYCondicionesAceptados()
    }
    
    @IBAction func cancelarAction(_ sender: Any) {
        cancelarAlert()
    }
    
    func cancelarAlert() {
        let alert = UIAlertController(title: "Alerta", message: Constantes.LEGAL_CANCEL_ALERT, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Entendido", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.presentador.cancelar()
            
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewLegalViewController: NewLegalVista {
    func addTransitionFromLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.default)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
    
    func logout() {
        enrutador.desvinculaciónTerminada()
    }
    
    func cambioTerminos(aceptados: Bool) {
        if aceptados {
            botonContinuar.habilitarBoton(colorFondo: Constantes.COLOR_HABILITADO)
        } else {
            botonContinuar.deshabilitarBoton()
        }
        botonCancelar.habilitarBoton(colorFondo: Constantes.COLOR_HABILITADO_MANUAL)
    }
    
    func mostrarTerminos() {
        enrutador.terminosYCondicionesIniciar()
    }
    
    func configurar(viewModel: AceptarTerminosViewModel) {
        
        let delta: String? = UserDefaults.standard.value(forKey: Constantes.LEGAL_DELTA) as? String
        
        deltaView.attributedText = delta?.htmlToAttributedString
        
        let terminosStack = VistaTerminos()
        terminosStack.configurar(modelo: viewModel)
        terminosStack.accionAceptarTerminos = viewModel.accionAceptarTerminos
        terminosStack.accionMostrarTerminos = viewModel.accionMostrarTerminos
        terminosStack.translatesAutoresizingMaskIntoConstraints = false
        vistaTerminos.addSubview(terminosStack)
        NSLayoutConstraint.activate([
            terminosStack.leadingAnchor.constraint(equalTo: vistaTerminos.leadingAnchor),
            terminosStack.trailingAnchor.constraint(equalTo: vistaTerminos.trailingAnchor),
            terminosStack.topAnchor.constraint(equalTo: vistaTerminos.topAnchor),
            terminosStack.bottomAnchor.constraint(equalTo: vistaTerminos.bottomAnchor)]
        )
        cambioTerminos(aceptados: viewModel.preSelecionado)
    }
}


//
//  BaseViewController.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol EscenaObservador {
    func escenaCargo()
    func escenaAparecera()
    func escenaAparecio()
    func escenaDesaparecera()
    func escenaDesaparecio()
}

extension EscenaObservador {
    func escenaCargo() {}
    func escenaAparecera() {}
    func escenaAparecio() {}
    func escenaDesaparecera() {}
    func escenaDesaparecio() {}
}

protocol VisualizadorDeCarga {
    func mostrarLoader()
    func ocultarLoader()
}

protocol EscenaControlador {
    var observador: EscenaObservador? { get }
}

class BaseViewController: UIViewController {
    lazy var barraNavegacionPersonalizada: BarraNavegacionPersonalizadaProtocolo = BarraNavegacionPersonalizada()
    private lazy var pantallaDeCarga: PantallaDeCargaProtocolo = PantallaDeCarga()
    
    private var escenaObservador: EscenaObservador? {
        return (self as? EscenaControlador)?.observador
    }
    
    override func viewDidLoad() {
        let nibName = String(describing: type(of: self))
        self.view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        self.escenaObservador?.escenaCargo()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configurarBarraNavegacion()
        self.escenaObservador?.escenaAparecera()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.escenaObservador?.escenaAparecio()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.escenaObservador?.escenaDesaparecera()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.escenaObservador?.escenaDesaparecio()
        super.viewDidDisappear(animated)
    }
    
    deinit {
        barraNavegacionPersonalizada.delegado = nil
    }
}

extension BaseViewController: VisualizadorDeCarga {
    func mostrarLoader() {
        pantallaDeCarga.añadirPantallaDeCarga(enVista: self.view)
    }
    
    func ocultarLoader() {
        pantallaDeCarga.removerPantallaDeCarga()
    }
}

private extension BaseViewController {
    func configurarBarraNavegacion() {
        self.barraNavegacionPersonalizada.añadirBarraDeNavegacion(vistaContenedora: self.view,
                                                                  altura: 50.0)
    }
}


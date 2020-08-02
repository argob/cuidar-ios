//
//  MenuNavegacionVista.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol MenuNavegacionVista: class {
    func configurarMenu(con viewModel: ViewModelMenuNavegacion?)
    func agregar(vista: BaseViewController)
}

final class MenuNavegacionViewController: BaseViewController, MVPVista {
    @IBOutlet weak var barraNavegacion: UINavigationBar!
    @IBAction func clickToggleMenu(_ sender: Any) {
        menuLateral.toggle(accion: .abrir)
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            menuLateral.toggle(accion: .abrir)
        }
    }
    var gesturaSwipeDerecha: UISwipeGestureRecognizer!
    var menuLateral: MenuLateralVista!
    
    lazy var presentador: MenuNavegacionPresentadorProtocolo = self.inyectar()
    
    lazy var vistaHijo: UIView = {
        let vista = UIView()
        vista.translatesAutoresizingMaskIntoConstraints = false
        return vista
    }()
    
    private func configurarVista() {
        view.addSubview(vistaHijo)
        NSLayoutConstraint.activate([
            vistaHijo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vistaHijo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vistaHijo.topAnchor.constraint(equalTo: barraNavegacion.bottomAnchor),
            vistaHijo.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        gesturaSwipeDerecha = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        gesturaSwipeDerecha.direction = .right
        view.addGestureRecognizer(gesturaSwipeDerecha)
    }
}

extension MenuNavegacionViewController: MenuNavegacionVista {
    
    func agregar(vista: BaseViewController) {
        agregar(vista, vistaContenedor: vistaHijo)
    }
    
    func configurarMenu(con viewModel: ViewModelMenuNavegacion?) {
        guard let viewModel = viewModel else { return }
        configurarVista()
        let factoria: FactoriaMenuLateral = FactoriaVistaMenuLateral()
        menuLateral = factoria.crear(viewModel: viewModel, delegado: self)
        menuLateral.configurar(view: self.view)
    }
}

extension MenuNavegacionViewController: MenuLateralDelegado {
    func opcionSeleccionada(_ opcion: OpcionNavegacion) {}
    
    func cerrarMenu() {}
}

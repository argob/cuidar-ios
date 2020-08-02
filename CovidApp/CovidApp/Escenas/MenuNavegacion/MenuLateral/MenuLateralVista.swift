//
//  MenuLateral.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

enum AccionMenuLateral {
    case abrir
    case cerrar
}

final class MenuLateralVista: UIView {
    var menuOpciones: ContenedorMenuLateral!
    var trailingConstraint: NSLayoutConstraint?
    var gesturaSwipeIzquierda: UISwipeGestureRecognizer!
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            toggle(accion: .cerrar)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}

extension MenuLateralVista {
    
    func toggle(accion: AccionMenuLateral) {
        self.trailingConstraint?.constant = accion == .cerrar ? 0 : frame.size.width
        UIView.animate(withDuration: 0.4, animations:{
            self.superview?.layoutIfNeeded()
            self.cambiarEstadoInteraccion(estaHabilitado: accion == .abrir ? false : true)
        })
    }
    
    func configurar(view: UIView) {        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        view.addSubview(self)
        
        trailingConstraint = trailingAnchor.constraint(equalTo: view.leadingAnchor)
        
        let anchoMenuLateral = view.frame.width * 0.85
        let constraints = [
            trailingConstraint,
            widthAnchor.constraint(equalToConstant: anchoMenuLateral),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints.compactMap({ $0 }))
        
        gesturaSwipeIzquierda = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        gesturaSwipeIzquierda.direction = .left
        addGestureRecognizer(gesturaSwipeIzquierda)
    }
    
    func configurarMenuOpciones(provincia:String) {
        addSubview(menuOpciones)
        menuOpciones.configurar(relativo: self, provincia:provincia)
    }
}

extension MenuLateralVista {
    
    func cambiarEstadoInteraccion(estaHabilitado: Bool) {
        guard let subviews = self.superview?.subviews else { return }
        for view in subviews {
            if view != self {
                view.isUserInteractionEnabled = estaHabilitado
            }
        }
    }
}

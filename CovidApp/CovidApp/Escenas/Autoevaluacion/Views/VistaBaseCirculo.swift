//
//  VistaBaseCirculo.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class VistaBaseCirculo: UIView {
    var radioCirculo: CGFloat = 13
    var colorRellenoCirculo: UIColor = .white
    var colorBordeCirculo: UIColor = .gray
    var mostrarLineaIzquierda: Bool = false
    var mostrarLineaDerecha: Bool = false
    var colorLineaDerecha: UIColor = .gray
    var colorLineaIzquierda: UIColor = .gray

    private var path: UIBezierPath!
    private let gruesoBordeCirculo: CGFloat = 1
    private let tamañoLinea: CGFloat = 1
    private var gruesoLinea: CGFloat {
        return (frame.width - radioCirculo) / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        crearVista()
    }

    private func crearVista() {
        dibujarCirculo()
        if mostrarLineaIzquierda {
            dibujarLineaIzquierda()
        }
        if mostrarLineaDerecha {
            dibujarLineaDerecha()
        }
    }
}

private extension VistaBaseCirculo {
    func dibujarCirculo() {
        path = UIBezierPath(ovalIn: CGRect(x: frame.width / 2 - radioCirculo / 2, y: frame.height / 2 - radioCirculo / 2, width: radioCirculo, height: radioCirculo))

        colorRellenoCirculo.setFill()
        path.fill()

        colorBordeCirculo.setStroke()
        path.lineWidth = gruesoBordeCirculo
        path.stroke()
    }

    func dibujarLineaIzquierda() {
        path = UIBezierPath(rect: CGRect(x: 0, y: frame.height / 2, width: gruesoLinea, height: tamañoLinea))
        colorLineaIzquierda.setFill()
        path.fill()
    }

    func dibujarLineaDerecha() {
        path = UIBezierPath(rect: CGRect(x: gruesoLinea + radioCirculo, y: frame.height / 2, width: gruesoLinea, height: tamañoLinea))
        colorLineaDerecha.setFill()
        path.fill()
    }
}



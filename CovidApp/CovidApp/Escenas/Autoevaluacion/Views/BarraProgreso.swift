//
//  BarraProgreso.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class BarraProgreso: UIView {
    private var numeroPasos: Int = 1
    private var pasoSeleccionado: Int = 1
    private var vistasPasos = [VistaBaseCirculo]()
    private let activeColor: UIColor = UIColor.rosaPrincipal
    private let inactiveColor: UIColor = UIColor.grisTerciario
    private var tamañoVista: CGFloat {
        return self.bounds.size.width / CGFloat(numeroPasos)
    }
    var pasoActual: Int {
        return pasoSeleccionado
    }

    override func draw(_ rect: CGRect) {
        prepararCreacion()
        crearPasos()
    }

    func crear(numeroPasos: Int, pasoSeleccionado: Int) {
        self.numeroPasos = numeroPasos
        self.pasoSeleccionado = pasoSeleccionado
    }

    func siguiente() {
        mover(paso: pasoSeleccionado + 1)
    }

    func anterior() {
        mover(paso: pasoSeleccionado - 1)
    }
    
    func primerPaso() {
        pasoSeleccionado = 1
        mover(paso: pasoSeleccionado)
    }

}

private extension BarraProgreso {
    func prepararCreacion() {
        for view in subviews { view.removeFromSuperview() }
        
        let factoria = FactoriaVistaBaseCirculo()
        let pasoVistaRect = CGRect(x: 0, y: 0, width: tamañoVista, height: frame.height)
        self.vistasPasos = [VistaBaseCirculo].init(repeating: factoria.crear(frame: pasoVistaRect), count: numeroPasos)
    }

    func crearPasos() {
        for index in 0 ..< numeroPasos {
            crearVistaPaso(para: index, en: numeroPasos, con: pasoSeleccionado - 1)
        }
    }

    func crearVistaPaso(para index: Int, en pasos: Int, con pasoActual: Int) {
        var pasoVista: VistaBaseCirculo
        let pasoVistaFrame = CGRect(x: CGFloat(index) * tamañoVista, y: 0, width: tamañoVista, height: frame.height)
        let factoria = FactoriaVistaBaseCirculo()

        pasoVista = factoria.crear(frame: pasoVistaFrame)
        pasoVista.colorRellenoCirculo = index <= pasoActual ? activeColor : .white
        pasoVista.colorBordeCirculo = index <= pasoActual ? activeColor : inactiveColor
        pasoVista.colorLineaDerecha = index < pasoActual ? activeColor : inactiveColor
        pasoVista.colorLineaIzquierda = index <= pasoActual ? activeColor : inactiveColor
        pasoVista.mostrarLineaIzquierda = index == 0 ? false : true
        pasoVista.mostrarLineaDerecha = index == pasos - 1 ? false : true

        reemplazarVista(con: pasoVista, en: index)
    }

    func reemplazarVista(con vista: VistaBaseCirculo, en index: Int) {
        guard index < vistasPasos.count else {
            return
        }
        willRemoveSubview(vistasPasos[index])
        vistasPasos[index].removeFromSuperview()
        vistasPasos.remove(at: index)
        vistasPasos.insert(vista, at: index)
        addSubview(vista)
    }

    func mover(paso: Int) {
        guard paso > 0 && paso <= numeroPasos else {
            return
        }

        if paso > pasoSeleccionado && paso - pasoSeleccionado == 1 {
            crearVistaPaso(para: pasoSeleccionado - 1, en: numeroPasos, con: paso - 1)
            crearVistaPaso(para: paso - 1, en: numeroPasos, con: paso - 1)
        } else {
            pasoSeleccionado = paso
            crearPasos()
        }
        pasoSeleccionado = paso
    }
}



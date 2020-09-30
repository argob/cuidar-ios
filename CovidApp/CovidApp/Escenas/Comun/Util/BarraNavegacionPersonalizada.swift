//
//  BarraNavegacionPersonalizada.swift
//  CovidApp
//
//  Created on 09/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct BarraNavegacionPersonalizadaViewModel {
    static var soloHeaderPrincipal = BarraNavegacionPersonalizadaViewModel(
        vistaEncabezadoFondo: UIImage(named: "navegacion-encabezado"),
        botonIzquierdoFondo: UIImage(named: "navegacion-menu"),
        botonIzquierdoHabilitado: true)
    static var soloFlecha = BarraNavegacionPersonalizadaViewModel(
           vistaEncabezadoFondo: nil,
           botonIzquierdoFondo: UIImage(named: "navegacion-flecha"),
           botonIzquierdoHabilitado: true)
    static var completa = BarraNavegacionPersonalizadaViewModel(
           vistaEncabezadoFondo: UIImage(named: "navegacion-encabezado"),
           botonIzquierdoFondo: UIImage(named: "navegacion-flecha"),
           botonIzquierdoHabilitado: true)
    static var completa_pba = BarraNavegacionPersonalizadaViewModel(
        logoPBA: UIImage(named: "CUIDAR-_LOGO PROVINCIA"),
        vistaEncabezadoFondo: UIImage(named: "navegacion-encabezado"),
        botonIzquierdoFondo: UIImage(named: "navegacion-flecha"),
           botonIzquierdoHabilitado: true)
    static var autoevaluacion = BarraNavegacionPersonalizadaViewModel(
        vistaEncabezadoFondo: UIImage(named: "autoevaluacion2"),
        botonIzquierdoFondo: UIImage(named: "navegacion-flecha"),
        botonIzquierdoHabilitado: true)
    
    var logoPBA: UIImage?
    var vistaEncabezadoFondo: UIImage?
    var botonIzquierdoFondo: UIImage?
    var botonIzquierdoHabilitado: Bool
}

protocol DelegadoBarraNavegacionPersonalizada: class {
    func botonIzquierdoAccionado()
}

protocol BarraNavegacionPersonalizadaProtocolo {
    var delegado: DelegadoBarraNavegacionPersonalizada? { get set }
    var modoVisible: Bool { get set }
    func añadirBarraDeNavegacion(vistaContenedora: UIView, altura: CGFloat)
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func mostrarBotonIzquierdo(mostrar: Bool)
}

final class BarraNavegacionPersonalizada: UIView {
    private lazy var vista: UIView = .init(frame: .zero)
    private var botonIzquierdo: UIButton = .init(frame: .zero)
    private var imagenEncabezado: UIImageView = .init(frame: .zero)
    private var imagenPBA: UIImageView = .init(frame: .zero)

    weak var delegado: DelegadoBarraNavegacionPersonalizada?
    
    var modoVisible: Bool = false {
        didSet {
            vista.isHidden = !modoVisible
        }
    }
    
    var mostrarBoton: Bool = true {
        didSet {
            botonIzquierdo.isHidden = !mostrarBoton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        crearBotonIzquierdo()
        crearVistaEncabezado()
        crearVistaLogoPBA()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        crearBotonIzquierdo()
        crearVistaEncabezado()
        crearVistaLogoPBA()
    }
    
    @objc func botonIzquierdoAccionado(_ sender: UIButton) {
        delegado?.botonIzquierdoAccionado()
    }
}

extension BarraNavegacionPersonalizada: BarraNavegacionPersonalizadaProtocolo {
    func mostrarBotonIzquierdo(mostrar: Bool) {
        mostrarBoton = mostrar
    }
    
    func añadirBarraDeNavegacion(vistaContenedora: UIView, altura: CGFloat) {
        vista.frame = .init(x: 0,
                            y: 0,
                            width: vistaContenedora.frame.width,
                            height: altura)
        vista.translatesAutoresizingMaskIntoConstraints = false
        vistaContenedora.addSubview(self.vista)
        configurarRestriccionesVistaContenedora(vistaContenedora: vistaContenedora, altura: altura)
        configurarRestriccionesVistaBotonIzquierdo()
        configurarRestriccionesVistaEncabezado()
        configurarRestriccionesVistaLogoPBA()
    }
    
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        imagenEncabezado.image = viewModel.vistaEncabezadoFondo
        imagenPBA.image = viewModel.logoPBA
        configurarBotonIzquierdo(viewModel: viewModel)
    }
}

private extension BarraNavegacionPersonalizada {
    func configurarBotonIzquierdo(viewModel: BarraNavegacionPersonalizadaViewModel) {
        if viewModel.botonIzquierdoHabilitado {
            botonIzquierdo.setImage(viewModel.botonIzquierdoFondo, for: .normal)
        }
        
        botonIzquierdo.isEnabled = viewModel.botonIzquierdoHabilitado
    }
    func crearBotonIzquierdo() {
        botonIzquierdo.addTarget(self,
                                 action: #selector(botonIzquierdoAccionado),
                                 for: .touchUpInside)
        botonIzquierdo.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(botonIzquierdo)
    }
    
    func crearVistaEncabezado() {
        imagenEncabezado.contentMode = .scaleAspectFit
        imagenEncabezado.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(imagenEncabezado)
    }
    
    func crearVistaLogoPBA() {
        imagenPBA.contentMode = .scaleAspectFit
        imagenPBA.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(imagenPBA)
    }
    
    func configurarRestriccionesVistaContenedora(vistaContenedora: UIView, altura: CGFloat) {
        let constraints: [NSLayoutConstraint] = [
            vista.leadingAnchor.constraint(equalTo: vistaContenedora.leadingAnchor),
            vista.trailingAnchor.constraint(equalTo: vistaContenedora.trailingAnchor),
            vista.topAnchor.constraint(equalTo: vistaContenedora.safeAreaLayoutGuide.topAnchor),
            vista.heightAnchor.constraint(equalToConstant: altura)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configurarRestriccionesVistaBotonIzquierdo() {
        let constraints: [NSLayoutConstraint] = [
            botonIzquierdo.leadingAnchor.constraint(equalTo: vista.leadingAnchor, constant: 20.0),
            botonIzquierdo.centerYAnchor.constraint(equalTo: vista.centerYAnchor),
            botonIzquierdo.heightAnchor.constraint(equalToConstant: vista.frame.height * 0.8),
            botonIzquierdo.widthAnchor.constraint(equalToConstant: vista.frame.height * 0.8)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configurarRestriccionesVistaEncabezado() {
        let constraints: [NSLayoutConstraint] = [
            imagenEncabezado.centerXAnchor.constraint(equalTo: vista.centerXAnchor),
            imagenEncabezado.centerYAnchor.constraint(equalTo: vista.centerYAnchor, constant: 5),
            imagenEncabezado.heightAnchor.constraint(equalToConstant: vista.bounds.height * 0.8),
            imagenEncabezado.widthAnchor.constraint(equalToConstant: 150.0)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
    }
    func configurarRestriccionesVistaLogoPBA() {
       let constraints: [NSLayoutConstraint] = [
           imagenPBA.leadingAnchor.constraint(equalTo: imagenEncabezado.trailingAnchor),
           imagenPBA.centerYAnchor.constraint(equalTo: vista.centerYAnchor, constant: 5),
           imagenPBA.heightAnchor.constraint(equalToConstant: vista.bounds.height * 0.8),
           imagenPBA.widthAnchor.constraint(equalToConstant: 150.0)
       ].compactMap { $0 }
       
       NSLayoutConstraint.activate(constraints)
   }
}

//
//  IncrementalDecrementalView.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class IncrementalDecrementalView: UIView {
    
    private struct Metricas {
        static let anchoBoton: CGFloat = 52
        static let anchoEtiqueta: CGFloat = 93
    }
    var accionEmpiezaAEditar: (() -> Void)?
    var accionEditando: ((UITextField, NSRange, String) -> Bool)?
    var accionFinalizaDeEditar: ((UITextField) -> Double?)?
    var accionCambiarValor: ((Double, Bool) -> Void)?
    private var vieneDeTextField: Bool = false
    var valor: Double = 0 {
        willSet(nuevoValor) {
            let texto = String(format: formato, arguments: [nuevoValor])
            campoDeTexto.text = texto.replacingOccurrences(of: ".", with: separadorDecimal)
            accionCambiarValor?(nuevoValor, vieneDeTextField)
            actualizarBotones(para: nuevoValor)
        }
    }
    
    var separadorDecimal: String = ","
    var valorDePaso: Double = 1
    var valorMinimo: Double = 0
    var valorMaximo: Double = 100
    var formato: String = "%.f"
    
    lazy var campoDeTexto: UITextField = {
        let campo = UITextField()
        campo.textColor = .negroTerciario
        campo.textAlignment = .center
        campo.translatesAutoresizingMaskIntoConstraints = false
        campo.keyboardType = .numberPad
        campo.placeholder = "0"
        campo.agregarBotonParaCerrarTeclado()
        campo.delegate = self
        return campo
    }()
    
    private lazy var botonIncremental: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.backgroundColor = .azulPrincipal
        button.tintColor = .white
        button.layer.cornerRadius = Metricas.anchoBoton / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(incrementarValor(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var botonDecremental: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "minus"), for: .normal)
        button.backgroundColor = .azulPrincipal
        button.tintColor = .white
        button.layer.cornerRadius = Metricas.anchoBoton / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(decrementarValor(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuraControl()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configuraControl()
    }
}

private extension IncrementalDecrementalView {
    enum ResultadoValidacion {
        case rangoValido
        case mayorAlPermitido
        case menorAlPermitido
    }
    
    func configuraControl() {
        addSubview(campoDeTexto)
        addSubview(botonIncremental)
        addSubview(botonDecremental)
        configuraLayout()
    }
    
    func configuraLayout() {
        let constraints = [botonDecremental.heightAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           botonDecremental.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           botonDecremental.centerYAnchor.constraint(equalTo: centerYAnchor),
                           campoDeTexto.leadingAnchor.constraint(equalTo: botonDecremental.trailingAnchor),
                           campoDeTexto.centerXAnchor.constraint(equalTo: centerXAnchor),
                           campoDeTexto.centerYAnchor.constraint(equalTo: centerYAnchor),
                           campoDeTexto.widthAnchor.constraint(equalToConstant: Metricas.anchoEtiqueta),
                           botonIncremental.leadingAnchor.constraint(equalTo: campoDeTexto.trailingAnchor),
                           botonIncremental.heightAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           botonIncremental.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           botonIncremental.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func incrementarValor(_ sender: Any) {
        vieneDeTextField = false
        valor = valor + valorDePaso
    }
    
    @objc func decrementarValor(_ sender: Any) {
        vieneDeTextField = false
        valor = valor - valorDePaso
    }
    
    func actualizarBotones(para valor: Double) {
        let resultadoValidacion = validar(valor: valor)
        switch resultadoValidacion {
        case .mayorAlPermitido:
            habilitar(boton: botonIncremental, estaHabilitado: false)
        case .menorAlPermitido:
            habilitar(boton: botonDecremental, estaHabilitado: false)
        case .rangoValido:
            habilitar(boton: botonIncremental, estaHabilitado: true)
            habilitar(boton: botonDecremental, estaHabilitado: true)
        }
    }
    
    func validar(valor: Double) -> ResultadoValidacion {
        if valorMaximo < valor {
            return .mayorAlPermitido
        }
        if valorMinimo > valor {
            return .menorAlPermitido
        }
        return .rangoValido
    }
    
    func habilitar(boton: UIButton, estaHabilitado: Bool) {
        boton.backgroundColor = estaHabilitado ? .azulPrincipal : .grisDeshabilitado
        boton.isEnabled = estaHabilitado
    }
}

extension IncrementalDecrementalView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let validacion = accionEditando else {
            return true
        }
        return validacion(textField,range, string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let accion = accionFinalizaDeEditar else {
            return
        }
        if let nuevoValor = accion(textField) {
            vieneDeTextField = true
            valor = nuevoValor
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        accionEmpiezaAEditar?()
    }
}

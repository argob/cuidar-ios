//
//  RadioButtonGroup.swift
//  CovidApp
//
//  Created on 4/11/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

@IBDesignable final class RadioButtonGroup: UIView {
    
    private struct Metricas {
        static let anchoBoton: CGFloat = 24.0
        static let espacio: CGFloat = 28.0
    }
    
    lazy private var label1: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var label2: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var identificador: TiposDeElementosDeFormulario?
    var accion: ((TiposDeElementosDeFormulario, String?) -> Void)?
    
    private var radioButton1 = RadioButton()
    private var radioButton2 = RadioButton()
    
    var valorOpcion1: String = "DefaultA"
    var valorOpcion2: String = "DefaultB"
    
    var valorSeleccionado: String? {
        if radioButton1.isSelected {
            return valorOpcion1
        }
        if radioButton2.isSelected {
            return valorOpcion2
        }
        return nil
    }
    
    private enum OpcionRadio: Int {
        case opcion1
        case opcion2
    }
    
    @IBInspectable public var textoOpcion1: String = "" {
        didSet {
            label1.text = textoOpcion1
        }
    }
    
    @IBInspectable public var textoOpcion2: String = "" {
        didSet {
            label2.text = textoOpcion2
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configurar()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurar()
    }
    
    @objc func radioButtonPressed(sender: RadioButton) {
        
        if sender.tag == OpcionRadio.opcion1.rawValue {
            radioButton2.isSelected = false
            radioButton1.isSelected = true
        } else {
            radioButton1.isSelected = false
            radioButton2.isSelected = true
        }
        guard let identificador = identificador else { return }
        accion?(identificador, valorSeleccionado)
    }
    
    private func configurar() {
        radioButton1.tag = OpcionRadio.opcion1.rawValue
        radioButton2.tag = OpcionRadio.opcion2.rawValue
        radioButton1.addTarget(self, action: #selector(radioButtonPressed(sender:)), for: .touchUpInside)
        radioButton2.addTarget(self, action: #selector(radioButtonPressed(sender:)), for: .touchUpInside)
        
        let opcion1 = UIStackView(arrangedSubviews: [radioButton1, label1])
        let opcion2 = UIStackView(arrangedSubviews: [radioButton2, label2])
        
        opcion1.distribution = .fill
        opcion2.distribution = .fill
        opcion1.alignment = .center
        opcion2.alignment = .center
        opcion1.spacing = Metricas.espacio
        opcion2.spacing = Metricas.espacio
        
        let stackview = UIStackView(arrangedSubviews: [opcion1,
                                                       opcion2])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            radioButton1.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
            radioButton1.heightAnchor.constraint(equalToConstant: Metricas.anchoBoton),
            radioButton2.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
            radioButton2.heightAnchor.constraint(equalToConstant: Metricas.anchoBoton),
            stackview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackview.topAnchor.constraint(equalTo: self.topAnchor),
            stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
}

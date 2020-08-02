//
//  PreguntaTableViewCell.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PreguntaTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    private struct Metricas {
        static let spacioEntrePreguntas: CGFloat = 23
        static let alturaDeOpciones: CGFloat = 24
    }
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    var seleccion: ((Bool?) -> Void)?
    var valor: Bool? = false {
        willSet {
            actualizaEstadoDeBotones(newValue)
            seleccion?(newValue)
        }
    }
    
    private lazy var seleccionVerdaderaStackView: SeleccionStackView = {
         let vista = SeleccionStackView()
        vista.seleccionButton.setImage(Constantes.BOTON_NO_CHEQUEADO, for: .normal)
        vista.seleccionButton.setImage(Constantes.BOTON_CHEQUEADO, for: .selected)
        vista.seleccionButton.addTarget(self, action: #selector(cambiarValor), for: .touchUpInside)
        vista.translatesAutoresizingMaskIntoConstraints = false
        return vista
    }()
    
    private lazy var seleccionFalsoStackView: SeleccionStackView = {
        let vista = SeleccionStackView()
        vista.seleccionButton.setImage(Constantes.BOTON_NO_CHEQUEADO, for: .normal)
        vista.seleccionButton.setImage(Constantes.BOTON_CHEQUEADO, for: .selected)
        vista.seleccionButton.addTarget(self, action: #selector(cambiarValor), for: .touchUpInside)
        vista.translatesAutoresizingMaskIntoConstraints = false
        vista.isHidden = false
        return vista
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configurar(viewModel: AutoevaluacionPreguntaViewModel) {
        seleccionFalsoStackView.alignment = .center
        seleccionVerdaderaStackView.opcionLabel.configurar(modelo: viewModel.tituloAfirmativo)
        seleccionFalsoStackView.opcionLabel.configurar(modelo: viewModel.tituloNegativo)
        seleccion = viewModel.seleccion
        valor = viewModel.valor
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension PreguntaTableViewCell {
    
    func commonInit() {
        contentView.addSubview(seleccionVerdaderaStackView)
        contentView.addSubview(seleccionFalsoStackView)
        configuraLayout()
    }

    func configuraLayout() {
        margenDerecho = seleccionVerdaderaStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        margenIzquierdo = seleccionVerdaderaStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenSuperior = seleccionVerdaderaStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = seleccionFalsoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        let constrains = [margenDerecho,
                          margenIzquierdo,
                          margenSuperior,
                          margenInferior,
                          seleccionFalsoStackView.topAnchor.constraint(equalTo: seleccionVerdaderaStackView.bottomAnchor, constant: Metricas.spacioEntrePreguntas),
                          seleccionFalsoStackView.leadingAnchor.constraint(equalTo: seleccionVerdaderaStackView.leadingAnchor),
                          seleccionFalsoStackView.trailingAnchor.constraint(equalTo: seleccionVerdaderaStackView.trailingAnchor)]
        NSLayoutConstraint.activate(constrains.compactMap { $0 })
    }
    
    @objc func cambiarValor(_ sender: Any) {
        guard let vista = sender as? UIButton else {
            return
        }
        valor = vista == seleccionVerdaderaStackView.seleccionButton
    }
    
    func actualizaEstadoDeBotones(_ nuevoValor: Bool?) {
        var seleccionVerdadera = false
        var seleccionFalsa = false
        if let valor = nuevoValor {
            seleccionVerdadera = valor
            seleccionFalsa = !valor
        }
        seleccionVerdaderaStackView.seleccionButton.isSelected = seleccionVerdadera
        seleccionFalsoStackView.seleccionButton.isSelected = seleccionFalsa
    }
}

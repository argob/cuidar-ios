//
//  CajaSeleccionableTableViewCell.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class CajaSeleccionableTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    private struct Metricas {
        static let espacio: CGFloat = 15.0
    }
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    var seleccion: ((Bool, UITableViewCell) -> Void)?
    var valor: Bool = false {
        willSet {
            actualizaEstadoDeBoton(newValue)
            seleccion?(newValue, self)
        }
    }
    
    private lazy var seleccionStackView: SeleccionStackView = {
        let vista = SeleccionStackView()
        vista.spacing = Metricas.espacio
        vista.seleccionButton.setImage(Constantes.CAJA_NO_CHEQUEADA, for: .normal)
        vista.seleccionButton.setImage(Constantes.CAJA_CHEQUEADA, for: .selected)
        vista.seleccionButton.addTarget(self, action: #selector(cambiarValor), for: .touchUpInside)
        vista.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configurar(viewModel: AutoevaluacionCajaSeleccionableViewModel) {
        seleccionStackView.opcionLabel.configurar(modelo: viewModel.titulo)
        seleccion = viewModel.seleccion
        valor = viewModel.valor
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension CajaSeleccionableTableViewCell {
    
    func commonInit() {
        contentView.addSubview(seleccionStackView)
        configuraLayout()
    }

    func configuraLayout() {
        margenSuperior = seleccionStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = seleccionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        margenIzquierdo = seleccionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenDerecho = seleccionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let constrains = [margenSuperior, margenInferior, margenIzquierdo,margenDerecho]
        NSLayoutConstraint.activate(constrains.compactMap { $0 })
    }
    
    @objc func cambiarValor(_ sender: Any) {
        valor = !valor
    }
    
    func actualizaEstadoDeBoton(_ nuevoValor: Bool) {
        seleccionStackView.seleccionButton.isSelected = nuevoValor
    }
}

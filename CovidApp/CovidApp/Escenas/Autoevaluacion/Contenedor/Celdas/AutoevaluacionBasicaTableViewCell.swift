//
//  AutoevaluacionBasicaTableViewCell.swift.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class AutoevaluacionBasicaTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?

    private lazy var textoLabel: UILabel = {
         let label = UILabel()
         label.textColor = .black
         label.textAlignment = .center
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configurar(viewModel: AutoevaluacionTextBasicoViewModel) {
        textoLabel.configurar(modelo: viewModel.titulo)
        textoLabel.textAlignment = viewModel.alineacionDeTexto
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension AutoevaluacionBasicaTableViewCell {
    
    func commonInit() {
        contentView.addSubview(textoLabel)
        configuraLayout()
    }

    func configuraLayout() {
        let constraintsFinales = constraintsComunes()
        NSLayoutConstraint.activate(constraintsFinales.compactMap { $0} )
    }
    
    func constraintsComunes() -> [NSLayoutConstraint?] {
        margenDerecho = textoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        margenIzquierdo = textoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenSuperior = textoLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = textoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        return [margenSuperior, margenIzquierdo, margenDerecho, margenInferior]
    }
}

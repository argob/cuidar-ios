//
//  TextoSinIconoTableView.swift
//  CovidApp
//
//  Created on 18/05/2020.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class TextoSinIconoTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    private lazy var textoLabel: UILabel = {
         let label = UILabel()
         label.textColor = .black
         label.textAlignment = .center
         label.numberOfLines = 0
         label.adjustsFontSizeToFitWidth = true
         label.minimumScaleFactor = 0.0
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
    
    func configurar(viewModel: AutoevaluacionTextoConLogoViewModel) {
        textoLabel.configurar(modelo: viewModel.titulo)
        textoLabel.textAlignment = viewModel.alineacionDeTexto
        
        contentView.backgroundColor = viewModel.colorDeFondo

        configuraLayout(margen: viewModel.margen)
    }
}

private extension TextoSinIconoTableViewCell {
    
    func commonInit() {
        contentView.addSubview(textoLabel)
    }

    func configuraLayout(margen: UIEdgeInsets) {
        let constraintsFinales = constraintsComunes(margen: margen)
        NSLayoutConstraint.activate(constraintsFinales)
     }
    
    func constraintsComunes(margen: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [
            textoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margen.top),
            textoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margen.bottom),
            textoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
    }

}

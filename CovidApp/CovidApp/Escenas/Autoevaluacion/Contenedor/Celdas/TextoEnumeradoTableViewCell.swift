//
//  TextoEnumeradoTableViewCell.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class TextoEnumeradoTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    private struct Metrics {
        static let anchoNumero: CGFloat = 24
        static let separacionNumero: CGFloat = 15
    }
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?

    private lazy var numeroLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.0
        label.layer.cornerRadius = Metrics.anchoNumero / 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
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
    
    func configurar(viewModel: AutoevaluacionTextoEnumeradoViewModel) {
        textoLabel.textAlignment = viewModel.alineacionDeTexto
        textoLabel.text = viewModel.texto
        textoLabel.font = viewModel.fuenteTexto
        textoLabel.textColor = viewModel.colorDeTexto
        numeroLabel.text = viewModel.numero.description
        numeroLabel.font = viewModel.fuenteNumero
        numeroLabel.backgroundColor = viewModel.colorDeNumero
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension TextoEnumeradoTableViewCell {

    func commonInit() {
        contentView.addSubview(numeroLabel)
        contentView.addSubview(textoLabel)
        
        margenSuperior = textoLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = textoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        margenIzquierdo = numeroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenDerecho = textoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        configuraLayout()
    }

    func configuraLayout() {
        let constraints = [
            margenSuperior,
            margenInferior,
            margenIzquierdo,
            margenDerecho,
            numeroLabel.widthAnchor.constraint(equalToConstant: Metrics.anchoNumero),
            numeroLabel.heightAnchor.constraint(equalToConstant: Metrics.anchoNumero),
            numeroLabel.topAnchor.constraint(equalTo: textoLabel.topAnchor),
            textoLabel.leadingAnchor.constraint(equalTo: numeroLabel.trailingAnchor, constant: Metrics.separacionNumero)
        ]
        NSLayoutConstraint.activate(constraints.compactMap{ $0 })
     }
}

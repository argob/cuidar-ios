//
//  TextoConIconoTableViewCell.swift
//  CovidApp
//
//  Created on 4/12/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class TextoConIconoTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    struct Metricas {
        static let anchoDelLogo: CGFloat = 25.0
        static let spacioDelLogo: CGFloat = 17.0
        static let margenImagen: CGFloat = 5.0
    }

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    func configurar(viewModel: AutoevaluacionTextoConLogoViewModel) {
        textoLabel.configurar(modelo: viewModel.titulo)
        textoLabel.textAlignment = viewModel.alineacionDeTexto
        
        logoImageView.tintColor = viewModel.titulo.apariencia.colorTexto
        logoImageView.image = viewModel.logo
        contentView.backgroundColor = viewModel.colorDeFondo

        configuraLayout(margen: viewModel.margen)
    }
}

private extension TextoConIconoTableViewCell {
    
    func commonInit() {
        contentView.addSubview(textoLabel)
        contentView.addSubview(logoImageView)
    }

    func configuraLayout(margen: UIEdgeInsets) {
        var constraintsFinales = constraintsComunes(margen: margen)
        constraintsFinales.append(contentsOf: constraintsDeLogo(margen: margen))
        NSLayoutConstraint.activate(constraintsFinales)
     }
    
    func constraintsComunes(margen: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [textoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margen.top),
                textoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margen.bottom),
                textoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)]
    }
    
    func constraintsDeLogo(margen: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margen.top + Metricas.margenImagen),
                logoImageView.trailingAnchor.constraint(equalTo: textoLabel.leadingAnchor, constant: -Metricas.spacioDelLogo),
                logoImageView.widthAnchor.constraint(equalToConstant: Metricas.anchoDelLogo),
                logoImageView.heightAnchor.constraint(equalToConstant: Metricas.anchoDelLogo)]
    }
}

//
//  SeleccionStackView.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class SeleccionStackView: UIStackView {
    
    private struct Metricas {
        static let anchoBoton: CGFloat = 24.0
        static let espacio: CGFloat = 28.0
    }

    lazy var opcionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()
    
    lazy var seleccionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension SeleccionStackView {
    private func setup() {

        axis = .horizontal
        distribution = .fill
        alignment = .top
        spacing = Metricas.espacio
        
        addArrangedSubview(seleccionButton)
        addArrangedSubview(opcionLabel)
        
        let constraints = [seleccionButton.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           seleccionButton.heightAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                           opcionLabel.heightAnchor.constraint(greaterThanOrEqualTo: seleccionButton.heightAnchor, constant: 1)]
  
        NSLayoutConstraint.activate(constraints)
    }
}

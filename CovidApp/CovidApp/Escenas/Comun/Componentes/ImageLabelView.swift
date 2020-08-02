//
//  DNIErrorLabel.swift
//  CovidApp
//
//  Created on 4/12/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol ImageViewManejador: class {
    func mostrar()
    func ocultar()
}

final class ImageLabeView: UIView {
    
    struct Metricas {
        static let espacio: CGFloat = 10.0
    }
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .rojoPrimario
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    lazy var imagenError: UIImageView = {
        let imagen = UIImageView()
        imagen.translatesAutoresizingMaskIntoConstraints = false
        imagen.contentMode = .scaleAspectFit
        return imagen
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurar()
    }
    
    func configurar() {
        let stackView = UIStackView(arrangedSubviews: [imagenError, errorLabel])
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Metricas.espacio
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagenError.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension ImageLabeView: ImageViewManejador {
    func mostrar() {
        isHidden = false
    }
    
    func ocultar() {
        isHidden = true
    }
}

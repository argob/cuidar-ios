//
//  PasaporteDesvincularDNITableViewCell.swift
//  CovidApp
//
//  Created on 14/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol DelegadoDevincularDNI: class {
    func botonAccionado()
}

final class PasaporteDesvincularDNITableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var botonDesvincular: UIButton!
    
    weak var delegado: DelegadoDevincularDNI?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteDesvincularDNIViewModel) {
        botonDesvincular.setAttributedTitle(viewModel.titulo.attributedText, for: .normal)
        botonDesvincular.titleLabel?.numberOfLines = 2
        botonDesvincular.titleLabel?.textAlignment = .center
        if delegado != nil {
            botonDesvincular.addTarget(self, action: #selector(botonSeleccionado), for: .touchUpInside)
        }
    }
}

private extension PasaporteDesvincularDNITableViewCell {
    @objc func botonSeleccionado(_ sender: UIButton) {
        delegado?.botonAccionado()
    }
}

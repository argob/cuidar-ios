//
//  BotonTableViewCell.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class BotonTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var boton: UIButton!
    weak var delegado: BotonCeldaDelegado?
    var identificador: Identificador?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        delegado = nil
        identificador = nil
        super.prepareForReuse()
    }
    
    func configurar(viewModel: BotonCeldaViewModel) {
        boton.isEnabled = delegado != nil
        boton.configurar(modelo: viewModel.titulo)
        self.identificador = viewModel.identificador
        if delegado != nil {
            boton.addTarget(self, action: #selector(botonSeleccionado), for: .touchUpInside)
        }
    }
}

private extension BotonTableViewCell {
    @objc func botonSeleccionado(_ sender: UIButton) {
        if let identificador = self.identificador {
            delegado?.botonSeleccionado(conIdentificador: identificador)
        }
    }
}

//
//  CertificadoEstadoTableViewCell.swift
//  CovidApp
//
//  Created on 5/19/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class CertificadoEstadoTableViewCell: UITableViewCell, UITableViewCellRegistrable  {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var estado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: CertificadoEstadoViewModel) {
        titulo.configurar(modelo: viewModel.titulo)
        estado.configurar(modelo: viewModel.estado)
    }
}

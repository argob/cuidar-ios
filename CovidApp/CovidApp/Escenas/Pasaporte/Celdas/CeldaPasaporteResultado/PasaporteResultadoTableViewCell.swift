//
//  PasaporteResultadoTableViewCell.swift
//  CovidApp
//
//  Created on 5/19/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class PasaporteResultadoTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var vistaContenedor: UIView!
    @IBOutlet weak var resultadoImagen: UIImageView!
    @IBOutlet weak var resultado: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configurar(viewModel: PasaporteEstadoViewModel) {
        vistaContenedor.backgroundColor = viewModel.colorFondo
        resultado.configurar(modelo: viewModel.estado)
        titulo.configurar(modelo: viewModel.titulo)
        resultadoImagen.image = viewModel.imagen
    }
}

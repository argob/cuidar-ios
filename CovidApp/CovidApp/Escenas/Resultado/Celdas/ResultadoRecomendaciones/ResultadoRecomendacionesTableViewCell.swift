//
//  ResultadoRecomendacionesTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoRecomendacionesTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var masInformacion: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configurar(viewModel: ResultadoRecomendacionesViewModel) {
        titulo.configurar(modelo: viewModel.titulo)
        contenido.configurar(modelo: viewModel.contenido)
        masInformacion.setTitle(viewModel.tituloBoton, for: .normal)
    }
}

//
//  PasaporteCeldaMasInformacionTableViewCell.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteCeldaMasInformacionTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var masInformacion: UILabel!
    @IBOutlet weak var vistaImagen: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var horas: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuracion(viewModel: PasaporteMasInformacionViewModel) {
        vistaImagen.image = viewModel.imagen
        descripcion.configurar(modelo: viewModel.status)
        masInformacion.attributedText = viewModel.masInformacion.attributedText
    }
}

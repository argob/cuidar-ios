//
//  ResultadoNoCompatibleTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoNoCompatibleTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var vista: ShadowView!
    @IBOutlet weak var encabezado: UIView!
    @IBOutlet weak var tituloEncabezado: UILabel!
    @IBOutlet weak var resultado: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var indicaciones: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configurar(viewModel: ResultadoNoCompatibleViewModel) {
        vista.clipsToBounds = true
        encabezado.backgroundColor = viewModel.colorBanner
        encabezado.layer.cornerRadius = 10
        encabezado.clipsToBounds = true
        encabezado.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tituloEncabezado.configurar(modelo: viewModel.titulo)
        resultado.configurarAttributedText(texts: viewModel.resultado)
        imagen.image = viewModel.imagen
        indicaciones.configurarAttributedText(texts: viewModel.indicaciones)
    }
}

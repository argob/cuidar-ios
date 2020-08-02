//
//  ResultadoPositivoTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoPositivoTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var vista: ShadowView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: ResultadoPositivoViewModel) {
        vista.clipsToBounds = true
        header.backgroundColor = viewModel.colorBanner
        header.layer.cornerRadius = 10
        header.clipsToBounds = true
        header.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        titulo.configurar(modelo: viewModel.titulo)
        descripcion.configurarAttributedText(texts: viewModel.contenido)
        telefono.configurar(modelo: viewModel.telefonos)
    }
}

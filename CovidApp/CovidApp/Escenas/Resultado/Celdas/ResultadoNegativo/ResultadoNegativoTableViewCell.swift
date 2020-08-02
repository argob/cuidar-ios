//
//  ResultadoNegativoTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoNegativoTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var vista: ShadowView!
    @IBOutlet weak var encabezado: UIView!
    @IBOutlet weak var tituloEncabezado: UILabel!
    @IBOutlet weak var contenido: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: ResultadoNegativoViewModel) {
        vista.clipsToBounds = true
        encabezado.backgroundColor = viewModel.colorBanner
        encabezado.layer.cornerRadius = 10
        encabezado.clipsToBounds = true
        encabezado.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tituloEncabezado.configurar(modelo: viewModel.titulo)
        contenido.configurarAttributedText(texts: viewModel.contenido)
    }
}

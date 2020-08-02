//
//  ResultadoVideoTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoVideoTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var imagenVideo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: ResultadoVideoViewModel) {
        titulo.configurar(modelo: viewModel.titulo)
        imagenVideo.image = viewModel.video
        imagenVideo.layer.borderColor = UIColor.lightGray.cgColor
        imagenVideo.layer.borderWidth = 2.0
    }
}

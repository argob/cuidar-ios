//
//  QRTableViewCell.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class QRTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var primerEmojiLabel: UILabel!
    @IBOutlet weak var segundoEmojiLabel: UILabel!
    @IBOutlet weak var tercerEmojiLabel: UILabel!
    @IBOutlet weak var qrImagen: UIImageView!
    @IBOutlet weak var mensaje: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteTokenSeguridadViewModel){
        primerEmojiLabel.text = viewModel.primerEmoji
        segundoEmojiLabel.text = viewModel.segundoEmoji
        tercerEmojiLabel.text = viewModel.tercerEmoji
        mensaje.configurar(modelo: viewModel.mensaje)
        titulo.backgroundColor = .white
        titulo.layer.borderWidth = 1.0
        titulo.layer.borderColor = viewModel.tituloBorderColor.cgColor
        titulo.layer.zPosition = 2
        view.layer.borderColor = viewModel.borderColor.cgColor
        view.layer.zPosition = 1
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10
        
        if let imagen = viewModel.QRImage {
            qrImagen.image = imagen
        } else {
            qrImagen.isHidden = true
        }
    }
    
}

//
//  PasaporteTokenRotativoTableViewCell.swift
//  CovidApp
//
//  Created on 15/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteTokenRotativoTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var primerEmoji: UILabel!
    @IBOutlet weak var segundoEmoji: UILabel!
    @IBOutlet weak var tercerEmoji: UILabel!
    @IBOutlet weak var mensaje: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteTokenDinamicoViewModel) {
        primerEmoji.text = viewModel.primerEmoji
        segundoEmoji.text = viewModel.segundoEmoji
        tercerEmoji.text = viewModel.tercerEmoji
        mensaje.configurar(modelo: viewModel.mensaje)
        titulo.backgroundColor = .white
        titulo.layer.borderWidth = 1.0
        titulo.layer.borderColor = viewModel.tituloBorderColor.cgColor
        titulo.layer.zPosition = 2
        view.layer.borderColor = viewModel.borderColor.cgColor
        view.layer.zPosition = 1
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10
    }
}

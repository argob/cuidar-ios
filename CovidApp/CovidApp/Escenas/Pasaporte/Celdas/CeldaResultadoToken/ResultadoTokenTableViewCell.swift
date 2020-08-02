//
//  ResultadoTokenTableViewCell.swift
//  CovidApp
//
//  Created on 5/19/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class ResultadoTokenTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var resultado: UILabel!
    @IBOutlet weak var periodo: UILabel!
    @IBOutlet weak var informacion: UITextView!
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var primerToken: UILabel!
    @IBOutlet weak var segundoToken: UILabel!
    @IBOutlet weak var tercerToken: UILabel!
    @IBOutlet weak var descripcionToken: UILabel!
    @IBOutlet weak var codigoQR: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: ResultadoTokenViewModel) {
        estado.configurar(modelo: viewModel.estado)
        resultado.configurar(modelo: viewModel.resultado)
        periodo.configurar(modelo: viewModel.periodo)
        descripcionToken.configurar(modelo: viewModel.descripcionToken)
        informacion.text = viewModel.informacion.texto
        informacion.attributedText = viewModel.informacion.attributedText
                
        if let imagenQR = viewModel.QRImage {
            codigoQR.image = imagenQR
            codigoQR.isHidden = false
            tokenView.isHidden = true
            return
        }
        
        primerToken?.text = viewModel.primerToken
        segundoToken?.text = viewModel.segundoToken
        tercerToken?.text = viewModel.tercerToken
        
        tokenView.layer.borderColor = UIColor.darkGray.cgColor
        tokenView.layer.borderWidth = 1.0
        tokenView.layer.cornerRadius = 4
        tokenView.isHidden = false
        codigoQR.isHidden = true
    }
}

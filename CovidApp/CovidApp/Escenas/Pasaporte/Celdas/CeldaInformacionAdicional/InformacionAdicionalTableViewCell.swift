//
//  InformacionAdicionalTableViewCell.swift
//  CovidApp
//
//  Created on 5/20/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class InformacionAdicionalTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var informacion: UILabel!
    @IBOutlet weak var vista: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: InformacionAdicionalViewModel) {
        informacion.attributedText = viewModel.informacion
        vista.layer.cornerRadius = 4
    }
}

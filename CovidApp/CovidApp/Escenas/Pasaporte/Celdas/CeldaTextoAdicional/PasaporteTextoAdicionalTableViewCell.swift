//
//  PasaporteTextoAdicionalTableViewCell.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteTextoAdicionalTableViewCell: UITableViewCell, UITableViewCellRegistrable {

    @IBOutlet weak var informacion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteTextoAdicionalViewModel) {
        informacion.configurar(modelo: viewModel.informacion)
    }
}

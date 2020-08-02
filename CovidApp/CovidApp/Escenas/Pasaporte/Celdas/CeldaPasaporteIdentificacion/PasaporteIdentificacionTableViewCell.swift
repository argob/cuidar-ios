//
//  PasaporteIdentificacionTableViewCell.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteIdentificacionTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var dNI: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var SUBE: UILabel!
    @IBOutlet weak var patente: UILabel!
    
    @IBOutlet weak var subeView: UIView!
    @IBOutlet weak var patenteView: UIView!
    
    @IBOutlet weak var botonAsistenciaPBA: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteIdentificacionViewModel) {
        botonAsistenciaPBA.layer.cornerRadius = botonAsistenciaPBA.bounds.height/2
        
        self.nombre.configurar(modelo: viewModel.nombre)
        self.dNI.configurar(modelo: viewModel.dNI)
        self.descripcion.configurar(modelo: viewModel.descripcion)
        if (viewModel.sube != nil && !(viewModel.sube?.isEmpty ?? true)) {
            self.subeView.isHidden = false

            self.SUBE.text = "..." + viewModel.sube!.suffix(8)
        }else{
            self.subeView.isHidden = true
        }
        if (viewModel.patente != nil && !(viewModel.patente?.isEmpty ?? true)) {
            self.patenteView.isHidden = false
            self.patente.text = viewModel.patente
        }else{
            self.patenteView.isHidden = true
        }
        if viewModel.provincia == "Buenos Aires"{
            botonAsistenciaPBA.isHidden = false
        }else{
            botonAsistenciaPBA.isHidden = true
        }
        
    }
}

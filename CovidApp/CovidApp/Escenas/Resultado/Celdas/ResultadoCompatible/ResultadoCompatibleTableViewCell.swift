//
//  ResultadoCompatibleTableViewCell.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoCompatibleTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet weak var vista: ShadowView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: ResultadoCompatibleViewModel) {
        vista.clipsToBounds = true
        header.backgroundColor = viewModel.colorBanner
        header.layer.cornerRadius = 10
        header.clipsToBounds = true
        header.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        titulo.configurar(modelo: viewModel.titulo)

        descripcion.text = viewModel.contenido

        telefono.configurar(modelo: viewModel.telefonos)
    }
}

final class ShadowView: UIView {
    
    private struct Layout {
        static let offsetWidth: CGFloat = 5
        static let offsetHeight: CGFloat = 3
        static let bezierPathPointY: CGFloat = 2
        static let cornerRadius: CGFloat = 10
        static let opacity: Float = 0.5
        static let radius: CGFloat = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.cornerRadius = Layout.cornerRadius
        layer.shadowOffset = CGSize(width: 0, height: Layout.offsetHeight)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Layout.opacity
        layer.shadowRadius = Layout.radius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

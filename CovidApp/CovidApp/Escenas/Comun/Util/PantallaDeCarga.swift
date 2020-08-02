//
//  PantallaDeCarga.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol PantallaDeCargaProtocolo {
    func añadirPantallaDeCarga(enVista: UIView)
    func removerPantallaDeCarga()
}

final class PantallaDeCarga: UIView {
    
    private lazy var indicadorDeActividad: UIActivityIndicatorView = {
        let indicadorDeActividad = UIActivityIndicatorView.customIndicator(width: Constantes.LOAD_PAGE_ACTIVITY_INDICATOR_SIZE,
                                                                           height: Constantes.LOAD_PAGE_ACTIVITY_INDICATOR_SIZE,
                                                                           onView: vistaCuadrado)
        indicadorDeActividad.startAnimating()
        return indicadorDeActividad
    }()
    
    private lazy var vistaCuadrado: UIView = {
        let vista = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: Constantes.LOAD_PAGE_SQUARE_SIZE,
                                         height: Constantes.LOAD_PAGE_SQUARE_SIZE))
        vista.backgroundColor = Constantes.LOAD_PAGE_BACKGROUND_SQUARE_COLOR
        vista.clipsToBounds = true
        vista.layer.cornerRadius = Constantes.LOAD_PAGE_RADIO_SIZE
        return vista
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurarVistas()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurarVistas()
    }
}

extension PantallaDeCarga: PantallaDeCargaProtocolo {
    func añadirPantallaDeCarga(enVista: UIView) {
        frame = enVista.frame
        center = enVista.center
        vistaCuadrado.center = center

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            enVista.addSubview(self)
        }
    }

    func removerPantallaDeCarga() {
        DispatchQueue.main.async { [weak self] in
            self?.removeFromSuperview()
        }
    }
}

private extension PantallaDeCarga {
    func configurarVistas() {
        backgroundColor = Constantes.LOAD_PAGE_BACKGROUND_COLOR
        vistaCuadrado.addSubview(indicadorDeActividad)
        addSubview(vistaCuadrado)
    }
}

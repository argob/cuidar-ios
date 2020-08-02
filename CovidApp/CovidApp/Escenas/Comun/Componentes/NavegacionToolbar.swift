//
//  NavegacionToolbar.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct NavegacionToolbarViewModel {
    let colorActivado: UIColor
    let colorDesactivado: UIColor
    let etapa: NavegacionToolbar.Etapa
}

final class NavegacionToolbar: UIView, XIBInitiable {
    @IBOutlet weak var lineaPrimeraEtapa: UIView!
    @IBOutlet weak var imagenPrimeraEtapa: UIImageView!
    
    @IBOutlet weak var linea1SegundaEtapa: UIView!
    @IBOutlet weak var linea2SegundaEtapa: UIView!
    @IBOutlet weak var imagenSegundaEtapa: UIImageView!
    
    @IBOutlet weak var lineaTerceraEtapa: UIView!
    @IBOutlet weak var imagenTerceraEtapa: UIImageView!
    
    var colorDesactivado: UIColor = .gray
    var colorActivado: UIColor = .black
    
    enum Etapa {
        case primeraEtapa
        case segundaEtapa
        case terceraEtapa
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configurar(etapa: Etapa) {
        switch etapa {
        case .primeraEtapa:
            configurarPrimeraEtapa(activada: true)
            configurarSegundaEtapa(activada: false)
            configurarTerceraEtapa(activada: false)
        case .segundaEtapa:
            configurarPrimeraEtapa(activada: true)
            configurarSegundaEtapa(activada: true)
            configurarTerceraEtapa(activada: false)
        case .terceraEtapa:
            configurarPrimeraEtapa(activada: true)
            configurarSegundaEtapa(activada: true)
            configurarTerceraEtapa(activada: true)
        }
    }
}

private extension NavegacionToolbar {
    func commonInit() {
        let nib = UINib(nibName: Self.xibName, bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
        configurar(etapa: .segundaEtapa)
    }
    
    func configurarPrimeraEtapa(activada: Bool) {
        let color = activada ? colorActivado : colorDesactivado
        lineaPrimeraEtapa.actualizar(relleno: color)
        imagenPrimeraEtapa.isHighlighted = activada
    }
    
    func configurarSegundaEtapa(activada: Bool) {
        let color = activada ? colorActivado : colorDesactivado
        linea1SegundaEtapa.actualizar(relleno: color)
        linea2SegundaEtapa.actualizar(relleno: color)
        imagenSegundaEtapa.isHighlighted = activada
        
    }
    
    func configurarTerceraEtapa(activada: Bool) {
        let color = activada ? colorActivado : colorDesactivado
        lineaTerceraEtapa.actualizar(relleno: color)
        imagenTerceraEtapa.isHighlighted = activada
    }
}

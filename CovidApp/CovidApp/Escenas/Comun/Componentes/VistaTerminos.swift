//
//  VistaTerminos.swift
//  CovidApp
//
//  Created on 4/16/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

@IBDesignable final class VistaTerminos: UIView {
    var accionAceptarTerminos: ((Bool) -> Void)?
    var accionMostrarTerminos: (() -> Void)?
    
    lazy private var terminos: UILabel = {
        let terminos = UILabel()
        terminos.textAlignment = .left
        terminos.clipsToBounds = true
        terminos.numberOfLines = 0
        terminos.minimumScaleFactor = 0.5
        terminos.adjustsFontSizeToFitWidth = true
        terminos.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(abrirTerminos))
        terminos.addGestureRecognizer(tap)
        terminos.isUserInteractionEnabled = true
        return terminos
    }()
    
    lazy private var check: UIButton = {
        let check = UIButton(type: .custom)
        check.setImage(Constantes.CAJA_NO_CHEQUEADA, for: .normal)
        check.setImage(Constantes.CAJA_CHEQUEADA, for: .selected)
        check.frame = CGRect(x: 0, y: 0, width: Constantes.TERMINO_ANCHO_BOTON, height: Constantes.TERMINO_ANCHO_BOTON)
        check.isEnabled = true
        check.isUserInteractionEnabled = true
        check.translatesAutoresizingMaskIntoConstraints = false
        check.addTarget(self, action: #selector(botonAceptarSeleccionado), for: .touchUpInside)
        return check
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configurar()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurar()
    }
    
    @objc func botonAceptarSeleccionado(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        accionAceptarTerminos?(sender.isSelected)
    }
    
    @objc func abrirTerminos(gesture: UITapGestureRecognizer) {
        accionMostrarTerminos?()
    }
    
    func configurar(modelo: AceptarTerminosViewModel) {
        terminos.textColor = modelo.apariencia.colorTexto
        terminos.font = modelo.apariencia.fuente
        check.isSelected = modelo.preSelecionado
        let attributedString = NSMutableAttributedString(string: modelo.texto,
                                                         attributes: [
                                                            NSAttributedString.Key.font: modelo.apariencia.fuente,
                                                            NSAttributedString.Key.foregroundColor: modelo.apariencia.colorTexto])
        
        let boldFontAttribute = [NSAttributedString.Key.font: modelo.aparienciaCustom.fuente,
                                 NSAttributedString.Key.foregroundColor: modelo.aparienciaCustom.colorTexto,
                                 NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        attributedString.addAttributes(boldFontAttribute, range: (modelo.texto as NSString).range(of: Constantes.TERMINO_TITULO_TERMINOS))
        terminos.attributedText = attributedString
    }
    
    private func configurar() {
        let terminosStack = UIStackView(arrangedSubviews: [check, terminos])
        terminosStack.distribution = .fill
        terminosStack.alignment = .center
        terminosStack.spacing = Constantes.TERMINO_ESPACIO
        terminosStack.translatesAutoresizingMaskIntoConstraints = false
        terminosStack.isUserInteractionEnabled = true
        addSubview(terminosStack)
        NSLayoutConstraint.activate([
            check.widthAnchor.constraint(equalToConstant: Constantes.TERMINO_ANCHO_BOTON),
            check.heightAnchor.constraint(equalToConstant: Constantes.TERMINO_ANCHO_BOTON),
            terminosStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            terminosStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            terminosStack.topAnchor.constraint(equalTo: self.topAnchor),
            terminosStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
        )
    }
}

//
//  BotonModelo.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct EstadoValor<Valor> {
    var estado: UIControl.State
    var valor: Valor
    
    static func normal(valor: Valor) -> EstadoValor<Valor> {
        return EstadoValor<Valor>(estado: .normal, valor: valor)
    }
    
    static func selected(valor: Valor) -> EstadoValor<Valor> {
        return EstadoValor<Valor>(estado: .selected, valor: valor)
    }
    
    static func disabled(valor: Valor) -> EstadoValor<Valor> {
        return EstadoValor<Valor>(estado: .disabled, valor: valor)
    }
    
    init(estado: UIControl.State, valor: Valor) {
        self.estado = estado
        self.valor = valor
    }
}

protocol BotonViewModelProtocol {
    var titulos: [EstadoValor<String>] { get set }
    var apariencia: BotonApariencia { get set }
    var estaHabilitado: Bool { get set }
    var estaSeleccionado: Bool { get set }
    var estaEscondido: Bool { get set }
}

struct BotonViewModel: BotonViewModelProtocol {
    var titulos: [EstadoValor<String>]
    var apariencia: BotonApariencia
    var estaHabilitado: Bool
    var estaSeleccionado: Bool
    var estaEscondido: Bool
    init(titulos: [EstadoValor<String>],
         apariencia: BotonApariencia,
         estaHabilitado: Bool = true,
         estaSeleccionado: Bool = false,
         estaEscondido: Bool = false) {
        self.titulos = titulos
        self.apariencia = apariencia
        self.estaHabilitado = estaHabilitado
        self.estaSeleccionado = estaSeleccionado
        self.estaEscondido = estaEscondido
    }
}

extension BotonViewModel {
    static func crearBotonAzul(titulo: String, estaHabilitado: Bool = true) -> BotonViewModel {
        return .init(titulos: [.normal(valor: titulo)],
                     apariencia: .init(tituloFuente: .encodeSansSemiBold(tamaño: 17),
                                       tituloColores: [.normal(valor: .white)],
                                       colorFondo: .azulPrincipal,
                                       colorBorde: .white),
                     estaHabilitado: estaHabilitado)
    }
    
    static func crearBotonBlanco(titulo: String) -> BotonViewModel {
        return .init(titulos: [.normal(valor: titulo)],
                     apariencia: .init(tituloFuente: .encodeSansSemiBold(tamaño: 17),
                                       tituloColores: [.normal(valor: .azulPrincipal)],
                                       colorFondo: .white,
                                       colorBorde: .azulPrincipal,
                                       anchoBorde: 1.0))
    }
    
    static func creatBotonTransparent(titulo: String) -> BotonViewModel {
        return .init(titulos: [.normal(valor: titulo)],
                     apariencia: .init(tituloFuente: .encodeSansSemiBold(tamaño: 16),
                                       tituloColores: [.normal(valor: .azulFuerte)]))
    }
}

struct BotonApariencia {
    var tituloFuente: UIFont
    var tituloColores: [EstadoValor<UIColor>]
    var colorFondo: UIColor?
    var colorBorde: UIColor?
    var anchoBorde: CGFloat?
    var radioEsquina: CGFloat?
    var subrayado: Bool
    
    init(tituloFuente: UIFont,
         tituloColores: [EstadoValor<UIColor>],
         colorFondo: UIColor? = nil,
         colorBorde: UIColor? = nil,
         anchoBorde: CGFloat? = nil,
         radioEsquina: CGFloat? = nil,
         subrayado: Bool = false
    ) {
        self.tituloFuente = tituloFuente
        self.tituloColores = tituloColores
        self.colorFondo = colorFondo
        self.colorBorde = colorBorde
        self.anchoBorde = anchoBorde
        self.radioEsquina = radioEsquina
        self.subrayado = subrayado
    }
}

extension UIButton {
    func configurar(modelo: BotonViewModelAccion) {
        modelo.titulos.forEach { self.setTitle($0.valor, for: $0.estado) }
        self.isEnabled = modelo.estaHabilitado
        self.isSelected = modelo.estaSeleccionado
        self.isHidden = modelo.estaEscondido
        self.configurar(apariencia: modelo.apariencia)
    }
    
    func configurar(modelo: BotonViewModel) {
        modelo.titulos.forEach { self.setTitle($0.valor, for: $0.estado) }
        self.isEnabled = modelo.estaHabilitado
        self.isSelected = modelo.estaSeleccionado
        self.isHidden = modelo.estaEscondido
        self.configurar(apariencia: modelo.apariencia)
    }
    
    func configurar(apariencia: BotonApariencia) {
        self.titleLabel?.font = apariencia.tituloFuente
        apariencia.tituloColores.forEach { self.setTitleColor($0.valor, for: $0.estado) }
        backgroundColor = apariencia.colorFondo
        layer.borderColor = apariencia.colorBorde?.cgColor
        
        if let anchoBorde = apariencia.anchoBorde {
            layer.borderWidth = anchoBorde
        }
        
        if let radioEsquina = apariencia.radioEsquina {
            layer.cornerRadius = radioEsquina
        }
    }
}

struct BotonViewModelAccion: BotonViewModelProtocol {
    var titulos: [EstadoValor<String>]
    var apariencia: BotonApariencia
    var estaHabilitado: Bool
    var estaSeleccionado: Bool
    var estaEscondido: Bool
    var accion: (()-> Void)?
    
    init(titulos: [EstadoValor<String>],
         apariencia: BotonApariencia,
         estaHabilitado: Bool = true,
         estaSeleccionado: Bool = false,
         estaEscondido: Bool = false,
         accion: (() -> Void)? = nil) {
        self.titulos = titulos
        self.apariencia = apariencia
        self.estaHabilitado = estaHabilitado
        self.estaSeleccionado = estaSeleccionado
        self.estaEscondido = estaEscondido
        self.accion = accion
    }
}

extension BotonViewModelAccion {
    static func crearBotonAzul(titulo: String, accion: (() -> Void)?) -> BotonViewModelAccion {
        
        return .init(titulos: [.normal(valor: titulo)],
                     apariencia: .init(tituloFuente: .encodeSansSemiBold(tamaño: 17),
                                       tituloColores: [
                                        .normal(valor: .white),
                                        .disabled(valor: .white)],
                                       colorFondo: .azulPrincipal),
                     accion: accion)
    }
}

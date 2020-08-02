//
//  FactoriaDatosPersonales.swift
//  CovidApp
//
//  Created on 4/11/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

final class FactoriaVistasDeDatosPersonales {
    struct Metricas {
        static let leading: CGFloat = 20.0
        static let trailing: CGFloat = -20.0
        static let altoTitulo: CGFloat = 50
        static let espaciadoSencillo: CGFloat = 5.0
        static let espaciadoDoble: CGFloat = 10.0
        static let espaciadoTriple: CGFloat = 15.0
        static let campoTexto: CGFloat = 60.0
        static let altoErrorDNI: CGFloat = 50.0
        static let altoGenero: CGFloat = 80.0
        static let espaciadoAdicional: CGFloat = 15
    }
    
    typealias VistasFactory = (contenedorVista: UIView, delegadoErrorServicio: ImageViewManejador?, campoTextoDni: UIView, campoTextoTramite: UIView)
    
    private var obterNumeroDeTramiteAction: (() -> Void)?
    weak var delegadoImageError: ImageViewManejador?
    private(set)var height: CGFloat = 0.0
    
    func crearFormulario(viewModel: DatosPersonalesViewModel) -> VistasFactory {
        let contenedorVista = UIView()
        let titulo = crearElemento(elemento: viewModel.titulo)
        let informacionProteccion = crearElemento(elemento: viewModel.proteccionInfo)
        let etiquetaDNI = crearElemento(elemento: viewModel.etiquetaDNI)
        let campoDNI = crearElemento(elemento: viewModel.campoDNI)
        let etiquetaTramite = crearElemento(elemento: viewModel.etiquetaTramite)
        let campoTramite = crearElemento(elemento: viewModel.campoTramite)
        let etiquetaInstruccionesTramite = crearElemento(elemento: viewModel.etiquetaInstruccionesNumeroTramite)
        let campoGenero = crearElemento(elemento: viewModel.campoGenero)
        let errorLabel = crearElemento(elemento: viewModel.mensajeError)

        
        contenedorVista.addSubview(titulo)
        contenedorVista.addSubview(informacionProteccion)
        contenedorVista.addSubview(etiquetaDNI)
        contenedorVista.addSubview(campoDNI)
        contenedorVista.addSubview(etiquetaTramite)
        contenedorVista.addSubview(campoTramite)
        contenedorVista.addSubview(etiquetaInstruccionesTramite)
        contenedorVista.addSubview(campoGenero)
        contenedorVista.addSubview(errorLabel)
    
        func constraintsTitulo() -> [NSLayoutConstraint] {
            height += Metricas.altoTitulo
            return [titulo.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
                    titulo.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
            titulo.topAnchor.constraint(equalTo: contenedorVista.topAnchor),
            titulo.heightAnchor.constraint(equalToConstant: Metricas.altoTitulo)]
        }
        
        func constraintsInformacion() -> [NSLayoutConstraint] {
            height += Metricas.altoTitulo + Metricas.espaciadoSencillo
            return [informacionProteccion.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
            informacionProteccion.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
            informacionProteccion.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: Metricas.espaciadoSencillo),
            informacionProteccion.heightAnchor.constraint(equalToConstant: Metricas.altoTitulo)]
        }
        
        func constraintsEtiquetaDNI() -> [NSLayoutConstraint] {
            return [etiquetaDNI.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
            etiquetaDNI.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
            etiquetaDNI.topAnchor.constraint(equalTo: informacionProteccion.bottomAnchor, constant: Metricas.espaciadoSencillo)]
        }
        
        func constraintsCampoDNI() -> [NSLayoutConstraint] {
            height += Metricas.campoTexto + Metricas.espaciadoSencillo
            return [campoDNI.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor),
            campoDNI.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor),
            campoDNI.topAnchor.constraint(equalTo: etiquetaDNI.bottomAnchor, constant: Metricas.espaciadoSencillo),
            campoDNI.heightAnchor.constraint(equalToConstant: Metricas.campoTexto)]
        }

        func constraintsEtiquetaTramite() -> [NSLayoutConstraint] {
            return [etiquetaTramite.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
                       etiquetaTramite.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
                       etiquetaTramite.topAnchor.constraint(equalTo: campoDNI.bottomAnchor, constant: Metricas.espaciadoSencillo)]
        }
        
        func constraintsCampoTramite() -> [NSLayoutConstraint] {
            height += Metricas.campoTexto + Metricas.espaciadoSencillo
            return [campoTramite.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor),
            campoTramite.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor),
            campoTramite.topAnchor.constraint(equalTo: etiquetaTramite.bottomAnchor, constant: Metricas.espaciadoSencillo),
            campoTramite.heightAnchor.constraint(equalToConstant: Metricas.campoTexto)]
        }
        
        func constraintsEtiquetaInstrucciones() -> [NSLayoutConstraint] {
            return [etiquetaInstruccionesTramite.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
            etiquetaInstruccionesTramite.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
            etiquetaInstruccionesTramite.topAnchor.constraint(equalTo: campoTramite.bottomAnchor, constant: Metricas.espaciadoDoble)]
        }
    
        func constraintsCampoGenero() -> [NSLayoutConstraint] {
            height += Metricas.altoGenero + Metricas.espaciadoTriple
            return [campoGenero.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
            campoGenero.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
            campoGenero.topAnchor.constraint(equalTo: etiquetaInstruccionesTramite.bottomAnchor, constant: Metricas.espaciadoTriple),
            campoGenero.heightAnchor.constraint(equalToConstant: Metricas.altoGenero)]
        }
        
        func constraintsMensajeError() -> [NSLayoutConstraint] {
            height += Metricas.altoErrorDNI + Metricas.espaciadoTriple
            return [
                errorLabel.leadingAnchor.constraint(equalTo: contenedorVista.leadingAnchor, constant: Metricas.leading),
                errorLabel.trailingAnchor.constraint(equalTo: contenedorVista.trailingAnchor, constant: Metricas.trailing),
                errorLabel.topAnchor.constraint(equalTo: campoGenero.bottomAnchor, constant: Metricas.espaciadoTriple),
                errorLabel.heightAnchor.constraint(equalToConstant: Metricas.altoErrorDNI)
            ]
        }
        height += Metricas.espaciadoAdicional
        let constraints = [constraintsTitulo(),
                           constraintsEtiquetaDNI(),
                           constraintsCampoDNI(),
                           constraintsEtiquetaTramite(),
                           constraintsCampoTramite(),
                           constraintsEtiquetaInstrucciones(),
                           constraintsCampoGenero(),
                           constraintsMensajeError(),
                           constraintsInformacion()].reduce([], +)
        NSLayoutConstraint.activate(constraints)
        return (contenedorVista, delegadoImageError, campoDNI, campoTramite)
    }
    
    private func crearElemento(elemento: ElementoDatosPersonales) -> UIView {
        elemento.accept(visitor: self)
    }
}

extension FactoriaVistasDeDatosPersonales: DatosPersonalesElementoVistor {
    
    func visit(viewModel: ObterNumeroDeTramiteBotonViewModel) -> UIView {
        let boton = UIButton(type: .system)
        boton.configurar(modelo: viewModel.boton)
        boton.configurarAttributedText(viewModel: viewModel.boton)
        boton.contentHorizontalAlignment = .left
        obterNumeroDeTramiteAction = viewModel.accion
        boton.addTarget(self, action: #selector(botonSeleccionado), for: .touchUpInside)
        boton.translatesAutoresizingMaskIntoConstraints = false
        return boton
    }
    
    func visit(viewModel: ImageLabelViewModel) -> UIView {
        let imageLabel = ImageLabeView()
        delegadoImageError = imageLabel
        imageLabel.configurar(modelo: viewModel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        return imageLabel
    }
    
    func visit(viewModel: BotonViewModelAccion) -> UIView {
        let boton = BotonNavegacionGeneral()
        boton.translatesAutoresizingMaskIntoConstraints = false
        boton.configurar(modelo: viewModel)
        if let accion = viewModel.accion {
            boton.configurar(controlEvents: .touchUpInside, accion: accion)
        }
        return boton
    }
    
    func visit(viewModel: RadioGroupViewModel) -> UIView {
        let radioGroup = RadioButtonGroup()
        radioGroup.configurar(modelo: viewModel)
        return radioGroup
    }
    
    func visit(modelo: ElementoDeFormularioViewModel) -> UIView {
        let campoTexto = CampoDeTextoSencilloView()
        campoTexto.translatesAutoresizingMaskIntoConstraints = false
        campoTexto.configurar(viewModel: modelo)
        return campoTexto
    }
    
    func visit(etiquetaViewModel: DatosPersonalesEtiquetaViewModel) -> UIView {
        let label = UILabel()
        label.textColor = etiquetaViewModel.color
        label.textAlignment = etiquetaViewModel.alineacion ?? .left
        label.adjustsFontSizeToFitWidth = etiquetaViewModel.ajustarAAncho
        label.clipsToBounds = true
        label.numberOfLines = etiquetaViewModel.numeroLineas
        label.font = etiquetaViewModel.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = etiquetaViewModel.texto
        return label
    }
    func crearBotonSiguiente(modelo: BotonViewModelAccion) -> UIView {
        return crearElemento(elemento: modelo)
    }
}

protocol ElementoDatosPersonales {
    func accept<V: DatosPersonalesElementoVistor>(visitor: V) -> V.Result
}

protocol DatosPersonalesElementoVistor {
    associatedtype Result
    func visit(modelo: ElementoDeFormularioViewModel) -> Result
    func visit(etiquetaViewModel: DatosPersonalesEtiquetaViewModel) -> Result
    func visit(viewModel: RadioGroupViewModel) -> Result
    func visit(viewModel: BotonViewModelAccion) -> Result
    func visit(viewModel: ObterNumeroDeTramiteBotonViewModel) -> Result
    func visit(viewModel: ImageLabelViewModel) -> Result
}

private extension FactoriaVistasDeDatosPersonales {
    @objc func botonSeleccionado() {
        obterNumeroDeTramiteAction?()
    }
}

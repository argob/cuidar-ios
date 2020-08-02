//
//  ResultadoViewModels.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct ResultadoViewModel {
    var elementos: [ResultadoElemento]
}

protocol ResultadoElemento {
    func acceptar<V: ResultadoElementoVisitador>(visitador: V) -> V.Result
}

struct ResultadoCompatibleViewModel: ResultadoElemento {
    var titulo: LabelViewModel
    var contenido: String
    var telefonos: LabelViewModel
    var colorBanner: UIColor
    
    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(resultadoCompatible: self)
    }
}

extension BotonCeldaViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(boton: self)
    }
}

struct ResultadoNoCompatibleViewModel: ResultadoElemento {
    var colorBanner: UIColor
    var titulo: LabelViewModel
    var resultado: [LabelViewModel]
    var imagen: UIImage?
    var indicaciones: [LabelViewModel]

    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(resultadoNoCompatible: self)
    }
}

struct ResultadoPositivoViewModel: ResultadoElemento {
    var titulo: LabelViewModel
    var contenido: [LabelViewModel]
    var telefonos: LabelViewModel
    var colorBanner: UIColor
    
    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(resultadoPositivo: self)
    }
}

struct ResultadoNegativoViewModel: ResultadoElemento {
    var colorBanner: UIColor
    var titulo: LabelViewModel
    var contenido: [LabelViewModel]

    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(resultadoNegativo: self)
    }
}

struct ResultadoRecomendacionesViewModel: ResultadoElemento {
    var titulo: LabelViewModel
    var contenido: LabelViewModel
    var tituloBoton: String
    
    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(recomendaciones: self)
    }
}

struct ResultadoVideoViewModel: ResultadoElemento {
    var titulo: LabelViewModel
    var video: UIImage?
    func acceptar<V>(visitador: V) -> V.Result where V : ResultadoElementoVisitador {
        visitador.visitar(video: self)
    }
}

protocol ResultadoElementoVisitador {
    associatedtype Result
    
    func visitar(resultadoCompatible: ResultadoCompatibleViewModel) -> Result
    func visitar(resultadoNoCompatible: ResultadoNoCompatibleViewModel) -> Result
    func visitar(resultadoPositivo: ResultadoPositivoViewModel) -> Result
    func visitar(resultadoNegativo: ResultadoNegativoViewModel) -> Result
    func visitar(recomendaciones: ResultadoRecomendacionesViewModel) -> Result
    func visitar(video: ResultadoVideoViewModel) -> Result
    func visitar(boton: BotonCeldaViewModel) -> Result
}

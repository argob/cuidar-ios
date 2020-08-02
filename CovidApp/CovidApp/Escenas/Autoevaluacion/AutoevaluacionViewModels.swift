//
//  AutoevaluacionViewModels.swift
//  CovidApp
//
//  Created on 8/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

struct AlertaViewModel {
    let titulo: String
    let mensaje: String
    let tituloCancelar: String
    let tituloAceptar: String
}

protocol AutoevaluacionItemViewModel {
    func aceptar<V: AutoevaluacionItemViewModelVisitante>(visitante: V) -> V.Result
}

protocol AutoevaluacionItemViewModelVisitante {
    associatedtype Result
    
    func visitar(textoConLogo: AutoevaluacionTextoConLogoViewModel) -> Result
    func visitar(textoBasico: AutoevaluacionTextBasicoViewModel) -> Result
    func visitar(textoEnumerado: AutoevaluacionTextoEnumeradoViewModel) -> Result
    func visitar(stepper: AutoevaluacionIncrementalDecrementalViewModel) -> Result
    func visitar(pregunta: AutoevaluacionPreguntaViewModel) -> Result
    func visitar(link: AutoevaluacionLinkViewModel) -> Result
    func visitar(cajaSeleccionable: AutoevaluacionCajaSeleccionableViewModel) -> Result
    func visitar(boton: BotonCeldaViewModel) -> Result

}

struct AutoevaluacionTextoConLogoViewModel: AutoevaluacionItemViewModel {
    var titulo: LabelViewModel
    var alineacionDeTexto: NSTextAlignment
    var margen: UIEdgeInsets
    var colorDeFondo: UIColor
    var logo: UIImage
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(textoConLogo: self)
    }
}

struct AutoevaluacionTextBasicoViewModel: AutoevaluacionItemViewModel {
    var titulo: LabelViewModel
    var alineacionDeTexto: NSTextAlignment
    var margen: UIEdgeInsets
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(textoBasico: self)
    }
}

struct AutoevaluacionTextoEnumeradoViewModel: AutoevaluacionItemViewModel {
    var texto: String
    var numero: Int
    var colorDeNumero: UIColor
    var fuenteNumero: UIFont
    var colorDeTexto: UIColor
    var alineacionDeTexto: NSTextAlignment
    var fuenteTexto: UIFont
    var margen: UIEdgeInsets
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(textoEnumerado: self)
    }
}

struct AutoevaluacionIncrementalDecrementalViewModel: AutoevaluacionItemViewModel {
    var valor: Double
    var fuente: UIFont
    var formato: String
    var valorDePaso: Double
    var valorMaximo: Double
    var valorMinimo: Double
    var separadorDecimal: String
    var margen: UIEdgeInsets
    var cambio: (Double, Bool) -> Void
    var accionEmpiezaAEditar: (() -> Void)?
    var accionEditando: (UITextField, NSRange, String) -> Bool
    var accionTerminaDeEditar: (UITextField) -> Double? 
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(stepper: self)
    }
}

struct AutoevaluacionPreguntaViewModel: AutoevaluacionItemViewModel {
    var identificador: String
    var tituloAfirmativo: LabelViewModel
    var tituloNegativo: LabelViewModel
    var margen: UIEdgeInsets
    var valor: Bool?
    var seleccion: (Bool?) -> Void
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(pregunta: self)
    }
}

struct AutoevaluacionLinkViewModel: AutoevaluacionItemViewModel {
    var texto: String
    var colorDeTexto: UIColor
    var textAlignment: NSTextAlignment
    var fuente: UIFont
    var margen: UIEdgeInsets
    var seleccion: () -> Void
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(link: self)
    }
}

struct AutoevaluacionCajaSeleccionableViewModel: AutoevaluacionItemViewModel {
    var identificador: String
    var titulo: LabelViewModel
    var margen: UIEdgeInsets
    var valor: Bool
    var seleccion: (Bool, UITableViewCell) -> Void
    
    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(cajaSeleccionable: self)
    }
}
struct AutoevaluacionBotonVolverViewModel: AutoevaluacionItemViewModel {
    var boton: BotonCeldaViewModel

    func aceptar<V>(visitante: V) -> V.Result where V : AutoevaluacionItemViewModelVisitante {
        visitante.visitar(boton: self.boton)
    }
}

struct AutoevaluacionGeneralViewModel {
    var tabla: TablaViewModel
    var boton: BotonViewModel
}

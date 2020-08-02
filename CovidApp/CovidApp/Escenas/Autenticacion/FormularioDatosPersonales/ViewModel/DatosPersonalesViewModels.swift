//
//  DatosPersonalesViewModels.swift
//  CovidApp
//
//  Created on 4/12/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension ElementoDeFormularioViewModel: ElementoDatosPersonales {
    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(modelo: self)
    }
}

struct DatosPersonalesEtiquetaViewModel: ElementoDatosPersonales {
    var texto: String
    var color: UIColor?
    var alineacion: NSTextAlignment?
    var font: UIFont?
    var ajustarAAncho: Bool = false
    var numeroLineas: Int = 0
    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(etiquetaViewModel: self)
    }
}

extension RadioGroupViewModel: ElementoDatosPersonales {
    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(viewModel: self)
    }
}

extension ImageLabelViewModel: ElementoDatosPersonales {
    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(viewModel: self)
    }
}

struct ObterNumeroDeTramiteBotonViewModel: ElementoDatosPersonales {
    var boton: BotonViewModel
    var accion: () -> Void

    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(viewModel: self)
    }
}

struct DatosPersonalesViewModel {
    var titulo: DatosPersonalesEtiquetaViewModel
    var proteccionInfo: DatosPersonalesEtiquetaViewModel
    var etiquetaDNI: DatosPersonalesEtiquetaViewModel
    var campoDNI: ElementoDeFormularioViewModel
    var etiquetaTramite: DatosPersonalesEtiquetaViewModel
    var campoTramite: ElementoDeFormularioViewModel
    var etiquetaInstruccionesNumeroTramite: ObterNumeroDeTramiteBotonViewModel
    var campoGenero: RadioGroupViewModel
    var mensajeError: ImageLabelViewModel
    var botonSiguiente: BotonViewModelAccion
}

extension BotonViewModelAccion: ElementoDatosPersonales {
    func accept<V>(visitor: V) -> V.Result where V : DatosPersonalesElementoVistor {
        visitor.visit(viewModel: self)
    }
}

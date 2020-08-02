//
//  ConfirmacionViewModel.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct ConfirmacionViewModel {
    var imagenUsuario: ImageViewModelo
    var tituloPantalla: LabelViewModel
    var etiquetaDNI: LabelViewModel
    var numeroDNI: LabelViewModel
    var fechaNacimiento: LabelViewModel
    var genero: LabelViewModel
    var etiquetaGenero: LabelViewModel
    var etiquetaNacimiento: LabelViewModel
    var nombreUsuario: LabelViewModel
    var botonSiguiente: BotonViewModelAccion
}

struct ConfirmacionUsuarioViewModel {
    var fechaNacimiento: String
}

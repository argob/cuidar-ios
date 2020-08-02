//
//  LabelCustomViewModel.swift
//  CovidApp
//
//  Created on 4/16/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct AceptarTerminosViewModel {
    var texto: String
    var preSelecionado: Bool
    var apariencia: LabelAppearance
    var aparienciaCustom: LabelAppearance
    var accionAceptarTerminos: ((Bool) -> Void)
    var accionMostrarTerminos: (() -> Void)
    
    init(texto: String = "Acepto los Términos y Condiciones de la Aplicacion Cuidar así como a la Política de Privacidad establecida en el punto 5 de los Términos y Condiciones",
         preSeleccionado: Bool,
         apariencia: LabelAppearance = .init(fuente: .robotoMedium(tamaño: 16), colorTexto: .negroSecundario),
         aparienciaCustom: LabelAppearance = .init(fuente: .robotoBold(tamaño: 16), colorTexto: .negroSecundario),
         accionAceptarTerminos: @escaping ((Bool) -> Void),
         accionMostrarTerminos: @escaping (() -> Void)) {
        self.texto = texto
        self.preSelecionado = preSeleccionado
        self.apariencia = apariencia
        self.aparienciaCustom = aparienciaCustom
        self.accionMostrarTerminos = accionMostrarTerminos
        self.accionAceptarTerminos = accionAceptarTerminos
    }
}

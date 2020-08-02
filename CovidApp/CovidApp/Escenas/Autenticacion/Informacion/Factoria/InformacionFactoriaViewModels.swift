//
//  InformacionFactoriaViewModels.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class InformacionFactoriaViewModels {
    func crearViewModelInformacion(para resultado: ResultadoInformacion) -> InformacionViewModel {
        switch resultado {
        case .success:
            return generarContenidoParaExito()
        case .failure(let error):
            return generarContenido(error: error)
        }
    }
}

private extension InformacionFactoriaViewModels {
    func generarContenidoParaExito() -> InformacionViewModel {
        return InformacionViewModel(imagenEncabezado: UIImage(named: "logoCuidar"),
                                    imagenDeMensaje: UIImage(named: "exitoImagen"),
                                    mensaje: .init(texto: "¡Muchas Gracias por tu ayuda!".uppercased(),
                                                   apariencia: LabelAppearance.init(fuente: .encodeSansSemiBold(tamaño: 24),
                                                                                    colorTexto: .negroPrimario)),
                                    indicaciones: .init(texto: "Ahora podremos continuar con el diagnóstico.",
                                                        apariencia: LabelAppearance.init(fuente: .robotoMedium(tamaño: 22),
                                                                                         colorTexto: .white)),
                                    aparienciaBoton: .init(titulos: [.normal(valor: "CONTINUAR")],
                                                           apariencia: BotonApariencia.init(tituloFuente: .encodeSansSemiBold(tamaño: 16),
                                                                                            tituloColores: [.normal(valor: .azulPrincipal)],
                                                                                            colorFondo: .white,
                                                                                            colorBorde: .white,
                                                                                            anchoBorde: 0,
                                                                                            radioEsquina: 29)),
                                    colorGeneral: .azulPrincipal)
    }

    func generarContenido(error: InformacionError) -> InformacionViewModel {
        return InformacionViewModel(imagenEncabezado: UIImage(named: "logoCuidar"),
                                    imagenDeMensaje: UIImage(named: "errorImagen"),
                                    mensaje: .init(texto: error.mensaje,
                                                   apariencia: LabelAppearance.init(fuente: .encodeSansSemiBold(tamaño: 24),
                                                                                    colorTexto: .negroPrimario)),
                                    indicaciones: .init(texto: error.indicaciones,
                                                        apariencia: LabelAppearance.init(fuente: .robotoMedium(tamaño: 22),
                                                                                         colorTexto: .white)),
                                    aparienciaBoton: .init(titulos: [.normal(valor: error.tituloAccion)],
                                    apariencia: BotonApariencia.init(tituloFuente: .encodeSansSemiBold(tamaño: 16),
                                                                     tituloColores: [.normal(valor: .azulPrincipal)],
                                                                     colorFondo: .white,
                                                                     colorBorde: .white,
                                                                     anchoBorde: 0,
                                                                     radioEsquina: 29)),
                                    colorGeneral: .azulPrincipal)
    }
}

//
//  ResultadoFactoriaViewModels.swift
//  CovidApp
//
//  Created on 13/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoFactoriaViewModels {
    let nombre: String
    var coep: Estado.DatosCoep?
    
    init(nombre: String, coep: Estado.DatosCoep?) {
        self.nombre = nombre
        self.coep = coep
    }
    
    func crearViewModelResultado(diagnostico: Estado.Diagnostico) -> ResultadoViewModel {
        return .init(elementos: diagnostico.aceptar(visitor: self))
    }
    
    func crearViewModelMasInformacion(diagnostico: Estado.Diagnostico) -> ResultadoViewModel {
        return .init(elementos: diagnostico.aceptar(visitorActualizar: self))
    }
}

extension ResultadoFactoriaViewModels: VisitadorResultadoAutoevaluacion {
    func visitarDerivadoASaludLocal() -> [ResultadoElemento] {
        return generarContenidoDerivadoASaludLocal()
    }
    
    func visitarSinSintomas() -> [ResultadoElemento] {
        return generarContenidoResultadoSinSintomas()
    }
    
    func visitarDebeAutodiagnosticar() -> [ResultadoElemento] {
        return []
    }
}

extension ResultadoFactoriaViewModels: VisitadorActualizar {
    func visitarInfectado() -> [ResultadoElemento] {
        return generarContenidoResultadoPositivo()
    }
}

private extension ResultadoFactoriaViewModels {
    
    func generarContenidoDerivadoASaludLocal() -> [ResultadoElemento] {
        
        
        var contenido = "\(nombre),   tu autodiagnóstico tiene síntomas compatibles con COVID-19 y fueron reportados.\n\nTe pedimos que no salgas de tu domicilio hasta que no tengas un diagnóstico definitivo.\n\nSi tenés síntomas o necesitás recibir asistencia médica o psicológica podés llamar al:"
        var telefonos = LabelViewModel.init(texto: coep?.descripcion ?? "",
                             apariencia: .init(fuente: .robotoBold(tamaño: 16),
                                               colorTexto: .negroPrimario))
        if (coep?.provincia == Constantes.COEP_CABA) {
            telefonos.texto = ""
            contenido = "\(nombre),  tu autodiagnóstico tiene síntomas compatibles con COVID-19 y fueron reportados.\n\nPor favor comunicate con tu obra social o acercate a una Unidad Febril de Urgencia (UFU):https://bamapas.usig.buenosaires.gob.ar\n\nSi por alguna razón no podés ir, llamá al 📞107.\n\nSi considerás que hubo un error en la carga de tus síntomas entrá a https://www.buenosaires.gob.ar/coronavirus"
        }
        
        return [ResultadoCompatibleViewModel(titulo: .init(texto: "EN EVALUACIÓN",
                                                           apariencia: .init(fuente: .robotoBlack(tamaño: 16),
                                                                             colorTexto: .white)),
                                             contenido: contenido,
                                             telefonos: telefonos,
                                             colorBanner: .rosaPrincipal),
                BotonCeldaViewModel(titulo: .crearBotonAzul(titulo: "ACEPTAR"),
                                    identificador: .aceptar)
        ]
    }
    
    func generarContenidoResultadoSinSintomas() -> [ResultadoElemento] {
        return [ResultadoNoCompatibleViewModel(colorBanner: .verdePrimario,
                                       titulo: .init(texto: "SIN SINTOMAS COVID 19",
                                                     apariencia: .init(fuente: .robotoBlack(tamaño: 16),
                                                                       colorTexto: .white)),
                                       resultado: [.init(texto: "\(nombre), ",
                                                         apariencia: .init(fuente: .robotoRegular(tamaño: 16),
                                                                           colorTexto: .negroSecundario)),
                                                   .init(texto: "no tenés síntomas compatibles con COVID-19.",
                                                         apariencia: .init(fuente: .robotoBold(tamaño: 16),
                                                                           colorTexto: .negroSecundario)),
                                                   .init(texto: "\n\nEs recomendable que hagas el autodiagnóstico cada:", apariencia: .init(fuente: .robotoRegular(tamaño: 16),
                                                   colorTexto: .negroSecundario))],
                                       imagen: UIImage(named: "48horas"),
                                       indicaciones: [.init(texto: "Seguí las medidas de prevención y evita salir de tu casa, para cuidarte vos y no exponer a otras personas.\n\nRecordá que solo podés salir de tu casa para realizar compras en comercios de cercanía. Para otros movimientos necesitás el Certificado Único Habilitante para Circulación.",
                                                            apariencia: .init(fuente: .robotoRegular(tamaño: 16),
                                                                              colorTexto: .negroSecundario))]),
                BotonCeldaViewModel(titulo: .crearBotonAzul(titulo: "ACEPTAR"),
                                    identificador: .aceptar)]
    }
    
    func generarContenidoResultadoPositivo() -> [ResultadoElemento] {
        return [ ResultadoPositivoViewModel(titulo: .init(texto: "DERIVADO A SALUD: COVID-19 POSITIVO",
                                                          apariencia: .init(fuente: .robotoBlack(tamaño: 16),colorTexto: .white)),
                                            contenido: [.init(texto: "\n\(nombre), ",
                                                              apariencia: .init(fuente: .robotoRegular(tamaño: 16),
                                                                                colorTexto: .negroSecundario)),
                                                        .init(texto: "el sistema de salud de tu jurisdicción confirmó tu diagnóstico positivo de coronavirus (COVID-19) ",
                                                              apariencia: .init(fuente: .robotoBold(tamaño: 16),
                                                                                colorTexto: .negroSecundario)),
                                                        .init(texto: "de acuerdo con los análisis de laboratorio.\n\nDebés de seguir estrictamente las recomendaciones médicas y permanecer en aislamiento.\n\nSi tus síntomas empeoran o necesitás asistencia médica o psicológica, ponete en contacto otra vez con el teléfono de asistencia:",
                                                              apariencia: .init(fuente: .robotoRegular(tamaño: 16),
                                                                                colorTexto: .negroSecundario))],
                                            telefonos: .init(texto: coep?.descripcion ?? "",
                                                        apariencia: .init(fuente: .robotoBold(tamaño: 16),
                                                        colorTexto: .negroPrimario)),
                                            colorBanner: .rosaPrincipal),
                BotonCeldaViewModel(titulo: .crearBotonAzul(titulo: "ACEPTAR"),
                                                            identificador: .aceptar)]
    }
}

private extension Estado.Diagnostico {
    func aceptar<V: VisitadorResultadoAutoevaluacion>(visitor: V) -> V.Resultado {
        switch self {
        case .derivadoASaludLocal, .infectado:
            return visitor.visitarDerivadoASaludLocal()
        case .noContagioso, .noInfectado:
            return visitor.visitarSinSintomas()
        case .debeAutodiagnosticarse:
            return visitor.visitarDebeAutodiagnosticar()
        }
    }
    
    func aceptar<V: VisitadorActualizar>(visitorActualizar: V) -> V.Resultado {
        switch self {
        case .derivadoASaludLocal:
            return visitorActualizar.visitarDerivadoASaludLocal()
        case .infectado:
            return visitorActualizar.visitarInfectado()
        case .noContagioso, .noInfectado:
            return visitorActualizar.visitarSinSintomas()
        case .debeAutodiagnosticarse:
            return visitorActualizar.visitarDebeAutodiagnosticar()
        }
    }
}

private protocol VisitadorResultadoAutoevaluacion {
    associatedtype Resultado
    
    func visitarSinSintomas() -> Resultado
    func visitarDerivadoASaludLocal() -> Resultado
    func visitarDebeAutodiagnosticar() -> Resultado
}

private protocol VisitadorActualizar {
    associatedtype Resultado
    
    func visitarSinSintomas() -> Resultado
    func visitarDerivadoASaludLocal() -> Resultado
    func visitarInfectado() -> Resultado
    func visitarDebeAutodiagnosticar() -> Resultado
}

private extension Estado.DatosCoep {
    var descripcion: String {
        return "\(self.provincia): \(self.telefono)"
    }
}

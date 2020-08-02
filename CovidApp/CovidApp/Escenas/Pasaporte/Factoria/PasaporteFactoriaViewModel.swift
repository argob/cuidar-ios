//
//  FactoriaPasaporteViewModel.swift
//  CovidApp
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 10/04/20.
//  Copyright © 2020 Globant. All rights reserved.
//

import UIKit

protocol TipoPasaporte {
    func aceptar<V: VisitadorTipoPasaporte>(visitador: V) -> V.Resultado
}

struct PasaporteCircular: TipoPasaporte {
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(circular: self)
    }
}

struct PasaporteNoCircular: TipoPasaporte {
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(noCircular: self)
    }
}

struct PasaporteNoContagioso: TipoPasaporte {
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(noContagioso: self)
    }
}

struct PasaporteInfectado: TipoPasaporte {
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(infectado: self)
    }
}

protocol VisitadorTipoPasaporte {
    associatedtype Resultado
    func visitar(circular: PasaporteCircular) -> Resultado
    func visitar(noCircular: PasaporteNoCircular) -> Resultado
    func visitar(noContagioso: PasaporteNoContagioso) -> Resultado
    func visitar(infectado: PasaporteInfectado) -> Resultado
}

final class FactoriaPasaporteViewModel {
    func crearModeloPara(tipo: TipoPasaporte) -> PasaporteViewModel {
        return .init(elementos: [crearInformacion(),
                                 PasaporteResultadoTiempoViewModel(),
                                 crearPasaporteTokenSeguridadViewModel(),
                                 PasaporteMasInformacionViewModel(),
                                 PasaporteBotonViewModel()])
    }
}

extension FactoriaPasaporteViewModel {
    func crearInformacion() -> PasaporteIdentificacionViewModel {
        return .init(nombre: "Felipe Martinez Perez",
                     dNI: "DNI: 43.984.562")
    }
    
    func crearPasaporteTokenSeguridadViewModel() -> PasaporteTokenSeguridadViewModel {
        return .init(cornerRadius: 0.0,
                     borderWidth: 0.0,
                     borderColor: nil,
                     QRImage: UIImage(named: "harcoded-QR"),
                     primerEmoji: "☀︎",
                     segundoEmoji: "☂︎",
                     tercerEmoji: "⚠︎",
                     mensaje: "El certificado es válido sólo si coincide el token de seguridad entre telefonoes")
    }
}

private extension FactoriaPasaporteViewModel {
    
}

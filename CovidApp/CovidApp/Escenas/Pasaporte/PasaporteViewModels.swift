//
//  PasaporteViewModels.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct PasaporteViewModel {
    var elementos: [PasaporteElemento]
}

protocol PasaporteElemento {
    func acceptar<V: PasaporteElementoVistador>(visitador: V) -> V.Result
}

struct PasaporteIdentificacionViewModel: PasaporteElemento {
    var nombre: LabelViewModel
    var dNI: LabelViewModel
    var descripcion: LabelViewModel
    var patente: String?
    var sube: String?
    var provincia: String?
}

extension PasaporteIdentificacionViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(identificacionViewModel: self)
    }
}

struct ResultadoTokenViewModel: PasaporteElemento {
    var resultado: LabelViewModel
    var estado: LabelViewModel
    var periodo: LabelViewModel
    var informacion: LabelViewModel
    
    var QRImage: UIImage?
    
    var descripcionToken: LabelViewModel
    var primerToken: String?
    var segundoToken: String?
    var tercerToken: String?
    var esPim: Bool
}

extension ResultadoTokenViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(resultadoTokenViewModel: self)
    }
}

struct InformacionAdicionalViewModel: PasaporteElemento {
    var informacion: NSMutableAttributedString
}

extension InformacionAdicionalViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(informacionAdicionalViewModel: self)
    }
}

struct CertificadoEstadoViewModel: PasaporteElemento {
    var titulo: LabelViewModel
    var estado: LabelViewModel
}

extension CertificadoEstadoViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(certificadoEstadoViewModel: self)
    }
}

struct PasaporteEstadoViewModel: PasaporteElemento {
    var colorFondo: UIColor
    var estado: LabelViewModel
    var titulo: LabelViewModel
    var imagen: UIImage?
}

extension PasaporteEstadoViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(estadoViewModel: self)
    }
}

struct PasaporteResultadoTiempoViewModel: PasaporteElemento {
    var colorFondoPrimeraSeccion: UIColor
    var colorFondoSegundaSeccion: UIColor
    var tiempo: LabelViewModel
    var tiempoDescripcion: LabelViewModel
    var estatus: LabelViewModel
    var descripcion: LabelViewModel
}

extension PasaporteResultadoTiempoViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(resultadoTiempoViewModel: self)
    }
}

struct PasaporteResultadoViewModel: PasaporteElemento {
    var estatusImagen: UIImage?
    
    var titulo: LabelViewModel
    var resultado: LabelViewModel
    var mensaje: LabelViewModel
    var tiempo: LabelViewModel
    var tiempoDescripcion: LabelViewModel
    var masInformacion: LabelViewModel
    var colorFondoPrimeraSeccion: UIColor
    var colorFondoSegundaSeccion: UIColor
    var colorFondoTerceraSeccion: UIColor
    
}

extension PasaporteResultadoViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(resultadoViewModel: self)
    }
}

struct PasaporteTokenSeguridadViewModel: PasaporteElemento {
    //Contenedor
    var borderColor: UIColor
    var tituloBorderColor: UIColor
    var mensaje: LabelViewModel
    var primerEmoji: String?
    var segundoEmoji: String?
    var tercerEmoji: String?
    
    //QR Imagen
    var QRImage: UIImage?
}

extension PasaporteTokenSeguridadViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
       return visitador.visitar(tokenSeguridadViewModel: self)
    }
}

struct PasaporteTokenDinamicoViewModel: PasaporteElemento {
    var borderColor: UIColor
    var tituloBorderColor: UIColor
    var mensaje: LabelViewModel
    //Emojis
    var primerEmoji: String?
    var segundoEmoji: String?
    var tercerEmoji: String?
}

extension PasaporteTokenDinamicoViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(tokenDinamicoViewModel: self)
    }
}

extension BotonCeldaViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(boton: self)
    }
}

struct PasaporteMasInformacionViewModel: PasaporteElemento {
    var status: LabelViewModel
    var masInformacion: LabelViewModel
    var imagen: UIImage?
    var horas: LabelViewModel
}

extension PasaporteMasInformacionViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(masInformacionViewModel: self)
    }
}

struct PasaporteTextoAdicionalViewModel: PasaporteElemento {
    var informacion: LabelViewModel
}

extension PasaporteTextoAdicionalViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(textoAdicionalViewModel: self)
    }
}

struct PasaporteDesvincularDNIViewModel: PasaporteElemento {
    var titulo: LabelViewModel
}

extension PasaporteDesvincularDNIViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(desvincularDNIViewModel: self)
    }
}

struct MultipleCertificatesViewModel: PasaporteElemento {
    let certificates : [Estado.PermisoDeCirculacion]
    let selectedCertificate: Int
}

extension MultipleCertificatesViewModel {
    func acceptar<V>(visitador: V) -> V.Result where V : PasaporteElementoVistador {
        return visitador.visitar(multipleCertificates: self)
    }
}

protocol PasaporteElementoVistador {
    associatedtype Result
    
    func visitar(identificacionViewModel: PasaporteIdentificacionViewModel) -> Result
    func visitar(resultadoTiempoViewModel: PasaporteResultadoTiempoViewModel) -> Result
    func visitar(resultadoViewModel: PasaporteResultadoViewModel) -> Result
    func visitar(estadoViewModel: PasaporteEstadoViewModel) -> Result
    func visitar(resultadoTokenViewModel: ResultadoTokenViewModel) -> Result
    func visitar(certificadoEstadoViewModel: CertificadoEstadoViewModel) -> Result
    func visitar(tokenSeguridadViewModel: PasaporteTokenSeguridadViewModel) -> Result
    func visitar(tokenDinamicoViewModel: PasaporteTokenDinamicoViewModel) -> Result
    func visitar(informacionAdicionalViewModel: InformacionAdicionalViewModel) -> Result
    func visitar(boton: BotonCeldaViewModel) -> Result
    func visitar(masInformacionViewModel: PasaporteMasInformacionViewModel) -> Result
    func visitar(textoAdicionalViewModel: PasaporteTextoAdicionalViewModel) -> Result
    func visitar(desvincularDNIViewModel: PasaporteDesvincularDNIViewModel) -> Result
    func visitar(multipleCertificates: MultipleCertificatesViewModel) -> Result
}

extension PasaporteElementoVistador where Result == Void {
    func visitar(identificacionViewModel: PasaporteIdentificacionViewModel) { }
    func visitar(resultadoTiempoViewModel: PasaporteResultadoTiempoViewModel) { }
    func visitar(resultadoViewModel: PasaporteResultadoViewModel) { }
    func visitar(tokenSeguridadViewModel: PasaporteTokenSeguridadViewModel) { }
    func visitar(tokenDinamicoViewModel: PasaporteTokenDinamicoViewModel) { }
    func visitar(boton: BotonCeldaViewModel) { }
    func visitar(masInformacionViewModel: PasaporteMasInformacionViewModel) { }
    func visitar(textoAdicionalViewModel: PasaporteTextoAdicionalViewModel) { }
    func visitar(desvincularDNIViewModel: PasaporteDesvincularDNIViewModel) { }
}

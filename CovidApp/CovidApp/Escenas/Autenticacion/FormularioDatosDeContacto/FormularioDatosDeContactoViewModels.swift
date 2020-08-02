//
//  FormularioDatosDeContactoViewModels.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

enum TipoDeElemento {
    case sencillo
    case doble
    case seleccionador
}

enum TiposDeElementosDeFormulario {
    case telefono
    case provincia
    case ciudad
    case calle
    case otros
    case numero
    case codigoPostal
    case puerta
    case piso
    // MARK: Casos ingreso manual
    case dni
    case tramite
    case genero
}

struct TipografíaViewModel {
    var fuente: UIFont
    var color: UIColor
}

struct ElementoDeFormularioViewModel {
    var placeholderParaCampoDeTexto: String
    var textoParaCampoDeTexto: String
    var tipografiaCampoDeTexto: TipografíaViewModel
    var textoBajoCampoDeTexto: String
    var tipografiaEtiquetaBajoTexto: TipografíaViewModel
    var metricaDeAltura: Int
    var metricaDeAncho: Int
    var identificador: TiposDeElementosDeFormulario
    var tipoDeElemento: TipoDeElemento
    var datos: [CiudadProvincia]? = nil
    var habilitado: Bool = true
    var editable: Bool = true
    var prefijoCampoDeTexto: String = ""
    var tipoTeclado: UIKeyboardType = .default
}

struct FormularioDatosDeContactoViewModel {
    var tituloParaFormulario: String
    var tamañoFuenteDescripcion: CGFloat
    var elementosDeFormulario: [ElementoDeFormularioViewModel]
    var botonSiguiente: BotonViewModel
}

struct DatosDeContacto {
    var provincia: String?
    var localidad: String?
    var calle: String?
    var numero: String?
    var piso: String? = ""
    var puerta: String? = ""
    var codigoPostal: String?
    var otros: String? = ""
    var telefono: String?
    
    func direccionEsValida() -> Bool {
        guard let provincia = provincia, let localidad = localidad, let calle = calle, let numero = numero, let codigoPostal = codigoPostal else {
            return false
        }
        return provincia != "" && localidad != "" && calle != "" && numero != "" && codigoPostal != ""
    }
    
    func validarCamposOpcionales() -> Bool {
        guard  otros != nil,  piso != nil, puerta != nil else {
            return false
        }
        return true
    }
    
    init(con informacionUsuario: Sesion.InformacionDeUsuario?) {
        telefono = informacionUsuario?.telefono
        calle = informacionUsuario?.domicilio?.calle
        codigoPostal = informacionUsuario?.domicilio?.codigoPostal
        localidad = informacionUsuario?.domicilio?.localidad
        numero = informacionUsuario?.domicilio?.numero
        otros = informacionUsuario?.domicilio?.otros ?? ""
        piso = informacionUsuario?.domicilio?.piso ?? ""
        provincia = informacionUsuario?.domicilio?.provincia
        puerta = informacionUsuario?.domicilio?.puerta ?? ""
    }
    
}

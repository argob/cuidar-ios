//
//  ExtensionUIFont.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UIFont {
    static func robotoMedium(tamaño: CGFloat) -> UIFont {
        return UIFont.fuente(nombre: .roboto, grueso: .medium, tamaño: tamaño)
    }
    
    static func robotoLight(tamaño: CGFloat) -> UIFont {
        return UIFont.fuente(nombre: .roboto, grueso: .light, tamaño: tamaño)
    }

    static func robotoBold(tamaño: CGFloat) -> UIFont {
        return UIFont.fuente(nombre: .roboto, grueso: .bold, tamaño: tamaño)
    }
    
    static func robotoRegular(tamaño: CGFloat) -> UIFont {
        return UIFont.fuente(nombre: .roboto, grueso: .regular, tamaño: tamaño)
    }
    
    static func robotoBlack(tamaño: CGFloat) -> UIFont {
        return UIFont.fuente(nombre: .roboto, grueso: .black, tamaño: tamaño)
    }
    
    static func encodeSansSemiBold(tamaño: CGFloat) -> UIFont {
        return .fuente(nombre: .encodeSans, grueso: .semibold, tamaño: tamaño)
    }
    
    static func encodeSansMedium(tamaño: CGFloat) -> UIFont {
        return .fuente(nombre: .encodeSans, grueso: .medium, tamaño: tamaño)
    }
}

private extension UIFont {
    enum FontWeight: String {
        case light = "-Light"
        case bold = "-Bold"
        case medium = "-Medium"
        case regular = "-Regular"
        case semibold = "-SemiBold"
        case black = "-Black"
    }
    
    enum SupportedFonts: String {
        case roboto = "Roboto"
        case encodeSans = "EncodeSans"
    }
    
    enum FontExtensions: String {
        case ttf = "ttf"
    }
    
    static func fuente(nombre: SupportedFonts, grueso: FontWeight, tamaño: CGFloat) -> UIFont {
        let nombreFuente = nombre.rawValue + grueso.rawValue
        var fuente = UIFont(name: nombreFuente, size: tamaño)
    
        
        if let fuenteExistente = fuente {
            return fuenteExistente
        }

        if registrarFuente(nombreArchivo: nombreFuente, tipo: FontExtensions.ttf.rawValue, bundle: Bundle(for: self)) {
            fuente = UIFont(name: nombreFuente, size: tamaño)
        }
        
        return fuente ?? UIFont.systemFont(ofSize: tamaño)
    }
    
    static func registrarFuente(nombreArchivo: String, tipo: String, bundle: Bundle?) -> Bool {
        guard
            let bundle = bundle,
            let ruta = bundle.path(forResource: nombreArchivo, ofType: tipo),
            let fuenteDato = NSData(contentsOfFile: ruta),
            let provedorDato = CGDataProvider(data: fuenteDato),
            let fuenteReferencia = CGFont(provedorDato)
        else {
            return false
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        
        return !(CTFontManagerRegisterGraphicsFont(fuenteReferencia, &errorRef) == false)
    }
}

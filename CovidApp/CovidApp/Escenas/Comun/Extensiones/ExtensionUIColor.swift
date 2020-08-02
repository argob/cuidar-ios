//
//  ExtensionUIColor.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UIColor {
    static var azulFuerte = from(hex: 0x1C7CD5)         // 28, 124, 213
    static var azulCyan = from(hex: 0x00B3EE)           // 0, 179, 238
    static var azulPrincipal = from(hex: 0x37BBE9)      // 55, 187, 233
    static var rosaPrincipal = from(hex: 0xEE3D8F)      // 238, 61, 143
    static var verdePrimario = from(hex: 0x50B8B1)      // 80, 184, 177
    static var verdeSecundario = from(hex: 0x8FD693)    // 143, 214, 147
    static var azulPrimario = from(hex: 0x3372B4)       // 51, 113, 180
    static var azulSecundario = from(hex: 0x5084BB)     // 80, 132, 187
    static var rosaSecundario = from(hex: 0xEB8CB8)     // 235, 140, 184
    static var negroTerciario = from(hex: 0x50525C)     // 80, 82, 92
    static var negroSecundario = from(hex: 0x525252)    // 82, 82, 82
    static var negroPrimario = from(hex: 0x383838)      // 56, 56, 56
    static var grisBorde = from(hex: 0x707070)          // 112, 112, 112
    static var grisFuente = from(hex: 0x626262)         // 98, 98, 98
    static var grisSecundario = from(hex: 0xEDEDED)     // 237, 237, 237
    static var rojoPrimario = from(hex: 0xCB2E25)       // 203, 45, 37
    static var grisFuerte = from(hex: 0x373A3C)         // 12, 34, 56
    static var grisPrincipal = from(hex: 0x4A4D58)      // 74, 77, 88
    static var grisTerciario = from(hex: 0x707070)      // 112, 112, 112
    static var grisDeshabilitado = from(hex: 0xD2D2D2)  // 210, 210, 210
    static var grisFondo = from(hex: 0xF2F2F2)          // 242, 242, 242
    static var verde = from(hex: 0x78B444)
    static var azul = from(hex: 0x29ABE2)
    static var rosa = from(hex: 0xE31C72)
    static var celeste = from(hex: 0xCCF2FF)
}

private extension UIColor {
    static func from(hex valor: Int, alpha: CGFloat = 1.0) -> UIColor {
        let rojo = (valor >> 16) & 0xFF
        let verde = (valor >> 8) & 0xFF
        let azul = valor & 0xFF
        
        return UIColor(
            red: CGFloat(rojo) / 255.0,
            green: CGFloat(verde) / 255.0,
            blue: CGFloat(azul) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

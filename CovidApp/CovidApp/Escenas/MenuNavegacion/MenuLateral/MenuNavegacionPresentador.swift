//
//  MenuNavegacionPresentador.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

enum MenuOpcionNagevacion {
    case diagnosticoTercero
    case listaTerceros
    case validador
}

struct OpcionMenu {
    let descripcion: String
    let iconoBoton: String
    let opcionMenu: MenuOpcionNagevacion
}

struct MenuNavegacionPiePagina {
    let informacionImportante: String
    let descripcionRedesSociales: String
    let iconoRedesSociales: String
    let iconoInformacionImportante: String
    let colorPiePagina: UIColor
}

enum OpcionNavegacion {
    case cerrarSesion
    case editarInformacion
    case videoLlamada
    case informacion
    case informacionRedes
    case informacionPBA
}

struct ViewModelMenuNavegacion {
    let nombreUsuario: LabelViewModel
    let DNI: LabelViewModel
    let telefono: LabelViewModel
    let direccion: LabelViewModel
    let direccion2: LabelViewModel
    let direccion3: LabelViewModel
    let provincia: String
}

protocol MenuLateralDelegado: class {
    func cerrarMenu()
    func opcionSeleccionada(_ opcion: OpcionNavegacion)
}

protocol MenuNavegacionPresentadorProtocolo {
    
}

extension MVPVista where Self: MenuNavegacionVista {
    func inyectar() -> MenuNavegacionPresentadorProtocolo {
        let presentador = MenuNavegacionPresentador()
        presentador.vista = self
        return presentador
    }
}

private final class MenuNavegacionPresentador: MVPPresentador {
    weak var vista: MenuNavegacionVista?
}

extension MenuNavegacionPresentador: MenuNavegacionPresentadorProtocolo {
    func escenaCargo() {
        vista?.configurarMenu(con: generarInformacionMenu())
    }
    
    private func generarInformacionMenu() -> ViewModelMenuNavegacion {
        
        return ViewModelMenuNavegacion(
            nombreUsuario: LabelViewModel(texto: "Mock", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            DNI: LabelViewModel(texto: "DNI: 43.984.562", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            telefono: LabelViewModel(texto: "43.984.562", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            direccion: LabelViewModel(texto: "Sample", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            direccion2: LabelViewModel(texto: "Sample", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            direccion3: LabelViewModel(texto: "Sample", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            provincia: "Buenos Aires"
        )
    }
}

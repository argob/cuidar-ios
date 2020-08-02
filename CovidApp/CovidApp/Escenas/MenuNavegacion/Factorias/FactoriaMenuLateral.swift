//
//  FactoriaMenuLateral.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol FactoriaMenuLateral {
    func crear(viewModel: ViewModelMenuNavegacion, delegado: MenuLateralDelegado) -> MenuLateralVista
}


struct FactoriaVistaMenuLateral: FactoriaMenuLateral {
    func crear(viewModel: ViewModelMenuNavegacion, delegado: MenuLateralDelegado) -> MenuLateralVista {
        let menuVista = MenuLateralVista()
        menuVista.menuOpciones = crearMenuOpciones(viewModel: viewModel)
        menuVista.menuOpciones.delegado = delegado
        menuVista.configurarMenuOpciones(provincia: viewModel.provincia)
        return menuVista
    }
    
    private func crearMenuOpciones(viewModel: ViewModelMenuNavegacion) -> ContenedorMenuLateral {
        guard let menuOpciones = ContenedorMenuLateral.fromXib() else {
            assertionFailure("Es necesario que este presente un Menu cargado de un xib")
            return ContenedorMenuLateral()
        }
        menuOpciones.configurar(viewModel: viewModel)
        return menuOpciones
    }
}

//
//  AutoevaluacionConsejosCompletosPresentador.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol AutoevaluacionConsejosCompletosProtocolo {
    func recibir(elementos: [AutoevaluacionItemViewModel])
    func manejarBotonCerrar()
}

extension MVPVista where Self: AutoevaluacionConsejosCompletosVista {
    func inyectar() -> AutoevaluacionConsejosCompletosProtocolo  {
        let presenter = AutoevaluacionConsejosCompletosPresentador()
        presenter.vista = self
        return presenter
    }
}

final class AutoevaluacionConsejosCompletosPresentador: MVPPresentador {
    weak var vista: AutoevaluacionConsejosCompletosVista?
}

extension AutoevaluacionConsejosCompletosPresentador: AutoevaluacionConsejosCompletosProtocolo {
    
    func escenaCargo() {
        let viewModel = TablaViewModel(permiteSeleccion: false,
                                       alturaDeCelda: UITableView.automaticDimension,
                                       estiloDeSeparador: .none)
        vista?.configurarTabla(viewModel: viewModel)
    }
    
    func manejarBotonCerrar() {
        vista?.regresarAAutoevaluacion()
    }
    
    func recibir(elementos: [AutoevaluacionItemViewModel]) {
        vista?.cargar(elementos: elementos)
     }
}


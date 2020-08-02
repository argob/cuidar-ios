//
//  AutoevaluacionFactoria.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

final class AutoevaluacionFactoriaCeldas {
    typealias DelegadoCeldas = BotonCeldaDelegado
    
    weak var delegado: DelegadoCeldas?

    let tableView: UITableView
    let indexPath: IndexPath
    
    init(tableView: UITableView, indexPath: IndexPath,  delegado: DelegadoCeldas? = nil) {
        self.tableView = tableView
        self.indexPath = indexPath
        self.delegado = delegado
    }
 
    static func registrarCeldas(for tabla: UITableView) {
        TextoSinIconoTableViewCell.registerCodeCell(inTableView: tabla)
        AutoevaluacionBasicaTableViewCell.registerCodeCell(inTableView: tabla)
        IncrementalDecrementalTableViewCell.registerCodeCell(inTableView: tabla)
        TextoEnumeradoTableViewCell.registerCodeCell(inTableView: tabla)
        LinkTableViewCell.registerCodeCell(inTableView: tabla)
        PreguntaTableViewCell.registerCodeCell(inTableView: tabla)
        CajaSeleccionableTableViewCell.registerCodeCell(inTableView: tabla)
        BotonTableViewCell.registerCell(inTableView: tabla)
    }
    
    func crearCelda(elemento: AutoevaluacionItemViewModel) -> UITableViewCell {
        return elemento.aceptar(visitante: self)
    }
}

extension AutoevaluacionFactoriaCeldas: AutoevaluacionItemViewModelVisitante {
    typealias Result = UITableViewCell
    
    func visitar(textoBasico: AutoevaluacionTextBasicoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: AutoevaluacionBasicaTableViewCell.cellIdentifier,
                                                        for: indexPath) as? AutoevaluacionBasicaTableViewCell else {
                                                            return .init()
        }
        celda.configurar(viewModel: textoBasico)
        return celda
    }
    
    func visitar(textoConLogo: AutoevaluacionTextoConLogoViewModel) -> Result {
         guard let celda = tableView.dequeueReusableCell(withIdentifier: TextoSinIconoTableViewCell.cellIdentifier,
                                                         for: indexPath) as? TextoSinIconoTableViewCell else {
                                                             return .init()
         }
         celda.configurar(viewModel: textoConLogo)
         return celda
     }
    
    func visitar(textoEnumerado: AutoevaluacionTextoEnumeradoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: TextoEnumeradoTableViewCell.cellIdentifier,
                                                            for: indexPath) as? TextoEnumeradoTableViewCell else {
                                                                return .init()
            }
        celda.configurar(viewModel: textoEnumerado)
        return celda
    }
    
    func visitar(stepper: AutoevaluacionIncrementalDecrementalViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: IncrementalDecrementalTableViewCell.cellIdentifier,
                                                            for: indexPath) as? IncrementalDecrementalTableViewCell else {
                                                                return .init()
        }
        celda.configurar(viewModel: stepper)
        return celda
    }
    
    func visitar(pregunta: AutoevaluacionPreguntaViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: PreguntaTableViewCell.cellIdentifier,
                                                            for: indexPath) as? PreguntaTableViewCell else {
                                                                return .init()
            }
        celda.configurar(viewModel: pregunta)
        return celda
    }
    
    func visitar(link: AutoevaluacionLinkViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: LinkTableViewCell.cellIdentifier,
                                                            for: indexPath) as? LinkTableViewCell else {
                                                                return .init()
            }
        celda.configurar(viewModel: link)
        return celda
    }
        
    func visitar(cajaSeleccionable: AutoevaluacionCajaSeleccionableViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: CajaSeleccionableTableViewCell.cellIdentifier,
                                                        for: indexPath) as? CajaSeleccionableTableViewCell else {
                                                            return .init()
        }
        celda.configurar(viewModel: cajaSeleccionable)
        return celda
    }
    func visitar(boton: BotonCeldaViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier:     BotonTableViewCell.cellIdentifier,
                                                        for: indexPath) as? BotonTableViewCell else {
                                                            return .init()
        }
        celda.delegado = delegado
        celda.configurar(viewModel: boton)
        return celda
    }

}

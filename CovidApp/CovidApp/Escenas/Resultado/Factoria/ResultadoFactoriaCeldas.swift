//
//  ResultadoFactoriaCeldas.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class ResultadoFactoriaCeldas: ResultadoElementoVisitador {
    typealias DelegadoCeldas = BotonCeldaDelegado
    
    let tableView: UITableView
    let indexPath: IndexPath
    weak var delegado: DelegadoCeldas?
    
    init(tableView: UITableView, indexPath: IndexPath, delegado: DelegadoCeldas?) {
        self.tableView = tableView
        self.indexPath = indexPath
        self.delegado = delegado
    }
    
    func crearCelda(elemento: ResultadoElemento) -> UITableViewCell {
        return elemento.acceptar(visitador: self)
    }
    
    func visitar(resultadoCompatible: ResultadoCompatibleViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoCompatibleTableViewCell", for: indexPath) as? ResultadoCompatibleTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: resultadoCompatible)
        return celda
    }
    
    func visitar(boton: BotonCeldaViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "BotonTableViewCell",
                                                        for: indexPath) as? BotonTableViewCell
        else {
            return .init()
        }
        celda.delegado = delegado
        celda.configurar(viewModel: boton)
        return celda
    }
    
    func visitar(video: ResultadoVideoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoVideoTableViewCell", for: indexPath) as? ResultadoVideoTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: video)
        return celda
    }
    
    func visitar(resultadoNegativo: ResultadoNegativoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoNegativoTableViewCell", for: indexPath) as? ResultadoNegativoTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: resultadoNegativo)
        return celda
    }
    
    func visitar(resultadoPositivo: ResultadoPositivoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoPositivoTableViewCell", for: indexPath) as? ResultadoPositivoTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: resultadoPositivo)
        return celda
    }
    
    func visitar(recomendaciones: ResultadoRecomendacionesViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoRecomendacionesTableViewCell", for: indexPath) as? ResultadoRecomendacionesTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: recomendaciones)
        return celda
    }
    
    func visitar(resultadoNoCompatible: ResultadoNoCompatibleViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoNoCompatibleTableViewCell", for: indexPath) as? ResultadoNoCompatibleTableViewCell else {
            return .init()
        }
        
        celda.configurar(viewModel: resultadoNoCompatible)
        return celda
    }
}

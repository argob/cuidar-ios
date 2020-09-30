//
//  PasaporteFactoriaCeldas.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteFactoriaCeldas: PasaporteElementoVistador {
    typealias DelegadoCeldas = BotonCeldaDelegado & DelegadoDevincularDNI & DelegadoCertificadosTableViewCell
    
    let tableView: UITableView
    let indexPath: IndexPath
    
    weak var delegado: DelegadoCeldas?
    
    init(tableView: UITableView, indexPath: IndexPath, delegado: DelegadoCeldas? = nil) {
        self.tableView = tableView
        self.indexPath = indexPath
        self.delegado = delegado
    }
    
    func crearCelda(elemento: PasaporteElemento) -> UITableViewCell {
        return elemento.acceptar(visitador: self)
    }
    
    func visitar(identificacionViewModel: PasaporteIdentificacionViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteIdentificacionTableViewCell",
                                                        for: indexPath) as? PasaporteIdentificacionTableViewCell
        else {
            return .init()
        }
        
        celda.configurar(viewModel: identificacionViewModel)
        return celda
    }
    
    func visitar(resultadoTiempoViewModel: PasaporteResultadoTiempoViewModel) -> UITableViewCell {
         guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteResultadoTiempoTableViewCell",
                                                         for: indexPath) as? PasaporteResultadoTiempoTableViewCell
        else {
            return .init()
        }
               
        celda.configurar(viewModel: resultadoTiempoViewModel)
        return celda
    }
    
    func visitar(resultadoViewModel: PasaporteResultadoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteResultadoPositivoTableViewCell",
                                                        for: indexPath) as? PasaporteResultadoPositivoTableViewCell
        else {
            return .init()
        }
        celda.configurar(viewModel: resultadoViewModel)
        
        return celda
    }
    
    func visitar(informacionAdicionalViewModel: InformacionAdicionalViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "InformacionAdicionalTableViewCell",
                                                        for: indexPath) as? InformacionAdicionalTableViewCell
        else {
            return .init()
        }
        celda.configurar(viewModel: informacionAdicionalViewModel)
        
        return celda
    }
    
    func visitar(estadoViewModel: PasaporteEstadoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteResultadoTableViewCell",
                                                        for: indexPath) as? PasaporteResultadoTableViewCell
        else {
            return .init()
        }
        celda.configurar(viewModel: estadoViewModel)
        
        return celda
    }
    
    func visitar(certificadoEstadoViewModel: CertificadoEstadoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "CertificadoEstadoTableViewCell",
                                                        for: indexPath) as? CertificadoEstadoTableViewCell
        else {
            return .init()
        }
        celda.configurar(viewModel: certificadoEstadoViewModel)
        
        return celda
    }
    
    func visitar(resultadoTokenViewModel: ResultadoTokenViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "ResultadoTokenTableViewCell",
                                                        for: indexPath) as? ResultadoTokenTableViewCell
        else {
            return .init()
        }
        celda.configurar(viewModel: resultadoTokenViewModel)
        
        return celda
    }
    
    func visitar(tokenSeguridadViewModel: PasaporteTokenSeguridadViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "QRTableViewCell",
                                                        for: indexPath) as? QRTableViewCell
        else {
            return .init()
        }
        
        celda.configurar(viewModel: tokenSeguridadViewModel)
        return celda
    }
    
    func visitar(tokenDinamicoViewModel: PasaporteTokenDinamicoViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteTokenRotativoTableViewCell",
                                                        for: indexPath) as? PasaporteTokenRotativoTableViewCell
        else {
            return .init()
        }
        
        celda.configurar(viewModel: tokenDinamicoViewModel)
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
    
    func visitar(masInformacionViewModel: PasaporteMasInformacionViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteCeldaMasInformacionTableViewCell",
                                                        for: indexPath) as? PasaporteCeldaMasInformacionTableViewCell
        else {
            return .init()
        }
        celda.configuracion(viewModel: masInformacionViewModel)
        return celda
    }
    
    func visitar(textoAdicionalViewModel: PasaporteTextoAdicionalViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteTextoAdicionalTableViewCell",
                                                        for: indexPath) as? PasaporteTextoAdicionalTableViewCell
        else {
            return .init()
        }
        
        celda.configurar(viewModel: textoAdicionalViewModel)
        return celda
    }
    
    func visitar(desvincularDNIViewModel: PasaporteDesvincularDNIViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PasaporteDesvincularDNITableViewCell",
                                                        for: indexPath) as? PasaporteDesvincularDNITableViewCell
            else {
                return .init()
        }
        celda.delegado = delegado
        celda.configurar(viewModel: desvincularDNIViewModel)
        return celda
    }
    
    func visitar(multipleCertificates: MultipleCertificatesViewModel) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "MultipleCertificateTableViewCell",
                                                       for: indexPath) as? MultipleCertificateTableViewCell
           else {
               return .init()
        }
        celda.delegate = delegado
        celda.configView(viewModel: multipleCertificates)
        return celda
    }

}

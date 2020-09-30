//
//  PasaporteViewController.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol PasaporteVista: class, VisualizadorDeCarga {
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func mostrarAlertaDesvincularDNI(viewModel: AlertaDesvincularDNIViewModel)
    func configurar(viewModel: PasaporteViewModel)
    func configurarTablaContenido()
    func habilitarCirculacion()
    func nuevoAutodiagnostico()
    func desvincularSesion()
    func presentarMasInformacion()
    func presentarInformacionPBA()
    func presentarAlerta(viewModel: AlertViewModel)
    func configurarMenu(con viewModel: ViewModelMenuNavegacion?)
    func editarDatosPersonales()
    func terminarRefresh()
    func mostrarConsejos()
}

final class PasaporteViewController: BaseViewController, MVPVista {
    @IBOutlet weak var tablaDeContenido: UITableView!
    
    var expandCellSelectedIndex : IndexPath?

    private var elementos: [PasaporteElemento] = [] {
        didSet {
            tablaDeContenido.reloadData()
        }
    }
    private var alturaCeldas = [IndexPath: CGFloat]()
    lazy var presentador: PasaportePresentadorProtocol = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    var menuLateral: MenuLateralVista!
    
    var refreshControl = UIRefreshControl()

}

extension PasaporteViewController: PasaporteVista {
    
    func configurar(viewModel: PasaporteViewModel) {
        self.elementos = viewModel.elementos
        refreshControl.attributedTitle = NSAttributedString(string: "↓ para refrescar")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tablaDeContenido.addSubview(refreshControl)
    }
    
    func terminarRefresh() {
        refreshControl.endRefreshing()
    }
    
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        self.barraNavegacionPersonalizada.delegado = self
        self.barraNavegacionPersonalizada.configurarBarraNavegacion(viewModel: viewModel)
        self.barraNavegacionPersonalizada.modoVisible = true
    }
    
    func configurarTablaContenido() {
        tablaDeContenido.delegate = self
        tablaDeContenido.dataSource = self
        PasaporteIdentificacionTableViewCell.registerCell(inTableView: tablaDeContenido)
        QRTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteResultadoTiempoTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteCeldaMasInformacionTableViewCell.registerCell(inTableView: tablaDeContenido)
        BotonTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteResultadoPositivoTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteTextoAdicionalTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteDesvincularDNITableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteTokenRotativoTableViewCell.registerCell(inTableView: tablaDeContenido)
        PasaporteResultadoTableViewCell.registerCell(inTableView: tablaDeContenido)
        CertificadoEstadoTableViewCell.registerCell(inTableView: tablaDeContenido)
        ResultadoTokenTableViewCell.registerCell(inTableView: tablaDeContenido)
        InformacionAdicionalTableViewCell.registerCell(inTableView: tablaDeContenido)
        MultipleCertificateTableViewCell.registerCell(inTableView: tablaDeContenido)
    }
    
    func habilitarCirculacion() {
        enrutador.habilitarCirculacion()
    }
    
    func nuevoAutodiagnostico() {
        enrutador.nuevoAutodiagnostico()
    }
    
    func desvincularSesion() {
        enrutador.desvinculaciónTerminada()
    }
    
    func editarDatosPersonales() {
        enrutador.edicionDatosPersonales()
    }
    
    func presentarMasInformacion() {
        DispatchQueue.main.async { [weak self] in
            self?.enrutador.masInformacionPasaporte()
        }
    }
    
    func presentarInformacionPBA() {
        DispatchQueue.main.async { [weak self] in
            self?.enrutador.informacionPBA()
        }
    }
    func mostrarAlertaDesvincularDNI(viewModel: AlertaDesvincularDNIViewModel) {
          let alerta = FactoriaAlertViewController.crearAlertDesvincularDNIController(viewModel: viewModel)
          navigationController?.present(alerta, animated: true)
      }
    
    func presentarAlerta(viewModel: AlertViewModel) {
        present(crearAlerta(viewModel: viewModel), animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presentador.manejarRefresh(showTips: true)
    }
    func mostrarConsejos() {
        self.enrutador.consejos()
    }
    
}

extension PasaporteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = elementos.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factoria = PasaporteFactoriaCeldas(tableView: tableView,
                                               indexPath: indexPath,
                                               delegado: self)
        let celda = factoria.crearCelda(elemento: elementos[indexPath.row])
        celda.selectionStyle = .none
        UIView.performWithoutAnimation {
            celda.layoutIfNeeded()
        }
        return celda
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        alturaCeldas[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if expandCellSelectedIndex == indexPath {
            return 150
        }
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return alturaCeldas[indexPath] ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.isKind(of: MultipleCertificateTableViewCell.self) ?? false {
            self.expandCellSelectedIndex = indexPath
        }else {
            self.expandCellSelectedIndex = nil
        }
        tableView.reloadData()
        
        elementos[indexPath.row].acceptar(visitador: self)
    }
}

extension PasaporteViewController: BotonCeldaDelegado {
    func botonSeleccionado(conIdentificador identificador: Identificador) {
        presentador.manejarBotonConIdentificador(identificador: identificador)
    }
}

extension PasaporteViewController: DelegadoDevincularDNI {
    func botonAccionado() {
        presentador.manejarSeleccionDesvincularCuenta()
    }
}

extension PasaporteViewController: DelegadoCertificadosTableViewCell {
    func certificateSelected(selectedCertificate: Estado.PermisoDeCirculacion) {
        UserDefaults.standard.set(selectedCertificate.idCertificado!, forKey: "CerificateSelected")
        expandCellSelectedIndex = nil
        presentador.manejarRefresh(showTips: false)
    }
}


extension PasaporteViewController: PasaporteElementoVistador {
    func visitar(tokenDinamicoViewModel: PasaporteTokenDinamicoViewModel) { }
    
    func visitar(identificacionViewModel: PasaporteIdentificacionViewModel) {
        presentador.manejarOpcionPBA()
    }
    
    func visitar(textoAdicionalViewModel: PasaporteTextoAdicionalViewModel) { }
    func visitar(tokenSeguridadViewModel: PasaporteTokenSeguridadViewModel) { }
    func visitar(resultadoTiempoViewModel: PasaporteResultadoTiempoViewModel) { }
    func visitar(desvincularDNIViewModel: PasaporteDesvincularDNIViewModel) {}
    func visitar(multipleCertificates: MultipleCertificatesViewModel) {}
    func visitar(estadoViewModel: PasaporteEstadoViewModel) -> () {}
    func visitar(certificadoEstadoViewModel: CertificadoEstadoViewModel) -> () {}
    func visitar(informacionAdicionalViewModel: InformacionAdicionalViewModel) -> () {
        presentador.manejarAbrirURL("https://www.argentina.gob.ar/coronavirus/telefonos")
    }
    func visitar(resultadoTokenViewModel: ResultadoTokenViewModel) -> () {
        if !resultadoTokenViewModel.esPim {
            if resultadoTokenViewModel.QRImage == nil {
                presentador.manejarPresentarMasInformacion()
            } else {
                presentador.manejarAbrirURL("https://www.argentina.gob.ar/circular")
            }
        }
    }
    func visitar(resultadoViewModel: PasaporteResultadoViewModel)  {
        presentador.manejarPresentarMasInformacion()
    }
    
    func visitar(masInformacionViewModel: PasaporteMasInformacionViewModel) {
        presentador.manejarPresentarMasInformacion()
    }
    
    func visitar(boton: BotonCeldaViewModel) {
        presentador.manejarBotonConIdentificador(identificador: boton.identificador)
    }
}

private extension PasaporteViewController {
    func crearAlerta(viewModel: AlertViewModel) -> UIAlertController {
        let controller = UIAlertController(title: viewModel.title,
                                           message: viewModel.body,
                                           preferredStyle: .alert)
        viewModel.buttons.compactMap { boton in
            UIAlertAction(title: boton.title, style: boton.style) { (_) in
                boton.action?()
            }
        }.forEach(controller.addAction)
        
        return controller
    }
}

extension PasaporteViewController: DelegadoBarraNavegacionPersonalizada {
    func botonIzquierdoAccionado() {
        menuLateral.toggle(accion: .abrir)
    }
}

extension PasaporteViewController: MenuNavegacionVista {
    
    func agregar(vista: BaseViewController) {
        agregar(vista, vistaContenedor: self.view)
    }
    
    func configurarMenu(con viewModel: ViewModelMenuNavegacion?) {
        guard let viewModel = viewModel else { return }
        let factoria: FactoriaMenuLateral = FactoriaVistaMenuLateral()
        menuLateral = factoria.crear(viewModel: viewModel, delegado: self)
        menuLateral.configurar(view: self.view)
    }
}

extension PasaporteViewController: MenuLateralDelegado {
    func opcionSeleccionada(_ opcion: OpcionNavegacion) {
        switch opcion {
        case .cerrarSesion:
            presentador.manejarSeleccionDesvincularCuenta()
        case .editarInformacion:
            presentador.manejarEdiciondeDatos()
        case .videoLlamada:
            presentador.manejarAbrirURL("https://www.argentina.gob.ar/noticias/servicio-de-videollamada-para-personas-sordas-e-hipoacusicas")
        case .informacion:
            presentador.manejarAbrirURL("https://www.argentina.gob.ar/salud/coronavirus-COVID-19")
        case .informacionRedes:
            presentador.manejarAbrirURL("https://www.argentina.gob.ar/salud")
        case .informacionPBA:
            presentador.manejarOpcionPBA()
        }
    }
    
    func cerrarMenu() {
        menuLateral.toggle(accion: .cerrar)
    }
}

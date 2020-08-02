//
//  ResultadoViewController.swift
//  CovidApp
//
//  Created on 12/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol ResultadoVista: class {
    func configurar(viewModel: ResultadoViewModel)
    func configurarTablaContenido()
    func removerContenido()
    func resultadoTerminado()
    func descartar()
}

final class ResultadoViewController: BaseViewController, MVPVista {
    @IBOutlet weak var tablaContenido: UITableView!
    @IBOutlet weak var cerrarBoton: UIButton!
    
    private var elementos: [ResultadoElemento] = [] {
        didSet {
            tablaContenido.reloadData()
        }
    }
    private var alturaCeldas = [IndexPath: CGFloat]()
    
    lazy var presentador: ResultadoPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    
    @objc func cerrarSeleccionado(_ sender: UIButton) {
        presentador.manejarBotonCerrar(esPresentado: presentingViewController != nil)
    }
}

extension ResultadoViewController: ResultadoVista {
    func configurar(viewModel: ResultadoViewModel) {
        self.elementos = viewModel.elementos
        cerrarBoton.addTarget(self, action: #selector(cerrarSeleccionado), for: .touchUpInside)
        barraNavegacionPersonalizada.modoVisible = false
    }
    
    func configurarTablaContenido() {
        tablaContenido.delegate = self
        tablaContenido.dataSource = self
        ResultadoCompatibleTableViewCell.registerCell(inTableView: tablaContenido)
        ResultadoNoCompatibleTableViewCell.registerCell(inTableView: tablaContenido)
        ResultadoPositivoTableViewCell.registerCell(inTableView: tablaContenido)
        ResultadoNegativoTableViewCell.registerCell(inTableView: tablaContenido)
        ResultadoRecomendacionesTableViewCell.registerCell(inTableView: tablaContenido)
        ResultadoVideoTableViewCell.registerCell(inTableView: tablaContenido)
        BotonTableViewCell.registerCell(inTableView: tablaContenido)
    }
    
    func removerContenido() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resultadoTerminado() {
        enrutador.resultadoTerminado()
    }
    
    func descartar() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ResultadoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factoria = ResultadoFactoriaCeldas(tableView: tableView,
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
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return alturaCeldas[indexPath] ?? UITableView.automaticDimension
    }
}

extension ResultadoViewController: BotonCeldaDelegado {
    func botonSeleccionado(conIdentificador identificador: Identificador) {
        presentador.manejarBotonConIdentificador(
            identificador: identificador,
            esPresentado: presentingViewController != nil)
    }
}

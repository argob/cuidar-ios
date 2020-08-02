//
//  AutoevaluacionConsejosCompletosViewController.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol AutoevaluacionConsejosCompletosVista: class {
    func configurarTabla(viewModel: TablaViewModel)
    func cargar(elementos: [AutoevaluacionItemViewModel])
    func regresarAAutoevaluacion()
}

final class AutoevaluacionConsejosCompletosViewController: BaseViewController, MVPVista {
    private struct Metricas {
        static let margenes = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        static let anchoBoton: CGFloat = 100
        static let alturaBoton: CGFloat = 30
    }

    lazy var presentador: AutoevaluacionConsejosCompletosProtocolo = self.inyectar()
    private var elementos: [AutoevaluacionItemViewModel] = [] {
        didSet {
            tabla.reloadData()
        }
    }
    lazy var tabla: UITableView = {
        let tabla = UITableView(frame: view.frame, style: .plain)
        tabla.dataSource = self
        tabla.translatesAutoresizingMaskIntoConstraints = false
        return tabla
    }()
    
    private lazy var cerrarButton: UIButton = {
        let button = UIButton(type: .system)
        button.configurar(modelo: .creatBotonTransparent(titulo: "CERRAR"))
        button.addTarget(self, action: #selector(cerrarControlador), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

private extension AutoevaluacionConsejosCompletosViewController {
    func configuracionDeLayout() {
        view.backgroundColor = .white
        view.addSubview(cerrarButton)
        view.addSubview(tabla)
        let margenes = view.layoutMarginsGuide
        let constraint = [tabla.topAnchor.constraint(equalTo: margenes.topAnchor, constant: Metricas.margenes.top),
                          tabla.leadingAnchor.constraint(equalTo: margenes.leadingAnchor, constant: Metricas.margenes.left),
                          tabla.trailingAnchor.constraint(equalTo: margenes.trailingAnchor, constant: -Metricas.margenes.right),
                          cerrarButton.topAnchor.constraint(equalTo: tabla.bottomAnchor),
                          cerrarButton.trailingAnchor.constraint(equalTo: margenes.trailingAnchor, constant: -Metricas.margenes.right),
                          cerrarButton.bottomAnchor.constraint(equalTo: margenes.bottomAnchor, constant: -Metricas.margenes.bottom),
                          cerrarButton.widthAnchor.constraint(equalToConstant: Metricas.anchoBoton),
                          cerrarButton.heightAnchor.constraint(equalToConstant: Metricas.alturaBoton),]
        NSLayoutConstraint.activate(constraint)
    }
    
    @objc func cerrarControlador(_ sender: Any) {
        presentador.manejarBotonCerrar()
    }
}

extension AutoevaluacionConsejosCompletosViewController: AutoevaluacionConsejosCompletosVista {

    func configurarTabla(viewModel: TablaViewModel) {
        tabla.configurar(modelo: viewModel)
        AutoevaluacionBasicaTableViewCell.registerCodeCell(inTableView: tabla)
        TextoEnumeradoTableViewCell.registerCodeCell(inTableView: tabla)
        configuracionDeLayout()
    }
    
    func cargar(elementos: [AutoevaluacionItemViewModel]) {
        self.elementos = elementos
    }
    
    func regresarAAutoevaluacion() {
        self.dismiss(animated: true)
    }
}

extension AutoevaluacionConsejosCompletosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factoria = AutoevaluacionFactoriaCeldas(tableView: tableView, indexPath: indexPath)
        let celda = factoria.crearCelda(elemento: elementos[indexPath.row])
        return celda
    }
}


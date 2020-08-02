//
//  TablaOpcionesTextField.swift
//  CovidApp
//
//  Created on 22/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit
import Foundation

protocol ManejoOpcionesDelegado: class {
    func recibirOpcionSeleccionada(valor: String, identificador: TiposDeElementosDeFormulario?)
}

final class TablaOpcionesVista: UITableViewController {
    weak var delegado: ManejoOpcionesDelegado?
    var searchBar: UISearchBar!
    var opciones: [CiudadProvincia] = [] {
        didSet { opcionesFiltered = opciones }
    }
    var opcionesFiltered: [CiudadProvincia] = [] {
        didSet { tableView.reloadData() }
    }
    var identificador: TiposDeElementosDeFormulario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = crearElementosHeader()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constantes.TABLA_OPCIONES_VISTA_CELDA_OPCION)
    }
    
    private func crearElementosHeader() -> UIView {
        let searchViewFrame = CGRect(x:0, y: 0, width: self.view.frame.size.width, height: Constantes.TABLA_OPCIONES_VISTA_ALTURA_ITEMS)
        let searchView = UIView(frame: searchViewFrame)
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - Constantes.TABLA_OPCIONES_VISTA_ESPACIO_CANCELAR, height: Constantes.TABLA_OPCIONES_VISTA_ALTURA_ITEMS))
        self.searchBar = searchBar
        let closeButton = UIButton(frame: CGRect(x: searchBar.frame.size.width, y:0, width: Constantes.TABLA_OPCIONES_VISTA_ESPACIO_CANCELAR, height: Constantes.TABLA_OPCIONES_VISTA_ALTURA_ITEMS))
        closeButton.setTitle(Constantes.TABLA_OPCIONES_VISTA_CANCELAR, for: .normal)
        closeButton.setTitleColor(.azulPrincipal, for: .normal)
        closeButton.addTarget(self, action: #selector(salir), for: .touchUpInside)
        searchBar.delegate = self
        searchBar.placeholder = Constantes.TABLA_OPCIONES_VISTA_PLACEHOLDER
        searchView.addSubview(searchBar)
        searchView.addSubview(closeButton)
        return searchView
    }
    
    @objc private func salir() {
        dismiss(animated: true)
    }
    
    func configurar(opciones: [CiudadProvincia], identificador: TiposDeElementosDeFormulario?) {
        self.opciones = opciones
        self.identificador = identificador
        searchBar.text = ""
        searchBar.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        opcionesFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: Constantes.TABLA_OPCIONES_VISTA_CELDA_OPCION, for: indexPath)
        celda.textLabel?.textAlignment = .center
        celda.textLabel?.text = opcionesFiltered[indexPath.row].obtenerNombre()
        return celda
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valor = opcionesFiltered[indexPath.row].obtenerNombre()
        delegado?.recibirOpcionSeleccionada(valor: valor, identificador: identificador)
        salir()
    }
    
}

extension TablaOpcionesVista: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        opcionesFiltered = opciones.filter {
          let searchTextToCompare = searchText.comparableString()
          let comparableName = $0.obtenerNombre().comparableString()
          return comparableName.contains(searchTextToCompare)
        }
    }
}

fileprivate extension String {
  func comparableString() -> String {
    self.lowercased().folding(options: .diacriticInsensitive, locale: .current)
  }
}

//
//  ExtensionUITableView.swift
//  CovidApp
//
//  Created on 4/15/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UITableView {
    func configurar(modelo: TablaViewModel) {
        self.allowsSelection = modelo.permiteSeleccion
        self.rowHeight = modelo.alturaDeCelda
        self.separatorStyle = modelo.estiloDeSeparador
    }
}

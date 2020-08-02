//
//  ExtensionUIApplication.swift
//  CovidApp
//
//  Created on 16/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol UIApplicationProtocol: class {
    func openURL(_ url: URL) -> Bool
}

extension UIApplication: UIApplicationProtocol {}

extension MVPVista where Self: CoordinadorDeVistas {
    func inyectar() -> UIApplicationProtocol {
        return UIApplication.shared
    }
}

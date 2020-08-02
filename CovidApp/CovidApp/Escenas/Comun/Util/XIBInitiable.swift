//
//  XIBInitiable.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol XIBInitiable: class {
    static var xibBundle: Bundle { get }
    static var xibName: String { get }
}

extension XIBInitiable {
    static var xibBundle: Bundle {
        return Bundle(for: Self.self)
    }
    static var xibName: String {
        return String(describing: Self.self)
    }
    static func fromXib() -> Self? {
        return xibBundle.loadNibNamed(xibName, owner: self, options: nil)?.first as? Self
    }
}

//
//  AlertViewModel.swift
//  CovidApp
//
//  Created on 20/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

struct AlertViewModel {
    var body: String
    var title: String
    var buttons: [ButtonAlertViewModel]
}

struct ButtonAlertViewModel {
    var title: String
    var style: UIAlertAction.Style
    var action: (() -> Void)?
}

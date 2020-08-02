//
//  NoneCopyPasteCutTextField.swift
//  CovidApp
//
//  Created on 18/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class NoneCopyPasteCutTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


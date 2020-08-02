//
//  RoundedCornerView.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
      didSet {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
      }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
      didSet {
        layer.borderWidth = borderWidth
      }
    }
    
    @IBInspectable var borderColor: UIColor? {
      didSet {
        layer.borderColor = borderColor?.cgColor
      }
    }
}

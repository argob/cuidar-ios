//
//  UIActivityIndicatorView+Extension.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    public static func customIndicator(width: CGFloat, height: CGFloat, onView: UIView) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        indicator.style = .whiteLarge
        indicator.layer.cornerRadius = 0
        indicator.center = CGPoint(x: onView.frame.size.width / 2, y: onView.frame.size.height / 2);
        indicator.hidesWhenStopped = true
        return indicator
    }
}

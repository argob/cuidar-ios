//
//  LinkTextView.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class LinkTextView: UITextView {
    
    var accionTap: (() -> Void)?

    convenience init() {
        self.init(frame: .zero)
        self.delegate = self
    }
    
    func putInformation(texto: String, color: UIColor) {
        let attributedString = NSMutableAttributedString()
        let url = URL(string: "http:")!
        let masAttributos: [NSAttributedString.Key : Any] = [.link: url]
        attributedString.append(NSAttributedString(string: texto, attributes: masAttributos))
        
        attributedText = attributedString
        isUserInteractionEnabled = true
        isEditable = false

        linkTextAttributes = [.foregroundColor: color,
                              .underlineStyle: NSUnderlineStyle.single.rawValue]
    }
}

extension LinkTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        accionTap?()
        return false
    }
}

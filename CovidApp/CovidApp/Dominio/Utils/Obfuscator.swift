//
//  Obfuscator.swift
//  CovidApp
//
//  Created on 5/26/20.
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import Foundation

class Obfuscator {
    
    // MARK: - Variables
    private var salt: String
    
    // MARK: - Initialization
    
    init() {
        self.salt = "\(String(describing: AppDelegate.self))\(String(describing: NSObject.self))"
    }
    
    init(with salt: String) {
        self.salt = salt
    }
    
    // MARK: - Instance Methods
    
    func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        return encrypted
    }
    
    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }
}

//
//  SessionCache.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import Security

protocol SesionPersistencia {
    func getSesion() -> Sesion?
    func guardar(sesion: Sesion)
    func borrar()
}

extension DominioFachada {
    static func inyectar() -> SesionPersistencia {
        return SesionPersistenciaSegura.instancia
    }
}

private final class SesionPersistenciaSegura {
    private let accessQueue = DispatchQueue(label: "KeychainDatastore",
                                            qos: .userInitiated,
                                            attributes: .concurrent,
                                            autoreleaseFrequency: .inherit)
    
    static let instancia = SesionPersistenciaSegura()
}

extension SesionPersistenciaSegura: SesionPersistencia {
    static let sesionKey = "com.covidapp.sesionkey"
    private static var baseQuery: [String: Any] {
        return [kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: SesionPersistenciaSegura.sesionKey]
    }
    
    func getSesion() -> Sesion? {
        accessQueue.sync {
            var query = SesionPersistenciaSegura.baseQuery
            query[String(kSecMatchLimit)] = kSecMatchLimitOne
            query[String(kSecReturnAttributes)] = kCFBooleanTrue
            query[String(kSecReturnData)] = kCFBooleanTrue
            
            var queryResult: AnyObject?
            let status = withUnsafeMutablePointer(to: &queryResult) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
            
            guard
                status == noErr,
                let item = queryResult as? [String : Any],
                let data = item[kSecValueData as String] as? Data
            else {
                return nil
            }
            
            do {
                return try JSONDecoder().decode(Sesion.self, from: data)
            } catch {
                print("[DEBUG] Error obteniendo sesion del keychain \(error)")
                return nil
            }
        }
    }
    
    func guardar(sesion: Sesion) {
        accessQueue.async(flags: .barrier) {
            do {
                let data = try JSONEncoder().encode(sesion)
                var query = SesionPersistenciaSegura.baseQuery
                
                query[kSecValueData as String] = data
                let deleteStatus = SecItemDelete(query as CFDictionary)
                guard deleteStatus == noErr || deleteStatus == errSecItemNotFound else {
                    return
                }
                let status = SecItemAdd(query as CFDictionary, nil)
                
                if status != noErr {
                    print("Error saving session \(status)")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func borrar() {
        UserDefaults.standard.removeObject(forKey: Constantes.LEGAL_DELTA)
        accessQueue.async(flags: .barrier) {
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: SesionPersistenciaSegura.sesionKey]
            
            _ = SecItemDelete(query as CFDictionary)
        }
    }
}

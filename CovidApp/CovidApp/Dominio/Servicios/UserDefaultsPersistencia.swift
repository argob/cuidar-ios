//
//  UserDefaultsPersistencia.swift
//  CovidApp
//
//  Created on 20/05/2020.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol UserDefaultsPersistencia {
    var deviceToken: String? { get set}
}

extension DominioFachada {
    static func inyectar() -> UserDefaultsPersistencia {
        return UserDefaultsPersistenciaNoSegura.instancia
    }
}

private final class UserDefaultsPersistenciaNoSegura: UserDefaultsPersistencia {
    static let instancia = UserDefaultsPersistenciaNoSegura()
    @Storage(key: "device_Token", defaultValue: "")
    var deviceToken: String?
}

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}


//
//  NotificacionFachada.swift
//  CovidApp
//
//  Created on 19/05/2020.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol NotificacionFachadaProtocolo {
    func registrarDispositivo()
    func desregistrarDispositivo()
    func registrarDispositivoEnElServivor(deviceId: String)
}

extension MVPPresentador {
    static func inyectar() -> NotificacionFachadaProtocolo {
        return NotificacionFachada.instancia
    }
}

extension AppDelegate {
    static func inyectar() -> NotificacionFachadaProtocolo {
        return NotificacionFachada.instancia
    }
}


private final class NotificacionFachada: NSObject, DominioFachada {
    static let instancia = NotificacionFachada()
    private let httpCliente: HTTPCliente
    private let sesionPersistencia: SesionPersistencia
    private var userDefaults: UserDefaultsPersistencia = inyectar()
    
    private lazy var notificationCenter: UNUserNotificationCenter = {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        return notificationCenter
    }()
    
    private init(httpCliente: HTTPCliente = inyectar(), sesionPersistencia: SesionPersistencia = inyectar()) {
        self.httpCliente = httpCliente
        self.sesionPersistencia = sesionPersistencia
    }
}

extension NotificacionFachada: NotificacionFachadaProtocolo {
    func registrarDispositivo() {
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self?.registrarParaNotificationesRemotas()
            case .notDetermined:
                self?.pedirAcceso()
            default:
                break
            }
        }
    }
    
    func desregistrarDispositivo() {
        desregistrarDispositivoEnElServivor()
        DispatchQueue.main.async {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func registrarDispositivoEnElServivor(deviceId: String) {
        guard
            let sesion = sesionPersistencia.getSesion()
        else {
            return
        }
        let solicitud = RegistrarDispositivo(dni: sesion.dni, sexo: sesion.sexo, deviceId: deviceId)
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            if (200...299).contains(respuesta.httpResponse?.statusCode ?? 0) {
                self?.userDefaults.deviceToken = deviceId
            }
        }
    }
    
    func desregistrarDispositivoEnElServivor() {
        guard
            let sesion = sesionPersistencia.getSesion(),
            let deviceToken = userDefaults.deviceToken
        else {
            return
        }
        let solicitud = DesregistrarDispositivo(dni: sesion.dni, sexo: sesion.sexo, deviceId: deviceToken)
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            if (200...299).contains(respuesta.httpResponse?.statusCode ?? 0) {
                self?.userDefaults.deviceToken = nil
            } else {
                // Se solicita un token nuevo y se vuelve a intentar.
                let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                self!.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                    switch respuesta.resultado {
                        case .success(let resultado):

                            // Actualizo el token en la sesión
                            let newToken = resultado.token
                            var newsesion = self!.sesionPersistencia.getSesion()
                            newsesion?.authToken = newToken
                            self?.sesionPersistencia.guardar(sesion: newsesion!)

                            // Vuelvo a intentar el request original
                            self?.httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
                                guard let self = self else { return }
                                switch respuesta.resultado {
                                case .success(_):
                                    self.userDefaults.deviceToken = nil
                                case .failure(_):
                                    self.userDefaults.deviceToken = nil
                                }
                            }
                    case .failure(_):
                        self?.userDefaults.deviceToken = nil
                    }
                }
            }
        }
    }
    
    private func pedirAcceso() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .alert]) { [weak self] (otorgado, error) in
            self?.registrarParaNotificationesRemotas()
        }
    }
    
    private func registrarParaNotificationesRemotas() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
}

extension NotificacionFachada: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "pushNotification"), object: nil)
        completionHandler([.alert, .badge, .sound])
    }
    
    
}


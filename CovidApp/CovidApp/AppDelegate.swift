//
//  AppDelegate.swift
//  CovidApp
//
//  Created on 6/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var notificationFachada: NotificacionFachadaProtocolo = inyectar()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        #if NEWRELIC
            if appVersion != nil {
                NewRelic.setApplicationVersion(appVersion!)
            }
            if appBuild != nil{
                NewRelic.setApplicationBuild(appBuild!)
            }
            
            NewRelic.start(withApplicationToken: Obfuscator().reveal(key: Keys.API_KEY))
            if #available(iOS 13, *) {
                return true
            }
        #endif
        
        let window = UIWindow()
        window.configurarControladorRaiz()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        notificationFachada.registrarDispositivoEnElServivor(deviceId: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
}


extension UIWindow {
    func configurarControladorRaiz() {
        self.rootViewController = CoordinadorDeVistas.instancia.rootViewController
    }
}

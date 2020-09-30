//
//  CoordinadorDeVistas.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinadorDeVistaProtocolo: class {
    func irASplash()
    func irALegal()
    func irAAutoevaluacion()
    func irAPasaporteSanitario()
    func irAEscaner(delegado: EscannerDelegado)
    func irAAutenticacion()
    func irAResultado(modo: ResultadoModoPresentacion)
    func irAResultadoOnboarding()
    func irAForceUpgrade()
    func irANewLegal()
    func irA(url: URL)
    func presentarAResultado(modo: ResultadoModoPresentacion)
    func irAConfiguracionDeAPP()
    func irATelefonoContacto()
    func irAInformacionPBA()
    func irAConsejos()
}

protocol Enrutador {
    func terminosYCondicionesIniciar()
    func terminosYCondicionesAceptados()
    func nuevosTerminosYCondicionesAceptados()
    func autenticacionTerminada()
    func autoevaluacionTerminada()
    func resultadoTerminado()
    func nuevoAutodiagnostico()
    func continuarEtapaPostRegistro()
    func habilitarCirculacion()
    func desvinculaciónTerminada()
    func masInformacionPasaporte()
    func edicionDatosPersonales()
    func telefonoContactoConfirmado()
    func informacionPBA()
    func consejos()
    func volverAPasaporte()
}

final class CoordinadorDeVistas: MVPVista {
    typealias Presentador = CoordinadorPresentadorProtocolo
    static let instancia: CoordinadorDeVistas = {
        let presentador = CoordinadorPresentador()
        let coordinador = CoordinadorDeVistas(presentador: presentador)
        
        presentador.vista = coordinador
        return coordinador
    }()
    let presentador: CoordinadorPresentadorProtocolo
    let rootNavigationController: UINavigationController = .init()
    lazy var application: UIApplicationProtocol = self.inyectar()
    
    init(presentador: CoordinadorPresentadorProtocolo) {
        self.presentador = presentador
    }
}

// MARK: Metodos Publicos

extension CoordinadorDeVistas {
    var rootViewController: UIViewController {
        if rootNavigationController.topViewController == nil {
            presentador.manejarInicioDeLaApp()
        }
        rootNavigationController.isNavigationBarHidden = true
        return rootNavigationController
    }
}

extension CoordinadorDeVistas: Enrutador {
    func consejos() {
        presentador.manejarConsejos()
    }
    
    func nuevosTerminosYCondicionesAceptados() {
        presentador.manejarNuevosTerminosYCondicionesAceptados()
    }
    
    func telefonoContactoConfirmado() {
        presentador.manejarTelefonoContactoConfirmado()
    }
    
    func edicionDatosPersonales() {
        presentador.manejarEdicionDatosPersonales()
    }
    
    func desvinculaciónTerminada() {
        presentador.manejarInicioDeLaApp()
    }
    
    func autenticacionTerminada() {
        presentador.manejarAutenticacionCompletada()
    }
    
    func terminosYCondicionesIniciar() {
        presentador.manejarAbrirTerminosYCondiciones()
    }
    
    func terminosYCondicionesAceptados() {
        presentador.manejarTerminosYCondicionesAceptado()
    }
    
    func autoevaluacionTerminada() {
        presentador.manejarAutoevaluacionCompletada()
    }
    
    func resultadoTerminado() {
        presentador.manejarResultadoTerminado()
    }
    
    func nuevoAutodiagnostico() {
        presentador.manejarNuevoAutodiagnostico()
    }
    
    func continuarEtapaPostRegistro() {
        presentador.manejarEtapaPostRegistro()
    }
    
    func habilitarCirculacion() {
        presentador.manejarHabilitarCirculacion()
    }
    
    func masInformacionPasaporte() {
        presentador.manejarMasInformacion()
    }
    
    func informacionPBA() {
        presentador.manejarInformacionPBA()
    }
    func volverAPasaporte() {
        presentador.manejarVolverAPasaporte()
    }
    func irA(url:URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

// MARK: Conformacia de CoordinadorDeVistaProtocolo

extension CoordinadorDeVistas: CoordinadorDeVistaProtocolo {
    func irAConsejos() {
        let consejos = ConsejosViewController()
        consejos.modalPresentationStyle = .fullScreen
        presentar(controlador: consejos)
    }
    
    func irATelefonoContacto() {
        irA(controlador: TelefonoContactoViewController())
    }
    
    func irASplash() {
        irA(controlador: SplashViewController())
    }
    
    func irAEscaner(delegado: EscannerDelegado) {
        let escannerViewController = EscanerViewController()
        escannerViewController.delegate = delegado
        rootViewController.present(escannerViewController, animated: true, completion: nil)
    }
    
    func irAAutenticacion() {
        irA(controlador: AutenticacionNavegacionViewController())
    }
    
    func irAPasaporteSanitario() {
        irA(controlador: PasaporteViewController())
    }
    
    func irAAutoevaluacion() {
        irA(controlador: AutoevaluacionViewController())
    }
    
    func irAInformacionPBA() {
        irA(controlador: InformacionPBAViewController())
    }
    
    func irALegal() {
        irA(controlador: LegalViewController())
    }
    
    func irANewLegal() {
        irA(controlador: NewLegalViewController())
    }
    
    func irPasaporte() {
        irA(controlador: PasaporteViewController())
    }
    
    func irAResultado(modo: ResultadoModoPresentacion) {
        let resultado = ResultadoViewController()
        resultado.presentador.modoPresentacion = modo
        irA(controlador: resultado)
    }
    
    func irAResultadoOnboarding() {
        let informacion = InformacionViewController()
        informacion.presentador.modoPresentacion = .success(())
        irA(controlador: informacion)
    }
    
    func irAForceUpgrade() {
        let informacion = InformacionViewController()
        informacion.presentador.modoPresentacion = .failure(.necesitaUpgrade)
        informacion.accionReintentar = { [weak self] in
            self?.presentador.manejarAppUpgrade()
        }
        irA(controlador: informacion)
    }
    
    func presentarAResultado(modo: ResultadoModoPresentacion) {
        let resultado = ResultadoViewController()
        resultado.presentador.modoPresentacion = modo
        resultado.modalPresentationStyle = .fullScreen
        presentar(controlador: resultado)
    }
    
    func irAConfiguracionDeAPP() {
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: Metodos Privados

private extension CoordinadorDeVistas {
    func irA(controlador: UIViewController) {
        rootNavigationController.pushViewController(controlador, animated: rootNavigationController.topViewController != nil)
    }
    
    func presentar(controlador: UIViewController) {
        rootNavigationController.topViewController?.present(
            controlador,
            animated: true,
            completion: nil)
    }
}

// MARK: MVPVista

extension MVPVista {
    func inyectar() -> Enrutador {
        return CoordinadorDeVistas.instancia
    }
}

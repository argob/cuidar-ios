//
//  CoordinadorPresentador.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol CoordinadorPresentadorProtocolo {
    func manejarInicioDeLaApp()
    func manejarAbrirTerminosYCondiciones()
    func manejarTerminosYCondicionesAceptado()
    func manejarNuevosTerminosYCondicionesAceptados()
    func manejarAutenticacionCompletada()
    func manejarAutoevaluacionCompletada()
    func manejarResultadoTerminado()
    func manejarNuevoAutodiagnostico()
    func manejarEtapaPostRegistro()
    func manejarHabilitarCirculacion()
    func manejarMasInformacion()
    func manejarAppUpgrade()
    func manejarEdicionDatosPersonales()
    func manejarTelefonoContactoConfirmado()
    func manejarVolverAPasaporte()
    func manejarInformacionPBA()
    func manejarConsejos()
}

final class CoordinadorPresentador: MVPPresentador {
    private static let haAbiertoLaAppAntesKey = "com.covidapp.haAbiertoLaAppAntesKey"

    weak var vista: CoordinadorDeVistaProtocolo?
    private let usuarioFachada: UsuarioFachadaProtocolo
    private let appConfiguracionFachada: AppConfiguracionFachadaProtocolo
    private let userDefaults: UserDefaults
    
    init(usuarioFachada: UsuarioFachadaProtocolo = inyectar(),
         appConfiguracionFachada: AppConfiguracionFachadaProtocolo = inyectar(),
         userDefaults: UserDefaults = .standard)
    {
        self.appConfiguracionFachada = appConfiguracionFachada
        self.usuarioFachada = usuarioFachada
        self.userDefaults = userDefaults
    }
}

extension CoordinadorPresentador: CoordinadorPresentadorProtocolo {
    func manejarNuevosTerminosYCondicionesAceptados() {
        actualizarTerminosYCondiciones {
            self.continuarInicioDelaApp()
        }
    }
    
    func manejarConsejos() {
        vista?.irAConsejos()
    }
    
    func manejarEdicionDatosPersonales() {
        vista?.irAAutenticacion()
    }
    
    func manejarTelefonoContactoConfirmado() {
        vista?.irAResultado(modo: .autoevaluacion)
    }
    
    func manejarInicioDeLaApp() {
        self.vista?.irASplash()
        manejarForceUpgrade { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.continuarInicioDelaApp()
            }
            
        }
    }
    
    func continuarInicioDelaApp() {
        
        verificarPrimerAperturaDeLaApp()
        guard let sesion = usuarioFachada.obtenerUltimaSession() else {
            self.vista?.irAAutenticacion()
            return
        }
        verificarTerminosYCondiciones {
            let informacionDeUsuario = sesion.informacionDeUsuario

            if !(informacionDeUsuario?.terminoRegistro ?? false) {
                self.usuarioFachada.logout()
                self.vista?.irAAutenticacion()
            } else if informacionDeUsuario?.ultimoEstado.diagnostico != .debeAutodiagnosticarse {
                self.vista?.irAPasaporteSanitario()
            } else {
                self.vista?.irAAutoevaluacion()
            }
        }
    }
    
    func manejarAbrirTerminosYCondiciones() {
        vista?.irALegal()
    }
    
    func manejarTerminosYCondicionesAceptado() {
        continuarInicioDelaApp()
    }
    
    func manejarAutenticacionCompletada() {
        guard
            let informacionDeUsuario = usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario,
            informacionDeUsuario.terminoRegistro
        else {
            return
        }
        
        if informacionDeUsuario.ultimoEstado.diagnostico != .debeAutodiagnosticarse {
            self.vista?.irAPasaporteSanitario()
        } else {
            vista?.irAResultadoOnboarding()
        }
    }
    
    func manejarAutoevaluacionCompletada() {
        let ultimoEstado = self.usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario?.ultimoEstado.diagnostico
        
        if (ultimoEstado == Estado.Diagnostico.derivadoASaludLocal) {
            // Si está derivado a salud verificamos que tengamos el tel
            // de contacto correcto.
            vista?.irATelefonoContacto()
        } else {
            vista?.irAResultado(modo: .autoevaluacion)
        }
        
    }
    
    func manejarResultadoTerminado() {
        vista?.irAPasaporteSanitario()
    }
    
    func manejarNuevoAutodiagnostico() {
        vista?.irAAutoevaluacion()
    }
    
    func manejarEtapaPostRegistro() {
        guard
            let informacionDeUsuario = usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario,
            informacionDeUsuario.terminoRegistro
        else {
            return
        }
        
        if informacionDeUsuario.ultimoEstado.diagnostico != .debeAutodiagnosticarse {
            self.vista?.irAPasaporteSanitario()
        } else {
            self.vista?.irAAutoevaluacion()
        }
    }
    
    func manejarHabilitarCirculacion() {
        guard let url = URL(string: "https://www.argentina.gob.ar/solicitar-certificado-unico-habilitante-para-circulacion-emergencia-covid-19")
        else {
            return
        }
        vista?.irA(url: url)
    }
    
    func manejarMasInformacion() {
        vista?.presentarAResultado(modo: .actualizar)
    }
    
    func manejarInformacionPBA() {
        vista?.irAInformacionPBA()
    }
    
    func manejarVolverAPasaporte() {
        vista?.irAPasaporteSanitario()
    }
    func manejarAppUpgrade() {
        guard let url = URL(string: "https://apps.apple.com/ar/app/covid-19-ministerio-de-salud/id1503956284")
        else {
            return
        }
        vista?.irA(url: url)
    }
}

private extension CoordinadorPresentador {
    func manejarForceUpgrade(continuar: @escaping () -> Void) {
        appConfiguracionFachada.validarSiLaAppNecesitaUpgrade { [weak self] (necesitaUpgrade) in
            guard necesitaUpgrade else {
                continuar()
                return
            }
            self?.vista?.irAForceUpgrade()
        }
    }
    
    func verificarPrimerAperturaDeLaApp() {
        guard !userDefaults.bool(forKey: type(of: self).haAbiertoLaAppAntesKey) else {
            return
        }
        userDefaults.set(true, forKey: type(of: self).haAbiertoLaAppAntesKey)
        usuarioFachada.logout()
    }
    
    func verificarTerminosYCondiciones(continuar: @escaping () -> Void) {
        appConfiguracionFachada.validarSiLaAppNecesitaTerminosYCondiciones { [weak self] (necesitaAceptar) in

            if necesitaAceptar {
                self?.vista?.irANewLegal()
            } else {
                continuar()
                return
            }
        }
    }
    
    func actualizarTerminosYCondiciones(continuar: @escaping () -> Void) {
        appConfiguracionFachada.actualizarTerminosYCondiciones { (aceptados) in

            continuar()
            return
        
        }
    }
}

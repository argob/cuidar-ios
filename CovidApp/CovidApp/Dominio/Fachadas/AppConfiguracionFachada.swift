//
//  AppConfiguracionFachada.swift
//  CovidApp
//
//  Created on 20/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol AppConfiguracionFachadaProtocolo {
    func validarSiLaAppNecesitaUpgrade(finalizacion: @escaping (_ necesitaUpgrade: Bool) -> Void)
    func validarSiLaAppNecesitaTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void)
    func actualizarTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void)
}

extension MVPPresentador {
    static func inyectar() -> AppConfiguracionFachadaProtocolo {
        if DominioFachadaDebugging.mockFachadas {
            return MockAppConfiguracionFachada.instancia
        }
        return AppConfiguracionFachada.instancia
    }
}

private final class MockAppConfiguracionFachada: AppConfiguracionFachadaProtocolo {
    func actualizarTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void) {
        finalizacion(true)
    }
    
    
    static let instancia = MockAppConfiguracionFachada()
    
    func validarSiLaAppNecesitaUpgrade(finalizacion: (Bool) -> Void) {
        finalizacion(false)
    }
    
    func validarSiLaAppNecesitaTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void) {
        finalizacion(false)
    }
}

private final class AppConfiguracionFachada: DominioFachada {
    static let instancia = AppConfiguracionFachada()
    private let httpCliente: HTTPCliente
    private let sesionPersistencia: SesionPersistencia
    
    private init(httpCliente: HTTPCliente = inyectar(), sesionPersistencia:SesionPersistencia = inyectar()) {
        self.httpCliente = httpCliente
        self.sesionPersistencia = sesionPersistencia
    }
}

extension AppConfiguracionFachada: AppConfiguracionFachadaProtocolo {
    func validarSiLaAppNecesitaUpgrade(finalizacion: @escaping (Bool) -> Void) {
        let solicitud = ObtenerVersion()
        let finalizacionEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        
        httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
            finalizacionEnElMainThread(respuesta.httpResponse?.statusCode == 426)
        }
    }
    
    func validarSiLaAppNecesitaTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void){
        
        let finalizacionEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        
        guard let sesion = sesionPersistencia.getSesion() else {
            finalizacionEnElMainThread(false)
            return
        }
        
        let solicitud = ObtenerTerminosYCondiciones(encabezados: ["Cov-UserDNI":"\(sesion.dni)","Cov-UserSexo":"\(sesion.sexo.get())"])
        
        httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
            switch respuesta.resultado {
            case .success(let resultado):
                UserDefaults.standard.set(resultado.delta, forKey: Constantes.LEGAL_DELTA)
                UserDefaults.standard.set(resultado.ultimoDisponible, forKey: Constantes.LEGAL_VERSION)
                finalizacionEnElMainThread(resultado.ultimoDisponible != resultado.ultimoAceptado)
            case .failure(let error):
                switch error {
                case .tokenInvalido:
                    //  Se solicita un token nuevo y se vuelve a intentar
                    
                    let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                    self.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                        switch respuesta.resultado {
                        case .success(let resultado):
                            //   Actualizo el token en la sesión
                            
                            let newToken = resultado.token
                            var newsesion = self.sesionPersistencia.getSesion()
                            newsesion!.authToken = newToken
                            self.sesionPersistencia.guardar(sesion: newsesion!)
                            
                            //   Vuelvo a intentar el request original
                            self.httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
                                switch respuesta.resultado {
                                case .success(let resultado):
                                    UserDefaults.standard.set(resultado.delta, forKey: Constantes.LEGAL_DELTA)
                                    UserDefaults.standard.set(resultado.ultimoDisponible, forKey: Constantes.LEGAL_VERSION)
                                    finalizacionEnElMainThread(resultado.ultimoDisponible != resultado.ultimoAceptado)
                                case .failure(_):
                                    finalizacionEnElMainThread(false)
                                }
                            }
                        case .failure(_):
                            finalizacionEnElMainThread(false)
                        }
                    }
                default:
                    finalizacionEnElMainThread(false)
                }
            }
        }
    }
    
    func actualizarTerminosYCondiciones(finalizacion: @escaping (Bool) -> Void){

        let finalizacionEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)

        guard let sesion = sesionPersistencia.getSesion(),
              let version = UserDefaults.standard.value(forKey: Constantes.LEGAL_VERSION) as? Int else {
            finalizacionEnElMainThread(false)
            return
        }
        
        let solicitud = AceptarTerminosYCondiciones(version: version, encabezados: ["Cov-UserDNI":"\(sesion.dni)","Cov-UserSexo":"\(sesion.sexo.get())"])
                
        httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
            switch respuesta.resultado {
            case .success(_):
                finalizacionEnElMainThread(respuesta.httpResponse?.statusCode == 200)
            case .failure(let error):
                switch error {
                case .tokenInvalido:
                    //  Se solicita un token nuevo y se vuelve a intentar
                    
                    let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                    self.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                        switch respuesta.resultado {
                        case .success(let resultado):
                            //   Actualizo el token en la sesión
                            
                            let newToken = resultado.token
                            var newsesion = self.sesionPersistencia.getSesion()
                            newsesion!.authToken = newToken
                            self.sesionPersistencia.guardar(sesion: newsesion!)
                            
                            //   Vuelvo a intentar el request original
                            self.httpCliente.ejecutar(solicitud: solicitud) { (respuesta) in
                                switch respuesta.resultado {
                                case .success(_):
                                    finalizacionEnElMainThread(respuesta.httpResponse?.statusCode == 200)
                                case .failure(_):
                                    finalizacionEnElMainThread(false)
                                }
                            }
                        case .failure(_):
                            finalizacionEnElMainThread(false)
                        }
                    }
                default:
                    finalizacionEnElMainThread(false)
                }
            }
        }
    }
    
}

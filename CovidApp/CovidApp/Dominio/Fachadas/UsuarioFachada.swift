//
//  UsuarioFachada.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

enum EstadoDelRegistro {
    case usuarioYaRegistrado(usuario: Usuario)
    case habilitadoParaSerRegistrado(usuario: Usuario)
    case invalido
}

protocol UsuarioFachadaProtocolo {
    func obtenerUltimaSession() -> Sesion?
    func actualizarInformacionDeUsuario(finalizacion: @escaping (Sesion) -> Void)
    func registrarUsuario(domicilio: Domicilio, telefono: String, finalizacion: @escaping (Bool) -> Void)
    func validarRegistro(dni: Int, noTramite: Int, sexo: Usuario.Sexo, finalizacion: @escaping (EstadoDelRegistro) -> Void)
    func logout()
}

extension MVPPresentador {
    static func inyectar() -> UsuarioFachadaProtocolo {
        if DominioFachadaDebugging.mockFachadas {
            return MockUsuarioFachada.instancia
        }
        return UsuarioFachada.instancia
    }
}

private final class MockUsuarioFachada: UsuarioFachadaProtocolo {
    static let instancia = MockUsuarioFachada()
    var ultimaSession: Sesion?
    
    func logout() {
        ultimaSession = nil
    }
    
    func obtenerUltimaSession() -> Sesion? {
        return ultimaSession
    }
    
    func actualizarInformacionDeUsuario(finalizacion: @escaping (Sesion) -> Void) {
        guard let ultimaSession = obtenerUltimaSession() else {
            fatalError("Esta funcion debe llamarse despues de registrar el usuario")
        }
        finalizacion(ultimaSession)
    }
    
    func registrarUsuario(domicilio: Domicilio, telefono: String, finalizacion: @escaping (Bool) -> Void) {
        ultimaSession?.informacionDeUsuario?.terminoRegistro = true
        finalizacion(true)
    }
    
    func validarRegistro(dni: Int, noTramite: Int, sexo: Usuario.Sexo, finalizacion: @escaping (EstadoDelRegistro) -> Void) {
        
        let mockUserMultipleCertificados = Usuario(dni: dni,
                                      sexo: sexo,
                                      fechaDeNacimiento: "01/01/1111",
                                      nombres: "Mock Name",
                                      apellidos: "Mock Apellido",
                                      estadoActual: .init(diagnostico: .noInfectado,
                                                           vencimiento: "2020-11-03T10:05:59.5646+08:00",
                                                           permisoDeCirculacion: Estado.PermisoDeCirculacion(tipoActividad: "Actividades Esenciales",
                                                           patente: "AS-123-BC", sube: "1234567890123456"),
                                                           permisosDeCirculacion: [Estado.PermisoDeCirculacion( vencimiento: "2020-11-23T19:05:03.524-03:00", tipoActividad: "ESENCIAL",motivoCirculacion: "Turismo 1",idCertificado: 618954904, patente: "AAA111", sube: "111333322222333"),Estado.PermisoDeCirculacion( vencimiento: "2020-11-23T19:05:03.524-03:00", tipoActividad: "MEDICO",motivoCirculacion: "Turismo",idCertificado: 618954902, patente: "AAA222", sube: "222444411111222"),Estado.PermisoDeCirculacion( vencimiento: "2020-11-23T19:05:03.524-03:00", tipoActividad: "ESENCIAL -TRANSPORTE SI",motivoCirculacion: "Medicina",idCertificado: 618954905, patente: "AAA111", sube: "111333322222333"),Estado.PermisoDeCirculacion( vencimiento: "2020-11-23T19:05:03.524-03:00", tipoActividad: "MEDICO - SIN TRANSPORTE",motivoCirculacion: "Autoridades superiores de los gobiernos nacional, provinciales, municipales y de la Ciudad Autónoma de Buenos Aires Trabajadores y trabajadoras del sector público nacional, provincial, municipal y de la Ciudad Autónoma de Buenos Aires, convocados para garantizar actividades esenciales requeridas por las respectivas autoridades",idCertificado: 618954906, patente: "AAA222", sube: "222444411111222",qrURL: "http://www.google.com")],
                                                           pims: Estado.Pims(tag: "Repatriado", motivo: "Motivo ejemplo")),
                                      telefono: "1223 13288",
                                      domicilio: Domicilio(provincia: "Buenos Aires", localidad: "Boca", departamento: "", calle: "Principal", numero: "123", piso: "1", puerta: "12", codigoPostal: "1234", otros: ""))
        self.ultimaSession = Sesion(dni: dni,
                                    sexo: .mujer,
                                    authToken: "570b7dc924f50783d7c93308898122f8f4c57b462d4a61f18d8157a7f06bc8f4",
                                    hash: "3123123jk12h31kj2",
                                    authRefreshToken: "570b7dc924f50783d7c93308898122f8f4c57b462d4a61f18d8157a7f0612313",
                                    informacionDeUsuario: .init(usuario: mockUserMultipleCertificados))
        finalizacion(.habilitadoParaSerRegistrado(usuario: mockUserMultipleCertificados))
    }
}

private final class UsuarioFachada: DominioFachada {
    static let instancia = UsuarioFachada()
    private let httpCliente: HTTPCliente
    private let sesionPersistencia: SesionPersistencia
    
    private init(httpCliente: HTTPCliente = inyectar(),
                 sesionPersistencia: SesionPersistencia = inyectar()) {
        self.httpCliente = httpCliente
        self.sesionPersistencia = sesionPersistencia
    }
}

extension UsuarioFachada: UsuarioFachadaProtocolo {
    func logout() {
        sesionPersistencia.borrar()
    }
    
    func obtenerUltimaSession() -> Sesion? {
        return sesionPersistencia.getSesion()
    }
    
    func actualizarInformacionDeUsuario(finalizacion: @escaping (Sesion) -> Void) {
        guard let sesion = sesionPersistencia.getSesion() else {
            assertionFailure("Esto no se deberia llamar hasta que el usuario se haya registrado")
            return
        }
        let finalizarEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        let solicitud = VerificarUsuario(dni: sesion.dni, sexo: sesion.sexo)
        
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            guard let self = self else { return }
            switch respuesta.resultado {
            case .success(let usuario):
                let nuevaSesion = sesion.actualizarConUsuario(usuario)
                self.sesionPersistencia.guardar(sesion: nuevaSesion)
                finalizarEnElMainThread(nuevaSesion)
            case .failure(let error):
                switch error {
                case .tokenInvalido:
//                  Se solicita un token nuevo y se vuelve a intentar
                    
                    let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                    self.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                        switch respuesta.resultado {
                            case .success(let resultado):
//                              Actualizo el token en la sesión

                                let newToken = resultado.token
                                var newsesion = self.sesionPersistencia.getSesion()
                                newsesion!.authToken = newToken
                                self.sesionPersistencia.guardar(sesion: newsesion!)
//                             Vuelvo a intentar el request original

                                self.httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
                                    guard let self = self else { return }
                                    switch respuesta.resultado {
                                    case .success(let usuario):
                                        let nuevaSesion = newsesion!.actualizarConUsuario(usuario)
                                        self.sesionPersistencia.guardar(sesion: nuevaSesion)
                                        finalizarEnElMainThread(nuevaSesion)
                                    case .failure(_):
                                        finalizarEnElMainThread(newsesion!)
                                    }
                                }
                        case .failure(let error):
                            switch error {
                            case .tokenInvalido:
                                // Este flag se usa para levantar la alerta de otro dispositivo conectado.
                                UserDefaults.standard.set(true, forKey: Constantes.INVALID_TOKEN)
                                self.logout()
                                finalizarEnElMainThread(sesion)
                            default:
                                finalizarEnElMainThread(sesion)
                            }
                        }
                    }
                default:
                    finalizarEnElMainThread(sesion)
                }
            }
        }
    }
    
    func registrarUsuario(domicilio: Domicilio,
                          telefono: String,
                          finalizacion: @escaping (Bool) -> Void) {
        guard let sesion = sesionPersistencia.getSesion() else {
            finalizacion(false)
            return
        }
        let finalizarEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        let solicitud = RegistrarUsuario(
            dni: sesion.dni,
            sexo: sesion.sexo,
            cuerpo: .init(telefono: telefono, domicilio: domicilio)
        )
        
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            guard let self = self else { return }
            switch respuesta.resultado {
            case .success(let usuario):
                self.sesionPersistencia.guardar(sesion: sesion.actualizarConUsuario(usuario))
                finalizarEnElMainThread(true)
            case .failure(let error):
                switch error {
                case .tokenInvalido:
//                  Se solicita un token nuevo y se vuelve a intentar
                    
                    let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                    self.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                       switch respuesta.resultado {
                           case .success(let resultado):
//                             Actualizo el token en la sesión

                               let newToken = resultado.token
                               var newsesion = self.sesionPersistencia.getSesion()
                               newsesion!.authToken = newToken
                               self.sesionPersistencia.guardar(sesion: newsesion!)
//                             Vuelvo a intentar el request original

                               self.httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
                                   guard let self = self else { return }
                                   switch respuesta.resultado {
                                   case .success(let usuario):
                                       self.sesionPersistencia.guardar(sesion: sesion.actualizarConUsuario(usuario))
                                       finalizarEnElMainThread(true)
                                   case .failure(_):
                                       finalizarEnElMainThread(false)
                                   }
                               }
                       case .failure(let error):
                            switch error {
                            case .tokenInvalido:
                                // Este flag se usa para levantar la alerta de otro dispositivo conectado.
                                UserDefaults.standard.set(true, forKey: Constantes.INVALID_TOKEN)
                                self.logout()
                                finalizarEnElMainThread(false)
                            default:
                                finalizarEnElMainThread(false)
                            }
                       }
                    }
                default:
                    finalizarEnElMainThread(false)
                }
            }
        }
    }
    
    func validarRegistro(dni: Int, noTramite: Int, sexo: Usuario.Sexo, finalizacion: @escaping (EstadoDelRegistro) -> Void) {
        let solicitud = VerificarUsuario(dni: dni, sexo: sexo)
        let finalizarEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        
        generarToken(dni: dni, noTramite: noTramite, sexo: sexo) { [weak self] (token) in
            guard let self = self, token != nil else {
                finalizarEnElMainThread(.invalido)
                return
            }
            self.httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
                guard
                    let self = self,
                    let sesion = self.sesionPersistencia.getSesion()
                else {
                    finalizarEnElMainThread(.invalido)
                    return
                }
                switch respuesta.resultado {
                case .success(let usuario) where usuario.domicilio == nil:
                    self.sesionPersistencia.guardar(sesion: sesion.actualizarConUsuario(usuario))
                    finalizarEnElMainThread(.habilitadoParaSerRegistrado(usuario: usuario))
                case .success(let usuario):
                    self.sesionPersistencia.guardar(sesion: sesion.actualizarConUsuario(usuario))
                    finalizarEnElMainThread(.usuarioYaRegistrado(usuario: usuario))
                case .failure:
                    self.sesionPersistencia.borrar()
                    finalizarEnElMainThread(.invalido)
                }
            }
        }
    }
}

private extension UsuarioFachada {
    func generarToken(dni: Int, noTramite: Int, sexo: Usuario.Sexo, finalizacion: @escaping (_ token: String?) -> Void) {
        let solicitud = GenerarToken(dni: dni, sexo: sexo, tramite: noTramite)
        
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            guard let self = self else { return }
            switch respuesta.resultado {
            case .success(let data):
                let session = Sesion(dni: dni, sexo: sexo, authToken: data.token, hash:solicitud.cuerpo?.hash ?? "",  authRefreshToken: data.refresh_token, informacionDeUsuario: nil)
                self.sesionPersistencia.guardar(sesion: session)
                finalizacion(data.token)
            case .failure:
                finalizacion(nil)
            }
        }
    }
}

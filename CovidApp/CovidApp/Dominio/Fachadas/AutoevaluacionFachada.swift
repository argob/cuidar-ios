//
//  AutoevaluacionFachada.swift
//  CovidApp
//
//  Created on 7/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

struct AutoevaluacionIndicadores {
    var temperatura: Double
}

enum AutoevaluacionConsejos: String, CaseIterable {
    case first
    case second
    case third
    case fourth
}

typealias EstadoFinalizacionDeAutoevaluacion = Result<Void, FinalizacionDeAutoevaluacionError>

enum FinalizacionDeAutoevaluacionError: Error {
    case sinConexionAInternet
    case datosInvalidos
    case tokenInvalido
    case otro
}

protocol AutoevaluacionFachadaProtocolo {
    func listarSintomas(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void)
    func listarAntecedentes(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void)
    func listarConsejosTemperatura(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void)
    
    func agregarAutoevaluacion(indicadores: AutoevaluacionIndicadores)
    func agregarAutoevaluacion(sintomas: [ItemAutoevaluado])
    func agregarAutoevaluacion(antecedentes: [ItemAutoevaluado])
    func tieneSintomasCompatibles() -> Bool
    func agregarUbicacion(_ ubicacion: GeoLocalizacion)
    func terminarAutoevaluacion(_ finalizacion: @escaping (EstadoFinalizacionDeAutoevaluacion) -> Void)
}

extension MVPPresentador {
    static func inyectar() -> AutoevaluacionFachadaProtocolo {
        if DominioFachadaDebugging.mockFachadas {
            return MockAutoevaluacionFachada()
        }
        return AutoevaluacionFachada.instancia
    }
}

extension AutoevaluacionFachadaProtocolo {
    func listarSintomas(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void) {
        finalizacion(ItemAutoevaluable.sintomas)
    }
    
    func listarAntecedentes(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void) {
        finalizacion(ItemAutoevaluable.antecedentes)
    }
    
    func listarConsejosTemperatura(_ finalizacion: @escaping ([ItemAutoevaluable]) -> Void) {
        let consejos = AutoevaluacionConsejos.allCases.map {
            ItemAutoevaluable(id: $0.rawValue, descripcion: $0.descripcionParaElUsuario)
        }
        finalizacion(consejos)
    }
}

private final class MockAutoevaluacionFachada: AutoevaluacionFachadaProtocolo {
    func agregarUbicacion(_ ubicacion: GeoLocalizacion) {
        
    }
    
    func tieneSintomasCompatibles() -> Bool {
        return false
    }
    
    func agregarAutoevaluacion(indicadores: AutoevaluacionIndicadores) {
    }
    
    func agregarAutoevaluacion(sintomas: [ItemAutoevaluado]) {
    }
    
    func agregarAutoevaluacion(antecedentes: [ItemAutoevaluado]) {
    }
    
    func terminarAutoevaluacion(_ finalizacion: @escaping (EstadoFinalizacionDeAutoevaluacion) -> Void) {
        finalizacion(.success(()))
    }
}

private final class AutoevaluacionFachada: DominioFachada {
    fileprivate static let instancia = AutoevaluacionFachada()
    
    private let httpCliente: HTTPCliente
    private let sesionPersistencia: SesionPersistencia
    
    private var indicadores: AutoevaluacionIndicadores?
    private var sintomas: [ItemAutoevaluado] = []
    private var antecedentes: [ItemAutoevaluado] = []
    private var ubicacion: GeoLocalizacion?
    
    private init(httpCliente: HTTPCliente = inyectar(),
                 sesionPersistencia: SesionPersistencia = inyectar()) {
        self.httpCliente = httpCliente
        self.sesionPersistencia = sesionPersistencia
    }
}

extension AutoevaluacionFachada: AutoevaluacionFachadaProtocolo {
    func agregarUbicacion(_ ubicacion: GeoLocalizacion) {
        self.ubicacion = ubicacion
    }
    
    func tieneSintomasCompatibles() -> Bool {
        // Basado en la definición de caso al 10/06/2020.
        // https://www.argentina.gob.ar/salud/coronavirus-COVID-19/definicion-de-caso
        guard
            let perdidaDeGusto = sintomas.first(where: { $0.id == "S_PDG" })?.getValor(),
            let perdidaDeOlfato = sintomas.first(where: { $0.id == "S_PDO" })?.getValor(),
            let dificultadRespiratoria = sintomas.first(where: { $0.id == "S_DRE" })?.getValor(),
            let dolorGarganta = sintomas.first(where: { $0.id == "S_DDG" })?.getValor(),
            let tos = sintomas.first(where: { $0.id == "S_TOS" })?.getValor(),
            let temperatura = indicadores?.temperatura,
            let viveOTrabajaConPositivo = antecedentes.first(where: {$0.id == "A_CE1"})?.getValor(),
            let contactoEstrechoEsporadico = antecedentes.first(where: {$0.id == "A_CE2"})?.getValor(),
            let dolorCabeza = antecedentes.first(where: {$0.id == "S_DDC"})?.getValor(),
            let vomitos = antecedentes.first(where: {$0.id == "S_VMT"})?.getValor(),
            let diarrea = antecedentes.first(where: {$0.id == "S_DRA"})?.getValor(),
            let dolorMuscular = antecedentes.first(where: {$0.id == "S_DMS"})?.getValor()
            else {
                return false
            }
        
        // Adaptación de criterio 1 y 2 (dos síntomas).
        let dr = (dificultadRespiratoria) ? 1 : 0
        let dra = (diarrea) ? 1 : 0
        let vmt = (vomitos) ? 1 : 0
        let ddc = (dolorCabeza) ? 1 : 0
        let dg = (dolorGarganta)  ? 1 : 0
        let to = (tos)  ? 1 : 0
        let pg = (perdidaDeGusto)  ? 1 : 0
        let po = (perdidaDeOlfato)  ? 1 : 0
        let dm = (dolorMuscular)  ? 1 : 0
        let tp = (temperatura >= 37.5)  ? 1 : 0
        
        let vomitosODiarrea = dra + vmt > 1 ? 1 : 0
        
        
        // Criterio 1 (2 o más síntomas).
        let cantSintomas = to + dg + tp + dr + ddc + vomitosODiarrea + pg + po + dm
        let critUno = cantSintomas >= 2

        // Criterio 2 (contacto estrecho + 1 síntoma).
        let cantSintomasCritDos = to + dg + tp + dr
        let critDos = (cantSintomasCritDos >= 1) && (viveOTrabajaConPositivo || contactoEstrechoEsporadico)

        return critUno || critDos
    }
    
    func agregarAutoevaluacion(indicadores: AutoevaluacionIndicadores) {
        self.indicadores = indicadores
    }
    
    func agregarAutoevaluacion(sintomas: [ItemAutoevaluado]) {
        self.sintomas = sintomas
    }
    
    func agregarAutoevaluacion(antecedentes: [ItemAutoevaluado]) {
        self.antecedentes = antecedentes
    }
    
    func terminarAutoevaluacion(_ finalizacion: @escaping (EstadoFinalizacionDeAutoevaluacion) -> Void) {
        guard
            let indicadores = self.indicadores,
            let sesion = sesionPersistencia.getSesion()
            else {
                finalizacion(.failure(.datosInvalidos))
                return
        }
        let autoevaluacion = Autoevaluacion(
            temperatura: indicadores.temperatura,
            sintomas: sintomas,
            antecedentes: antecedentes,
            coordenadas: ubicacion
        )
        let solicitud = EnviarAutoevaluacion(dni: sesion.dni, sexo: sesion.sexo, autoevaluacion: autoevaluacion)
        let finalizaEnElMainThread = self.finalizarEnElMainThread(finalizacion: finalizacion)
        
        httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
            switch respuesta.resultado {
            case .success(let resultado):
                self?.sesionPersistencia.guardar(sesion: sesion.actualizarConEstado(resultado.estadoActual))
                finalizaEnElMainThread(.success(()))
            case .failure(let error):
                switch error {
                case .noHayConexionAInternet:
                    finalizaEnElMainThread(.failure(.sinConexionAInternet))
                case .tokenInvalido:
//                  Se solicita un token nuevo y se vuelve a intentar
                    
                    let refresh = RefreshToken.init(hash: sesion.hash, refreshToken: sesion.authRefreshToken)
                    self!.httpCliente.ejecutar(solicitud: refresh) { (respuesta) in
                        switch respuesta.resultado {
                            case .success(let resultado):
//                              Actualizo el token en la sesión
                                
                                let newToken = resultado.token
                                var newsesion = self!.sesionPersistencia.getSesion()
                                newsesion!.authToken = newToken
                                self!.sesionPersistencia.guardar(sesion: newsesion!)
                                
//                              Vuelvo a intentar el request original
                                self!.httpCliente.ejecutar(solicitud: solicitud) { [weak self] (respuesta) in
                                    guard let self = self else { return }
                                    switch respuesta.resultado {
                                    case .success(let res):
                                        self.sesionPersistencia.guardar(sesion: sesion.actualizarConEstado(res.estadoActual))
                                        finalizaEnElMainThread(.success(()))
                                    case .failure(_):
                                        finalizaEnElMainThread(.failure(.datosInvalidos))
                                    }
                                }
                        case .failure(_):
                            // Este flag se usa para levantar la alerta de otro dispositivo conectado.
                            UserDefaults.standard.set(true, forKey: Constantes.INVALID_TOKEN)
                            self?.sesionPersistencia.borrar()
                            finalizaEnElMainThread(.failure(.tokenInvalido))
                        }
                    }
                default:
                    finalizaEnElMainThread(.failure(.otro))
                }
            }
        }
    }
}

private extension AutoevaluacionConsejos {
    var descripcionParaElUsuario: String {
        switch self {
        case .first:
            return "Medir la temperatura siempre en el mismo lugar (oído y axila) ya que de otro modo pueden variar los valores."
        case .second:
            return "No se debe tomar la temperatura después del baño o de haber realizado una actividad física. Se debe esperar por los menos 20 minutos."
        case .third:
            return "La fiebre hay que medirla, no hay que fiarse de la percepción que se tenga al tocar la frente."
        case .fourth:
            return "Los termómetros deben ser seguros, que no se rompan."
        }
    }
}

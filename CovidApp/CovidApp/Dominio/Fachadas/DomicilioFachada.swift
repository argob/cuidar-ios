//
//  DomicilioFachada.swift
//  CovidApp
//
//  Created on 4/13/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

protocol DomicilioFachadaProtolo {
    func cargarProvincias() -> [CiudadProvincia]
    func cargarCiudadDepartamentoParaProvincia(_ nombreProvincia: String?) -> [CiudadProvincia]
    func normalizar(domicilio: Domicilio) -> Domicilio
}

extension MVPPresentador {
    static func inyectar() -> DomicilioFachadaProtolo {
        return DomicilioFachada.instancia
    }
}

private final class DomicilioFachada: DomicilioFachadaProtolo {
    
    fileprivate static let instancia = DomicilioFachada()
    
    var provincias: [Provincia]?
    var ciudades: [Ciudad]?
    
    func cargarProvincias() -> [CiudadProvincia] {
        if let url = Bundle.main.url(forAuxiliaryExecutable: Constantes.DOMICILIO_ARCHIVO_DE_PROVINCIAS) {
            do {
                let datos = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let datosProvincias = try decoder.decode(DatosProvincias.self, from: datos)
                provincias = datosProvincias.provincias.sorted(by: <)
                return provincias ?? []
            } catch {
                assertionFailure("error: \(error)")
            }
        }
        return []
    }
    
    func cargarCiudadDepartamentoParaProvincia(_ nombreProvincia: String?) -> [CiudadProvincia] {
        guard let nombre = nombreProvincia, let provinciaID = obtenerIDPRovincia(nombre: nombre) else {
            return []
        }
        
        if let url = Bundle.main.url(forAuxiliaryExecutable: Constantes.DOMICILIO_ARCHIVO_DE_CIUDADES) {
            do {
                let datos = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let datosCiudades = try decoder.decode(DatosCiudades.self, from: datos)
                ciudades = datosCiudades.localidades.filter{ $0.provinciaID == provinciaID }.sorted(by: <)
                return ciudades ?? []
            } catch {
                assertionFailure("error: \(error)")
            }
        }
        return []
    }
    
    func normalizar(domicilio: Domicilio) -> Domicilio {
        var normalizado = domicilio
        let ciudadDepartamento = domicilio.localidad
        normalizado.localidad = Ciudad.extraerCiudad(nombreCiudadDepartamento: ciudadDepartamento)
        normalizado.departamento = Ciudad.extraerDepartamento(nombreCiudadDepartamento: ciudadDepartamento)
        return normalizado
    }
    
    private func obtenerIDPRovincia( nombre: String) -> String? {
        let provincia = provincias?.filter{$0.nombre.capitalized == nombre.capitalized }
        return provincia?.first?.id
    }
}


//
//  UbicacionFachada.swift
//  CovidApp
//
//  Created on 4/19/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import CoreLocation

protocol UbicacionFachadaProtocolo {
    func obtenerUbicacion()
    func solicitarPermisos()
    var delegado: UbicacionFachadaDelegado? { get set }
}

protocol UbicacionFachadaDelegado: class {
    func permisosOtorgados()
    func permisosDenegados()
    func ubicacionDetectada(ubicacion: GeoLocalizacion)
    func ubicacionNoDetectada()
}

extension MVPPresentador {
    static func inyectar() -> UbicacionFachadaProtocolo {
        return UbicacionFachada.instancia
    }
}

private final class UbicacionFachada: NSObject, DominioFachada {
    static let instancia = UbicacionFachada()
    weak var delegado: UbicacionFachadaDelegado?
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
}

extension UbicacionFachada: UbicacionFachadaProtocolo {
    
    func solicitarPermisos() {
        if !CLLocationManager.locationServicesEnabled() {
            delegado?.permisosDenegados()
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            delegado?.permisosOtorgados()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            delegado?.permisosDenegados()
        }
    }
    
    func obtenerUbicacion() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
}

extension UbicacionFachada: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geo = GeoLocalizacion(latitud: "\(location.coordinate.latitude)", longitud: "\(location.coordinate.longitude)")
        delegado?.ubicacionDetectada(ubicacion: geo)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        delegado?.ubicacionNoDetectada()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            delegado?.permisosOtorgados()
        } else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            delegado?.permisosDenegados()
        }
    }
}

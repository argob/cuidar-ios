//
//  InformacionPresentador.swift
//  CovidApp
//
//  Created on 4/14/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation

typealias ResultadoInformacion = Result<Void, InformacionError>

struct InformacionError: Error {
    static let errorAutenticacion = InformacionError(mensaje: "Hubo un Error!".uppercased(),
                                                     indicaciones: "Por favor volvé a intentarlo",
                                                     tituloAccion: "REINTENTAR")
    static let necesitaUpgrade = InformacionError(mensaje: "Tu aplicación está desactualizada!".uppercased(),
                                                  indicaciones: "Por favor, descargá la nueva versión desde la tienda",
                                                  tituloAccion: "ACTUALIZAR")
    
    var mensaje: String
    var indicaciones: String
    var tituloAccion: String
}

protocol InformacionPresentadorProtocolo {
    var modoPresentacion: ResultadoInformacion { get set }
    func botonContinuarSeleccionado()
}

extension MVPVista where Self: InformacionVista {
    func inyectar() -> InformacionPresentadorProtocolo  {
        let presenter = InformacionPresentador()
        presenter.vista = self
        return presenter
    }
}

final class InformacionPresentador: MVPPresentador {
    weak var vista: InformacionVista?
    
    var modoPresentacion: ResultadoInformacion = .failure(.errorAutenticacion) {
        didSet{
            switch modoPresentacion {
            case .success:
                estrategia = InformacionSuccessPresentador(vista: self.vista)
            case .failure(let error):
                estrategia = InformacionFailurePresentador(vista: self.vista, error: error)
            }
        }
    }
    
    private var estrategia: InformacionPresentadorEstrategia?
}

extension InformacionPresentador: InformacionPresentadorProtocolo {
    func escenaCargo() {
        estrategia?.configurarViewModel()
    }

    func botonContinuarSeleccionado() {
        estrategia?.botonContinuarSeleccionado()
    }
}

protocol InformacionPresentadorEstrategia {
    func configurarViewModel()
    func botonContinuarSeleccionado()
}

private final class InformacionSuccessPresentador: InformacionPresentadorEstrategia {
    weak var vista: InformacionVista?
    
    init(vista: InformacionVista?) {
        self.vista = vista
    }
    
    func configurarViewModel() {
        let factoria = InformacionFactoriaViewModels()
        vista?.configurar(viewModel: factoria.crearViewModelInformacion(para: .success(())))
    }
    
    func botonContinuarSeleccionado() {
        vista?.continuarSiguienteEtapa()
    }
}

private final class InformacionFailurePresentador: InformacionPresentadorEstrategia {
    weak var vista: InformacionVista?
    private let error: InformacionError
    
    init(vista: InformacionVista?, error: InformacionError) {
        self.vista = vista
        self.error = error
    }
    
    func configurarViewModel() {
        let factoria = InformacionFactoriaViewModels()
        vista?.configurar(viewModel: factoria.crearViewModelInformacion(para: .failure(error)))
    }
    
    func botonContinuarSeleccionado() {
        vista?.reintentar()
    }
}

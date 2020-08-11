//
//  AutenticacionNavegacionViewController.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol AutenticacionNavegacionDelegado: class, VisualizadorDeCarga {
    func siguienteEtapa()
    func ingresoManual()
    func finalAutenticacion()
    func logOut()
    
}

protocol AutenticacionNavegacionVista: class, VisualizadorDeCarga {
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func mostrarVista(modelo: EstadoDireccionNavegacion)
    func configurar(modelo: AutenticacionNavegacionViewModel)
    func autenticacionTerminada()
}

protocol AutenticacionVistaHija: class , VisualizadorDeCarga {
    var autenticacionNavegacionDelegado: AutenticacionNavegacionDelegado? { get }
}

final class AutenticacionNavegacionViewController: BaseViewController, MVPVista {
    @IBOutlet weak var barraProgresoNavegacion: NavegacionToolbar!
    @IBOutlet weak var contenedorVistas: UIView!
    
    lazy var presentador: AutenticacionNavegacionPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    let formularioDatosPersonales = FormularioDatosPersonalesViewController()
    let formularioDatosContacto = FormularioDatosDeContactoViewController()
    let escanearDniViewController = EscanearDniViewController()
    let pantallaConfirmacion = ConfirmacionViewController()
    
}

extension AutenticacionNavegacionViewController: AutenticacionNavegacionDelegado {
    func logOut() {
        enrutador.desvinculaciónTerminada()
    }
    
    func finalAutenticacion() {
        autenticacionTerminada()
    }
    
    func siguienteEtapa() {
        presentador.siguienteEtapa()
    }
    
    func ingresoManual() {
        presentador.iniciaIngresoManual()
    }
}

extension AutenticacionNavegacionViewController: AutenticacionNavegacionVista {
    func mostrarVista(modelo: EstadoDireccionNavegacion) {
        configurarVistas(direccion: modelo.direccion)
        barraProgresoNavegacion.configurar(etapa: modelo.etapa)
    }
    
    func obtener(vista: AutenticacionVistasNavegacion) -> BaseViewController? {
        switch vista {
        case .escanerDni:
            return escanearDniViewController
        case .confirmacionDni:
            return pantallaConfirmacion
        case .ingresoTelefono, .ingresoDireccion:
            return formularioDatosContacto
        case .ingresoManual:
            return formularioDatosPersonales
            
        }
    }
    
    func remover(_ vista: AutenticacionVistasNavegacion) {
        guard let vista = obtener(vista: vista) else { return }
        remover(vista: vista)
    }
    
    func agregar(_ vista: AutenticacionVistasNavegacion) {
        guard let vista = obtener(vista: vista) else { return }
        agregar(vista, vistaContenedor: contenedorVistas)
    }
    
    func configurarVistas(direccion: DireccionNavegacion) {
        barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: true)
        switch direccion {
        case let .siguiente(vista) where vista == .escanerDni || vista == .confirmacionDni:
            barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: false)
            fallthrough
        case let .siguiente(vista):
            barraNavegacionPersonalizada.modoVisible = true
            if vista == .ingresoTelefono && presentador.obtenerEtapaInicial() == .ingresoTelefono {
                barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: false)
            }
            agregar(vista)
        case let .anterior(vista) where vista == .escanerDni:
            barraNavegacionPersonalizada.modoVisible = false
            remover(vista)
        case let .anterior(vista) where vista == .ingresoDireccion:
            if presentador.obtenerEtapaInicial() == .ingresoTelefono {
                barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: false)
            }
            formularioDatosContacto.presentarFormularioAnterior()
            return
        case let .anterior(vista) where vista == .ingresoManual || vista == .ingresoTelefono:
            barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: false)
            remover(vista)
        case let .anterior(vista):
            remover(vista)
        }
    }
    
    func configurar(modelo: AutenticacionNavegacionViewModel) {
        barraProgresoNavegacion.colorActivado = modelo.colorHabilitado
        barraProgresoNavegacion.colorDesactivado = modelo.colorDeshabilitado
        barraProgresoNavegacion.configurar(etapa: modelo.etapa)
        formularioDatosContacto.autenticacionNavegacionDelegado = self
        formularioDatosPersonales.autenticacionNavegacionDelegado = self
        escanearDniViewController.autenticacionNavegacionDelegado = self
        pantallaConfirmacion.autenticacionNavegacionDelegado = self
        escanearDniViewController.vistaConfirmacionDelegado = pantallaConfirmacion
        formularioDatosPersonales.vistaConfirmacionDelegado = pantallaConfirmacion
    }
    
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        self.barraNavegacionPersonalizada.delegado = self
        self.barraNavegacionPersonalizada.configurarBarraNavegacion(viewModel: viewModel)
        self.barraNavegacionPersonalizada.modoVisible = true        
    }
    
    func autenticacionTerminada() {
        enrutador.autenticacionTerminada()
    }
}

extension AutenticacionNavegacionViewController: DelegadoBarraNavegacionPersonalizada {
    func botonIzquierdoAccionado() {
        presentador.etapaAnterior()
    }
}

extension AutenticacionVistaHija {
    func mostrarLoaderAutenticacion() {
        self.autenticacionNavegacionDelegado?.mostrarLoader()
    }
    func removerLoaderAutenticacion() {
        self.autenticacionNavegacionDelegado?.ocultarLoader()
    }
}

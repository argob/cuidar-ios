//
//  AutoevaluacionViewController.swift
//  CovidApp
//
//  Created on 8/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

enum Direccion {
    case siguiente
    case anterior
    case primerPaso
    case ninguna
}

protocol AutoevaluacionVista: class, VisualizadorDeCarga {
    func configurarVista(viewModel: AutoevaluacionGeneralViewModel)
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func actualizarBotonBack(visible: Bool)
    func configurarBarraDeProgreso(pasos: Int, pasoActual: Int)
    func configurar(items: [AutoevaluacionItemViewModel], refrescar: Bool)
    func mostrarDetalle(items: [AutoevaluacionItemViewModel])
    func mostrarAlertaDeEnviarDatos(contenido: AlertaViewModel)
    func mostrarAlertaDeTemperatura(contenido: AlertaViewModel, reiniciarValorInicial: Bool)
    func mostrarAlertaDeErrorAlSalvarDatos(viewModel: AlertaErrorEjecutarClienteViewModel)
    func showAlertInvalidToken()
    func actualizarBarraDeProgreso(direccion: Direccion)
    func actualizar(tituloDeAccion: String)
    func irASiguienteEscena()
    func irAEscenaPrevia()
    func habilitarBotonSiguiente()
    func deshabilitarBotonSiguiente()
}

final class AutoevaluacionViewController: BaseViewController, MVPVista, BotonCeldaDelegado {
    @IBOutlet weak var barraProgreso: BarraProgreso!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var botonSiguiente: BotonNavegacionGeneral!
    lazy var presentador: AutoevaluacionPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    private var elementos: [AutoevaluacionItemViewModel] = []
    @IBAction func botonSiguienteSeleccionado(_ sender: UIButton) {
        presentador.siguiente()
    }
    func botonSeleccionado(conIdentificador: Identificador) {
        if (conIdentificador == .volverAEmpezar) {
            presentador.volverAEmpezar()
        }
    }

}

extension AutoevaluacionViewController: AutoevaluacionVista {
    func showAlertInvalidToken() {
        let alert = UIAlertController(title: "Alerta", message: Constantes.ANOTHER_DEVICE_LOGGED, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.enrutador.desvinculaciónTerminada()
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func actualizarBotonBack(visible: Bool) {
        barraNavegacionPersonalizada.mostrarBotonIzquierdo(mostrar: visible)
    }
    
    func configurarVista(viewModel: AutoevaluacionGeneralViewModel) {
        tabla.dataSource = self
        tabla.configurar(modelo: viewModel.tabla)
        AutoevaluacionFactoriaCeldas.registrarCeldas(for: tabla)
        botonSiguiente.configurar(modelo: viewModel.boton)
    }
    
    func actualizar(tituloDeAccion: String) {
        botonSiguiente.setTitle(tituloDeAccion, for: .normal)
    }

    func configurarBarraDeProgreso(pasos: Int, pasoActual: Int) {
        barraProgreso.crear(numeroPasos: pasos, pasoSeleccionado: pasoActual)
    }
    
    func actualizarBarraDeProgreso(direccion: Direccion) {
        moverBarraDeProgreso(direccion: direccion)
    }
    
    func configurar(items: [AutoevaluacionItemViewModel], refrescar: Bool) {
        elementos = items        
        if refrescar {
            tabla.reloadData()
            tabla.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func mostrarDetalle(items: [AutoevaluacionItemViewModel]) {
        let controlador = AutoevaluacionConsejosCompletosViewController()
        controlador.presentador.recibir(elementos: items)
        navigationController?.present(controlador, animated: true)
    }
    
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        self.barraNavegacionPersonalizada.delegado = self
        self.barraNavegacionPersonalizada.configurarBarraNavegacion(viewModel: viewModel)
    }
    
    func mostrarAlertaDeEnviarDatos(contenido: AlertaViewModel) {
        let alert = UIAlertController(title: contenido.titulo,
                                      message: contenido.mensaje,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: contenido.tituloCancelar, style: .cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: contenido.tituloAceptar, style: .default, handler: { [weak self] (_) in
            self?.presentador.alertaAceptada()
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func mostrarAlertaDeTemperatura(contenido: AlertaViewModel, reiniciarValorInicial: Bool) {
        let alert = UIAlertController(title: contenido.titulo,
                                      message: contenido.mensaje,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: contenido.tituloAceptar, style: .default, handler: { [weak self] (_) in
            self?.presentador.usuarioAceptoAlertaDeTemperaturaFueraDeRango(reiniciarValorInicial: reiniciarValorInicial)
            alert.dismiss(animated: true)
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func mostrarAlertaDeErrorAlSalvarDatos(viewModel: AlertaErrorEjecutarClienteViewModel) {
        let alerta = FactoriaAlertViewController.crearAlertController(viewModel: viewModel)
        navigationController?.present(alerta, animated: true)
    }
    
    func irASiguienteEscena() {
        enrutador.autoevaluacionTerminada()
    }
    
    func irAEscenaPrevia() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func habilitarBotonSiguiente() {
        botonSiguiente.habilitarBoton()
    }
    
    func deshabilitarBotonSiguiente() {
        botonSiguiente.deshabilitarBoton()
    }
}

extension AutoevaluacionViewController: DelegadoBarraNavegacionPersonalizada {
    func botonIzquierdoAccionado() {
        presentador.atras()
    }
}

private extension AutoevaluacionViewController {
    func moverBarraDeProgreso(direccion: Direccion) {
        switch direccion {
        case .siguiente:
            barraProgreso.siguiente()
        case .anterior:
            barraProgreso.anterior()
        case .primerPaso:
            barraProgreso.primerPaso()
        case .ninguna:
            return
        }
    }
}

extension AutoevaluacionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return elementos.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factoria = AutoevaluacionFactoriaCeldas(tableView: tableView,
                                                     indexPath: indexPath, delegado: self)
        let celda = factoria.crearCelda(elemento: elementos[indexPath.row])
        return celda
     }
}

private extension AutoevaluacionViewController {
    func crearAlerta(viewModel: AlertViewModel) -> UIAlertController {
        let controller = UIAlertController(title: viewModel.title,
                                           message: viewModel.body,
                                           preferredStyle: .alert)
        viewModel.buttons.compactMap { boton in
            UIAlertAction(title: boton.title, style: boton.style) { (_) in
                boton.action?()
            }
        }.forEach(controller.addAction)
        
        return controller
    }
}

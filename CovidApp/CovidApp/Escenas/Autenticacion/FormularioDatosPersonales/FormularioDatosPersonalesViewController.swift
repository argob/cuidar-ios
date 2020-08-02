//
//  FormularioDatosPersonalesViewController.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol FormularioDatosPersonalesVista: AutenticacionVistaHija {
    func configurar(viewModel: DatosPersonalesViewModel)
    func definirTamaños()
    func irALaProximaSeccion()
    func autenticacionTerminada()
    func irAElSiguienteBloque()
    func mostrarError(identificador: TiposDeElementosDeFormulario, mensaje: String)
    func removerError(identificador: TiposDeElementosDeFormulario)
    func ocultarErrorDNI()
    func mostrarErrorDNI(con espacio: CGFloat)
    func habilitarSiguiente(colorFondo: UIColor)
    func deshabilitarSiguiente(colorFondo: UIColor)
    func enviarInformacionUsuario(modelo: ConfirmacionUsuarioViewModel)
    func mostrarComoObtenerNumero()
}

final class FormularioDatosPersonalesViewController: BaseViewController, MVPVista {
    
    weak var autenticacionNavegacionDelegado: AutenticacionNavegacionDelegado?
    weak var vistaConfirmacionDelegado: ManejardorDniDelegado?
    lazy var presentador: FormularioDatosPersonalesPresentadorProtocolo = inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    private lazy var factory = FactoriaVistasDeDatosPersonales()

    lazy var contentSize = CGSize(width: UIScreen.main.bounds.width, height: factory.height)
    
    weak var errorImageLabel: ImageViewManejador?
    var botonSiguiente: BotonNavegacionGeneral!
    var contenedorVista: UIView!
    var campoTextoTramite: CampoDeTextoSencilloView!
    var campoTextoDni: CampoDeTextoSencilloView!
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
}

extension FormularioDatosPersonalesViewController: FormularioDatosPersonalesVista {
    func definirTamaños() {
        contenedorVista.frame.size = contentSize
        scrollView.contentSize = self.contentSize
    }
    
    func enviarInformacionUsuario(modelo: ConfirmacionUsuarioViewModel) {
        vistaConfirmacionDelegado?.recibirInfoUsuario(modelo: modelo)
    }
    
    func ocultarErrorDNI() {
        contentSize = CGSize(width: UIScreen.main.bounds.width, height: factory.height)
        definirTamaños()
        errorImageLabel?.ocultar()
    }
    
    func mostrarErrorDNI(con espacio: CGFloat) {
        contentSize = CGSize(width: UIScreen.main.bounds.width, height: factory.height + espacio)
        definirTamaños()
        errorImageLabel?.mostrar()
    }
    
    func irAElSiguienteBloque() {
        autenticacionNavegacionDelegado?.finalAutenticacion()
    }
    
    func deshabilitarSiguiente(colorFondo: UIColor) {
        botonSiguiente?.deshabilitarBoton(colorFondo: colorFondo)
    }
    
    func habilitarSiguiente(colorFondo: UIColor) {
        botonSiguiente?.habilitarBoton(colorFondo: colorFondo)
    }
    
    func mostrarError(identificador: TiposDeElementosDeFormulario, mensaje: String) {
        switch identificador {
        case .dni:
            campoTextoDni.agregarMensajeEnLinea(mensaje: mensaje, estado: .error)
        case .tramite:
            campoTextoTramite.agregarMensajeEnLinea(mensaje: mensaje, estado: .error)
        default:
            break
        }
    }
    
    func removerError(identificador: TiposDeElementosDeFormulario) {
        switch identificador {
        case .dni:
            campoTextoDni.removerMensajeEnLinea()
        case .tramite:
            campoTextoTramite.removerMensajeEnLinea()
        default:
            break
        }
    }
    
    func irALaProximaSeccion() {
        autenticacionNavegacionDelegado?.siguienteEtapa()
    }
    
    func autenticacionTerminada() {
        autenticacionNavegacionDelegado?.finalAutenticacion()
    }
    
    func mostrarComoObtenerNumero() {
        present(AutenticacionNumeroTramiteViewController(), animated: true)
    }

    
    func configurar(viewModel: DatosPersonalesViewModel) {
        let camposFactory = factory.crearFormulario(viewModel: viewModel)
        self.botonSiguiente = factory.crearBotonSiguiente(modelo: viewModel.botonSiguiente) as? BotonNavegacionGeneral
        
        guard
            let campoTextoDni = camposFactory.campoTextoDni as? CampoDeTextoSencilloView,
            let campoTextoTramite = camposFactory.campoTextoTramite as? CampoDeTextoSencilloView
        else {
           return
        }
        
        self.campoTextoDni = campoTextoDni
        self.campoTextoDni.delegadoCampoSencillo = self
        
        self.campoTextoTramite = campoTextoTramite
        self.campoTextoTramite.delegadoCampoSencillo = self
        
        contenedorVista = camposFactory.contenedorVista
        errorImageLabel = camposFactory.delegadoErrorServicio
        
        scrollView.addSubview(contenedorVista)
        view.addSubview(scrollView)
        view.addSubview(botonSiguiente)
        
        configurarConstraints()
    }
    private func configurarConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: botonSiguiente.topAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            
            botonSiguiente.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            botonSiguiente.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            botonSiguiente.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            botonSiguiente.heightAnchor.constraint(equalToConstant: 58.0)
        ])
    }
}

extension FormularioDatosPersonalesViewController: CampoDeTextoSencilloViewDelegate {
    func valorCampoDeTextoCambio(valor: String?, identificador: TiposDeElementosDeFormulario?) {
        guard let identificador = identificador else { return }
        presentador.recibir(identificador: identificador, valor: valor)
    }
    
    func campoDeTextoActivado(campoDeTexto: UITextField) {
        
    }
}

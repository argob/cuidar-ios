//
//  FormularioDatosDeContactoViewController.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol FormularioDatosDeContactoVista: AutenticacionVistaHija {
    func presentarFormularioTelefono(viewModel: FormularioDatosDeContactoViewModel)
    func presentarFormularioDireccion(viewModel: FormularioDatosDeContactoViewModel)
    func presentarErrorEnFormulario(mensaje: String)
    func presentarErrorEnFormulario(viewModel: ElementoDeFormularioViewModel)
    func alertAnotherDeviceLogged()
    func presentarFormularioAnterior()
    func escenaCargo()
    func finalizoAutenticacion()
    func recargarCampoCiudad(viewModel: ElementoDeFormularioViewModel)
    func deshabilitarSiguiente(colorFondo: UIColor)
    func habilitarSiguiente(colorFondo: UIColor)
    func actualizarBotonSiguiente(tituloDeAccion: String)
    func mostrarPicker(con opciones: [CiudadProvincia], identificador: TiposDeElementosDeFormulario?)
    func agregarValorAlCampo(_ valor: String, identifier: TiposDeElementosDeFormulario)
}

final class FormularioDatosDeContactoViewController: BaseViewController, MVPVista {
    lazy var presentador: FormularioDatosDeContactoPresentadorProtocolo = self.inyectar()
    weak var autenticacionNavegacionDelegado: AutenticacionNavegacionDelegado?
    
    @IBOutlet weak var contenedorFormularioStackView: UIStackView!
    @IBOutlet weak var tituloFormulario: UILabel!
    @IBOutlet weak var contenedorScrollView: UIScrollView!
    @IBOutlet weak var botonSiguiente: BotonNavegacionGeneral!
    
    lazy var tablaOpciones: TablaOpcionesVista = {
        let tablaOpciones = TablaOpcionesVista()
        tablaOpciones.delegado = self
        return tablaOpciones
    }()
    
    private var camposFormularios = Dictionary<TiposDeElementosDeFormulario, CampoDeTextoSencilloView>()
    
    var campoDeTextoActivado: UITextField?
    var viewModel: ElementoDeFormularioViewModel?
    
    @IBAction func finalizarFormularioTelefono(_ sender: Any) {
        autenticacionNavegacionDelegado?.siguienteEtapa()
        presentador.siguienteFormulario()
    }
}

extension FormularioDatosDeContactoViewController: FormularioDatosDeContactoVista {
    func alertAnotherDeviceLogged() {
        let alert = UIAlertController(title: "Alerta", message: Constantes.ANOTHER_DEVICE_LOGGED, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
            self.autenticacionNavegacionDelegado?.logOut()
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func agregarValorAlCampo(_ valor: String, identifier: TiposDeElementosDeFormulario) {
        camposFormularios[identifier]?.campoDeTexto.text = valor
        presentador.recibirDato(dato: valor, tipoDeElemento: identifier)
    }
    
    func mostrarPicker(con opciones: [CiudadProvincia], identificador: TiposDeElementosDeFormulario?) {
        tablaOpciones.configurar(opciones: opciones, identificador: identificador)
        navigationController?.present(tablaOpciones, animated: true)
    }
    
    func presentarFormularioAnterior() {
        presentador.presentarFormularioAnterior()
    }
    
    func recargarCampoCiudad(viewModel: ElementoDeFormularioViewModel) {
        let campoFormularioCiudad = camposFormularios[viewModel.identificador]
        campoFormularioCiudad?.campoDeTexto.text = viewModel.textoParaCampoDeTexto
        campoFormularioCiudad?.campoDeTexto.placeholder = viewModel.placeholderParaCampoDeTexto
        (campoFormularioCiudad as? CampoSeleccionadorView)?.actualizar(opciones: viewModel.datos ?? [])
    }
    
    func finalizoAutenticacion() {
        autenticacionNavegacionDelegado?.finalAutenticacion()
    }
    
    func escenaCargo() {
        configurarNotificacionesDeTeclado()
    }
    
    func presentarFormularioTelefono(viewModel: FormularioDatosDeContactoViewModel) {
        tituloFormulario.text = viewModel.tituloParaFormulario
        limpiarFormulario()
        crearFormulario(viewModel: viewModel)
        botonSiguiente.configurar(modelo: viewModel.botonSiguiente)
    }
    
    func presentarFormularioDireccion(viewModel: FormularioDatosDeContactoViewModel) {
        tituloFormulario.text = viewModel.tituloParaFormulario
        limpiarFormulario()
        crearFormulario(viewModel: viewModel)
        botonSiguiente.configurar(modelo: viewModel.botonSiguiente)
    }
    
    func presentarErrorEnFormulario(mensaje: String) {
        let alertaController = UIAlertController(title: "Error en formulario", message:
            mensaje, preferredStyle: .alert)
        alertaController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertaController, animated: true, completion: nil)
    }
    
    func presentarErrorEnFormulario(viewModel: ElementoDeFormularioViewModel) {
        guard let campo = camposFormularios[viewModel.identificador] else { return }
        campo.labelBajoCampo.text = viewModel.textoBajoCampoDeTexto
        campo.labelBajoCampo.font = viewModel.tipografiaEtiquetaBajoTexto.fuente
        campo.labelBajoCampo.textColor = viewModel.tipografiaEtiquetaBajoTexto.color
        campo.lineaCampoTexto.backgroundColor = viewModel.tipografiaEtiquetaBajoTexto.color
    }

    func deshabilitarSiguiente(colorFondo: UIColor) {
        botonSiguiente?.deshabilitarBoton(colorFondo: colorFondo)
    }

    func habilitarSiguiente(colorFondo: UIColor) {
        botonSiguiente?.habilitarBoton(colorFondo: colorFondo)
    }

    func actualizarBotonSiguiente(tituloDeAccion: String) {
        botonSiguiente.setTitle(tituloDeAccion, for: .normal)
    }
}

private extension FormularioDatosDeContactoViewController {
    func configurarNotificacionesDeTeclado() {
        NotificationCenter.default.addObserver(self, selector: #selector(tecladoAparecera), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tecladoSeEscondera), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func tecladoAparecera(notification: NSNotification) {
        guard var tamañoDeTeclado = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let campoDeTextoActivado = campoDeTextoActivado else {
           return
        }
        let posicionCampoDeTextoSeleccionado = campoDeTextoActivado.convert(campoDeTextoActivado.bounds, to: parent?.view).maxY
        guard var posicionDeTeclado = self.parent?.view.frame.height else {
            return
        }
        posicionDeTeclado = posicionDeTeclado - tamañoDeTeclado.height
        if posicionCampoDeTextoSeleccionado > posicionDeTeclado {
            tamañoDeTeclado = self.view.convert(tamañoDeTeclado, from: nil)
            var contentInset:UIEdgeInsets = self.contenedorScrollView.contentInset
            contentInset.bottom = tamañoDeTeclado.size.height
            self.contenedorScrollView.contentInset = contentInset
        }
    }
    
    @objc func tecladoSeEscondera(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contenedorScrollView.contentInset = contentInset
    }
    
    func limpiarFormulario() {
        for stackView in contenedorFormularioStackView.arrangedSubviews {
            if stackView.tag == 1 { continue }
            stackView.removeFromSuperview()
        }
    }
    
    func crearFormulario(viewModel: FormularioDatosDeContactoViewModel) {
        var parejaDeElementos: [ElementoDeFormularioViewModel] = []
        for elemento in viewModel.elementosDeFormulario {
            switch elemento.tipoDeElemento {
            case .sencillo:
                crearElementoDeFormularioSencillo(viewModel: elemento)
            case .doble:
                parejaDeElementos.append(elemento)
                if parejaDeElementos.count == 2 {
                    crearElementoDeFormularioDoble(viewModels: parejaDeElementos)
                    parejaDeElementos.removeAll()
                }
            case .seleccionador:
                crearElementoDeFormularioSeleccionador(viewModel: elemento)
            }
        }
        parejaDeElementos.removeAll()
    }
    
    func crearElementoDeFormularioSencillo(viewModel: ElementoDeFormularioViewModel) {
        let elementoFormulario = configurarElementoFormulario(viewModel: viewModel)
        
        camposFormularios[viewModel.identificador] = elementoFormulario
        contenedorFormularioStackView.addArrangedSubview(elementoFormulario)
    }
    
    func crearElementoDeFormularioDoble(viewModels: [ElementoDeFormularioViewModel]) {
        guard let metricaAltura = viewModels.first?.metricaDeAltura else {
            return
        }
        
        let stack = UIStackView()
        let altura = crearConstraintDeAlturaParaElemento(vista: stack, constante: CGFloat(metricaAltura), tipoElemento: .sencillo)
        stack.axis = .horizontal
        stack.spacing = 0
        stack.addConstraint(altura)
        stack.distribution = .fillEqually
        
        for elemento in viewModels {
            let elementoFormulario = configurarElementoFormulario(viewModel: elemento)
            camposFormularios[elemento.identificador] = elementoFormulario
            stack.addArrangedSubview(elementoFormulario)
        }
        
        contenedorFormularioStackView.addArrangedSubview(stack)
    }
    
    func crearElementoDeFormularioSeleccionador(viewModel: ElementoDeFormularioViewModel) {
        let elementoFormulario = configurarElementoFormularioSeleccionador(viewModel: viewModel)
        
        camposFormularios[viewModel.identificador] = elementoFormulario
        contenedorFormularioStackView.addArrangedSubview(elementoFormulario)
    }
    
    
    func crearConstraintDeAlturaParaElemento(vista: UIView, constante: CGFloat, tipoElemento: TipoDeElemento) -> NSLayoutConstraint {
        let esCampoSencilloSeleccionador = tipoElemento == .sencillo || tipoElemento == .seleccionador
        let atributo = esCampoSencilloSeleccionador ? NSLayoutConstraint.Attribute.height: NSLayoutConstraint.Attribute.width
        let heightContraint = NSLayoutConstraint(item: vista, attribute: atributo, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: constante)
        
        return heightContraint
    }
    
    func comfigurarElemento(_ elementoFormulario: CampoDeTextoSencilloView, viewModel: ElementoDeFormularioViewModel) {

        elementoFormulario.delegadoCampoSencillo = self
        elementoFormulario.configurar(viewModel: viewModel)
        
        let esCampoSencilloSeleccionador = viewModel.tipoDeElemento == .sencillo || viewModel.tipoDeElemento == .seleccionador
        let metrica = esCampoSencilloSeleccionador ? viewModel.metricaDeAltura: viewModel.metricaDeAncho
        let constraint = crearConstraintDeAlturaParaElemento(vista: elementoFormulario, constante: CGFloat(metrica), tipoElemento: viewModel.tipoDeElemento)
        elementoFormulario.addConstraint(constraint)

        if viewModel.identificador == .telefono ||  viewModel.identificador == .numero || viewModel.identificador == .codigoPostal {
            elementoFormulario.campoDeTexto.keyboardType = .numberPad
        }
    }
    
    func configurarElementoFormulario(viewModel: ElementoDeFormularioViewModel) -> CampoDeTextoSencilloView {
        let elementoFormulario = CampoDeTextoSencilloView()
        comfigurarElemento(elementoFormulario, viewModel: viewModel)
        
        return elementoFormulario
    }

    func configurarElementoFormularioSeleccionador(viewModel: ElementoDeFormularioViewModel) -> CampoSeleccionadorView {
        let elementoFormulario = CampoSeleccionadorView()
        elementoFormulario.delegadoCampoSencillo = self
        elementoFormulario.delegadoPicker = self
        comfigurarElemento(elementoFormulario, viewModel: viewModel)
        
        return elementoFormulario
    }
}

extension FormularioDatosDeContactoViewController: CampoDeTextoSencilloViewDelegate {
    func valorCampoDeTextoCambio(valor: String?, identificador: TiposDeElementosDeFormulario?) {
        if let dato = valor, let tipo = identificador {
            presentador.recibirDato(dato: dato, tipoDeElemento: tipo)
        }
    }
    
    func campoDeTextoActivado(campoDeTexto: UITextField) {
        campoDeTextoActivado = campoDeTexto
    }
}

extension FormularioDatosDeContactoViewController: DelegadoPicker {
    func usuarioActivoPicker(identificador: TiposDeElementosDeFormulario?) {
        presentador.mostrarTablaOpciones(para: identificador)
    }
}

extension FormularioDatosDeContactoViewController: ManejoOpcionesDelegado {
    func recibirOpcionSeleccionada(valor: String, identificador: TiposDeElementosDeFormulario?) {
        
        guard let identificador = identificador else { return }
        presentador.recibirDatoPicker(dato: valor, tipoDeElemento: identificador)
        
    }
}

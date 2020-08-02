//
//  EscanearDniView.swift
//  CovidApp
//
//  Created on 4/8/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit
import ZXingObjC
import AVFoundation

protocol EscanearDniVista: AutenticacionVistaHija {
    func configurar(viewModel: AceptarTerminosViewModel)
    func mostrarTerminos()
    func cambioTerminos(aceptados: Bool)
    func mostrarResultadoEscaneo(resultado: ConfirmacionUsuarioViewModel)
    func mostrarResultadoEscaneoUsuarioExistente()
    func mostrarErrorEscaneo(estaEscondido: Bool, estadoBoton: BotonEscanear)
}

final class EscanearDniViewController: BaseViewController, MVPVista {
    
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var dniUsuario: UILabel!
    @IBOutlet weak var numeroTramiteUsuario: UILabel!
    @IBOutlet weak var generoUsuario: UILabel!
    @IBOutlet weak var vistaError: UIView!
    @IBOutlet weak var vistaEscanearDni: UIView!
    @IBOutlet weak var vistaFinalizarEscaner: UIView!
    @IBOutlet weak var imagenDni: UIImageView!
    @IBOutlet weak var vistaTerminos: UIView!
    @IBOutlet weak var botonEscanear: BotonNavegacionGeneral!
    @IBOutlet weak var botonEscanearManual: BotonNavegacionGeneralConBorde!
    
    private var cordinadorDeVistas: CoordinadorDeVistas = .instancia
    lazy var presentador: EscanearDniPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
    weak var autenticacionNavegacionDelegado: AutenticacionNavegacionDelegado?
    weak var vistaConfirmacionDelegado: ManejardorDniDelegado?
    
    private var cameraAutorizada: Bool = false
    
    @IBAction func escanearDni(_ sender: Any) {
        revisarPermisosDeCamara { [weak self] (autorizado) in
            guard let self = self else {
                return
            }
            if autorizado {
                self.cordinadorDeVistas.irAEscaner(delegado: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarVistaErrorEscaneo()
    }
    
    func configurarVistaErrorEscaneo(){
        vistaError.layer.borderColor = UIColor.red.cgColor
        vistaError.layer.borderWidth = 1
        vistaError.layer.cornerRadius = 10
    }
    
    @IBAction func ingresarManualmente(_ sender: Any) {
        mostrarErrorEscaneo(estaEscondido: true, estadoBoton: BotonEscanear.escanearFrente)
        autenticacionNavegacionDelegado?.ingresoManual()
    }
    
    @IBAction func volverAEscanear(_ sender: Any) {
        actualizarVistaDeEscaneo(isVisible: true)
    }
    
    @IBAction func terminarEscaneo(_ sender: Any) {
        autenticacionNavegacionDelegado?.siguienteEtapa()
    }
}

extension EscanearDniViewController: EscanearDniVista {
    func configurar(viewModel: AceptarTerminosViewModel) {
        let terminosStack = VistaTerminos()
        terminosStack.configurar(modelo: viewModel)
        terminosStack.accionAceptarTerminos = viewModel.accionAceptarTerminos
        terminosStack.accionMostrarTerminos = viewModel.accionMostrarTerminos
        terminosStack.translatesAutoresizingMaskIntoConstraints = false
        vistaTerminos.addSubview(terminosStack)
        NSLayoutConstraint.activate([
            terminosStack.leadingAnchor.constraint(equalTo: vistaTerminos.leadingAnchor),
            terminosStack.trailingAnchor.constraint(equalTo: vistaTerminos.trailingAnchor),
            terminosStack.topAnchor.constraint(equalTo: vistaTerminos.topAnchor),
            terminosStack.bottomAnchor.constraint(equalTo: vistaTerminos.bottomAnchor)]
        )
        cambioTerminos(aceptados: viewModel.preSelecionado)
    }
    
    func mostrarTerminos() {
        enrutador.terminosYCondicionesIniciar()
    }
    
    func cambioTerminos(aceptados: Bool) {
        if aceptados {
            botonEscanear.habilitarBoton(colorFondo: Constantes.COLOR_HABILITADO)
            botonEscanearManual.habilitarBoton(colorFondo: Constantes.COLOR_HABILITADO_MANUAL)
        } else {
            botonEscanear.deshabilitarBoton()
            botonEscanearManual.deshabilitarBoton()
        }
    }
    
    func mostrarErrorEscaneo(estaEscondido: Bool, estadoBoton: BotonEscanear) {
        vistaError.isHidden = estaEscondido
        botonEscanear.setTitle(estadoBoton.rawValue, for: .normal)
    }
   
    func mostrarResultadoEscaneo(resultado: ConfirmacionUsuarioViewModel) {
        vistaConfirmacionDelegado?.recibirInfoUsuario(modelo: resultado)
        autenticacionNavegacionDelegado?.siguienteEtapa()
    }
    
    func mostrarResultadoEscaneoUsuarioExistente() {
        autenticacionNavegacionDelegado?.finalAutenticacion()
    }
    
    func actualizarVistaDeEscaneo(isVisible : Bool) {
        vistaError.isHidden = isVisible
        vistaFinalizarEscaner.isHidden = isVisible
        vistaEscanearDni.isHidden = !isVisible
    }
    
    func configurarCamara(autorizada: Bool) {
        cameraAutorizada = autorizada
    }
}

extension EscanearDniViewController: EscannerDelegado {
    func datosEscaneados(with result: ZXResult) {
        self.presentador.recibirDatosEscaneados(resultado: result)
    }
}

extension EscanearDniViewController {
    // Este permiso sólo se utiliza para leer el código de barras de un formato determinado del DNI y que sea más fácil la carga de los datos solicitados en el ingreso a la aplicación
    func revisarPermisosDeCamara(completion: @escaping ((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (autorizado) in
                DispatchQueue.main.sync {
                    completion(autorizado)
                }
            }
        case .authorized:
            completion(true)
        case .denied:
            let controller = UIAlertController(title: "Acceso a la cámara",
                                               message: "Para ayudarte a escanear tu DNI necesitamos que nos permitas acceder a la cámara. Pulsá Configuración > Activar Cámara",
                                               preferredStyle: .alert)
            
            
            controller.addAction(UIAlertAction(title: "Ir a Configuración", style: .default) { [weak self] action in
                self?.cordinadorDeVistas.irAConfiguracionDeAPP()
            })
            controller.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(controller, animated: true, completion: nil)
            
        default:
            completion(false)
        }
    }
}

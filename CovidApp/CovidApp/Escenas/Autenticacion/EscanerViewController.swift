//
//  EscanerViewController.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit
import ZXingObjC

protocol EscannerDelegado: class {
    func datosEscaneados(with result: ZXResult)
}

final class EscanerViewController: BaseViewController {
    
        
    @IBOutlet weak var vistaCamara: UIView!
    @IBOutlet weak var labelEscanner: UILabel!
    @IBOutlet weak var botonCerrar: UIButton!
    
    fileprivate var captura: ZXCapture?
    
    fileprivate var isEscaneando: Bool?
    fileprivate var transformaTamanioDeCaptura: CGAffineTransform?
    
    weak var delegate: EscannerDelegado?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captura?.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captura?.layer.frame = vistaCamara.layer.frame
        view.bringSubviewToFront(botonCerrar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Prevenir crash de ZXing Crash en < iOS 13 cuando la vista desaparece (Zombie)
        self.captura?.layer.removeFromSuperlayer()
    }
    
    @IBAction func cerrarPantalla(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EscanerViewController {
    
    func configurar() {
        isEscaneando = false
        captura = ZXCapture()
        guard let _captura = captura else { return }
        _captura.rotation = CGFloat(90.0)
        _captura.camera = _captura.back()
        _captura.focusMode =  .continuousAutoFocus
        _captura.delegate = self
        vistaCamara.layer.addSublayer(_captura.layer)
    }
    
}

extension EscanerViewController: ZXCaptureDelegate {
    
    func captureCameraIsReady(_ captura: ZXCapture!) {
        isEscaneando = true
    }

    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        guard result.barcodeFormat == kBarcodeFormatPDF417 else { return }
        guard isEscaneando == true else { return }
        capture.stop()
        isEscaneando = false
        labelEscanner?.text = "Dni Escaneado!"
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        delegate?.datosEscaneados(with: result)
        dismiss(animated: true, completion: nil)
    }
    
}


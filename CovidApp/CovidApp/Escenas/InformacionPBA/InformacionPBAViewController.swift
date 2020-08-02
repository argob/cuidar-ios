//
//  InformacionPBAViewController.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit


protocol InformacionPBAVista: class , VisualizadorDeCarga {
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel)
    func configurarVista()
    func volverAtras()
}


final class InformacionPBAViewController: BaseViewController, MVPVista, DelegadoBarraNavegacionPersonalizada {
    
    
    
    
    lazy var presentador: InformacionPBAPresentadorProtocolo = self.inyectar()
    
    lazy var enrutador: Enrutador = self.inyectar()
    @IBOutlet weak var portalCoronavirus: UIButton!
    @IBOutlet weak var asistenteDeSalud: UIButton!
    @IBOutlet weak var sip: UIButton!
    @IBOutlet weak var asistenciaRemota: UIButton!

    @IBAction func portalCoronavirusAction(_ sender: Any) {
        guard let url = URL(string: "https://portal-coronavirus.gba.gob.ar") else {return }
        presentador.irA(url: url)
    }
    @IBAction func asistenteDeSaludAction(_ sender: Any) {
        guard let url = URL(string: "https://asistentesalud.gobdigital.gba.gob.ar/?appCuidar") else {return }
        presentador.irA(url: url)
    }
    @IBAction func sipAction(_ sender: Any) {
        guard let url = URL(string: "https://portal-coronavirus.gba.gob.ar/sip_cuidar/") else {return }
        presentador.irA(url: url)
    }
    @IBAction func asistenciaRemotaAction(_ sender: Any) {
        guard let url = URL(string: "https://asistenciacovid.gba.gob.ar/login") else {return }
        presentador.irA(url: url)
    }
    func botonIzquierdoAccionado() {
        presentador.volver()
    }
}

extension InformacionPBAViewController : InformacionPBAVista{
    func volverAtras() {
        enrutador.volverAPasaporte()
    }
    
    func configurarVista() {
        portalCoronavirus.layer.cornerRadius = 5
        asistenteDeSalud.layer.cornerRadius = 5
        sip.layer.cornerRadius = 5
        asistenciaRemota.layer.cornerRadius = 5
    }
    func configurarBarraNavegacion(viewModel: BarraNavegacionPersonalizadaViewModel) {
        self.barraNavegacionPersonalizada.delegado = self
        self.barraNavegacionPersonalizada.configurarBarraNavegacion(viewModel: viewModel)
        self.barraNavegacionPersonalizada.modoVisible = true
    }
}





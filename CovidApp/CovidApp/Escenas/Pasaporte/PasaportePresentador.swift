//
//  PasaportePresentador.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol PasaportePresentadorProtocol {
    func manejarBotonConIdentificador(identificador: Identificador)
    func manejarPresentarMasInformacion()
    func manejarSeleccionDesvincularCuenta()
    func manejarAbrirURL(_ url: String)
    func manejarEdiciondeDatos()
    func manejarOpcionPBA()
    func manejarRefresh(showTips: Bool)
}

extension MVPVista where Self: PasaporteVista {
    func inyectar() -> PasaportePresentadorProtocol {
        let presenter = PasaportePresentador()
        presenter.vista = self
        return presenter
    }
}

final class PasaportePresentador: MVPPresentador {
    struct Dependencias {
        let tokenFachada: TokenFachadaProtocolo = inyectar()
        let usuarioFachada : UsuarioFachadaProtocolo = inyectar()
        let notificacionFachada: NotificacionFachadaProtocolo = inyectar()
    }
    
    weak var vista: PasaporteVista?
    let dependencias: Dependencias
    lazy var notificationCenter = NotificationCenter.default
    
    init(dependencias: Dependencias = Dependencias() ) {
        self.dependencias = dependencias
    }
}

extension PasaportePresentador: PasaportePresentadorProtocol {

    func manejarOpcionPBA() {
        guard let sesion = dependencias.usuarioFachada.obtenerUltimaSession(), let usuario = sesion.informacionDeUsuario else { return }
               
        if (usuario.domicilio?.provincia == "Buenos Aires") {
            vista?.presentarInformacionPBA()
        }
    }
    func manejarRefresh(showTips: Bool) {
        refrescarInformacionDelUsuario(showTips: showTips)
    }
    
    func escenaCargo() {
        vista?.configurarTablaContenido()
        cargarInformacionDelUsuario()
        refrescarInformacionDelUsuario(showTips: true)
        dependencias.notificacionFachada.registrarDispositivo()
    }
    
    func escenaAparecera() {
        vista?.configurarBarraNavegacion(viewModel: .soloHeaderPrincipal)
        vista?.configurarMenu(con: generarInformacionMenu())
        notificationCenter.addObserver(
            self,
            selector: #selector(refrescarInformacionDelUsuario(showTips:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(refrescarInformacionDelUsuario(showTips:)),
            name: Notification.Name.init(rawValue: "pushNotification"),
            object: nil
        )
    }
    func escenaDesaparecio() {
        notificationCenter.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        notificationCenter.removeObserver(
            self,
            name: Notification.Name.init(rawValue: "pushNotification"),
            object: nil
        )
    }
    
    
    func manejarEdiciondeDatos() {
        vista?.editarDatosPersonales()
    }
    
    func manejarBotonConIdentificador(identificador: Identificador) {
        if identificador == .actualizar {
            refrescarInformacionDelUsuario(showTips: true)
        } else if identificador == .autodiagnostico {
            vista?.nuevoAutodiagnostico()
        } else if identificador == .habilitarCirculacion {
            vista?.habilitarCirculacion()
        }
    }
    
    func manejarPresentarMasInformacion() {
        vista?.presentarMasInformacion()
    }
    
    func manejarAbrirURL(_ url: String) {
        guard let link = URL(string: url) else { return }
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
    }
    
    func manejarSeleccionDesvincularCuenta() {
        let viewModel = AlertaDesvincularDNIViewModel(
            titulo: "Desvincular",
            mensaje: "¿Estás seguro que deseás desvincular el DNI?",
            tituloAceptar: "Aceptar",
            tituloCancelar: "Cancelar")
        { [weak self] in
            self?.dependencias.notificacionFachada.desregistrarDispositivo()
            self?.dependencias.usuarioFachada.logout()
            self?.vista?.desvincularSesion()
        }
        vista?.mostrarAlertaDesvincularDNI(viewModel: viewModel)
    }
    
    private func generarInformacionMenu() -> ViewModelMenuNavegacion? {
        guard let sesion = dependencias.usuarioFachada.obtenerUltimaSession(), let usuario = sesion.informacionDeUsuario else { return nil }
        let lineasDireccion = obtenerLineasDireccion(para: usuario.domicilio)
        return ViewModelMenuNavegacion(
            nombreUsuario: LabelViewModel(texto: "\(usuario.nombres) \(usuario.apellidos)" , apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: UIColor.black)),
            DNI: LabelViewModel(texto: "DNI: \(sesion.dni)", apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 14), colorTexto: UIColor.black)),
            telefono: LabelViewModel(texto: usuario.telefono ?? "", apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 14), colorTexto: UIColor.black)),
            direccion: LabelViewModel(texto: lineasDireccion.direccion, apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 14), colorTexto: UIColor.black)),
            direccion2: LabelViewModel(texto: lineasDireccion.pisoPuerta, apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 14), colorTexto: UIColor.black)),
            direccion3: LabelViewModel(texto: lineasDireccion.localidad, apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 14), colorTexto: UIColor.black)),
            provincia: usuario.domicilio?.provincia ?? "sin provincia"
        )
    }
    
    private func obtenerLineasDireccion(para domicilioUsuario: Domicilio?) -> (direccion: String, pisoPuerta: String, localidad: String) {
        guard let domicilio = domicilioUsuario else { return ("", "", "")}
        let direccion = "Calle \(domicilio.calle), Nº \(domicilio.numero)"
        let localidad = "\(domicilio.localidad), \(domicilio.provincia)"
        func pisoPuertaHelper() -> String {
            var pisoPuetaHelperArray: [String] = []
            if let piso = domicilio.piso, piso.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                pisoPuetaHelperArray.append("Piso \(piso)")
            }
            if let puerta = domicilio.puerta, puerta.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                pisoPuetaHelperArray.append("Puerta \(puerta)")
            }
            return pisoPuetaHelperArray.joined(separator: ", ")
        }
        let pisoPuesta = pisoPuertaHelper()
        return (direccion, pisoPuesta, localidad)
    }
}

extension PasaportePresentador: VisitadorEstado {
    func visitarDerivadoALaSaludLocal(aditionalInfo: Sesion.InformacionDeUsuario?) -> TipoPasaporte? {
        return PasaporteDerivadoALaSalud(
            vigencia: aditionalInfo?.ultimoEstado.vencimiento ?? "",
            tagPims: aditionalInfo?.ultimoEstado.pims?.tag,
            motivoPims: aditionalInfo?.ultimoEstado.pims?.motivo,
            provinciaCoep: aditionalInfo?.ultimoEstado.datosCoep?.provincia,
            telefonoCoep: aditionalInfo?.ultimoEstado.datosCoep?.telefono
        )
    }
    
    func visitarNoInfectado(aditionalInfo: Sesion.InformacionDeUsuario?) -> TipoPasaporte? {
        
        if (aditionalInfo?.ultimoEstado.permisosDeCirculacion?.count ?? 0 >= 1) {
            return PasaporteNoInfectado(
            vigencia: aditionalInfo?.ultimoEstado.vencimiento ?? "",
            qrString: aditionalInfo?.ultimoEstado.permisosDeCirculacion?[0].qrURL,
            vigenciaCirculacion: aditionalInfo?.ultimoEstado.permisosDeCirculacion?[0].vencimiento ?? "",
            tipoActividad: aditionalInfo?.ultimoEstado.permisosDeCirculacion?[0].tipoActividad ?? "",
            permisosDeCirculacion: aditionalInfo?.ultimoEstado.permisosDeCirculacion)
        }
        
        return PasaporteNoInfectado(
            vigencia: aditionalInfo?.ultimoEstado.vencimiento ?? "",
            qrString: aditionalInfo?.ultimoEstado.permisoDeCirculacion?.qrURL,
            vigenciaCirculacion: aditionalInfo?.ultimoEstado.permisoDeCirculacion?.vencimiento ?? "",
            tipoActividad: aditionalInfo?.ultimoEstado.permisoDeCirculacion?.tipoActividad ?? "")
    }
    
    func visitarNoContagioso(aditionalInfo: Sesion.InformacionDeUsuario?) -> TipoPasaporte? {
        return PasaporteNoContagioso(
            vigencia: aditionalInfo?.ultimoEstado.vencimiento ?? "",
            qrString: aditionalInfo?.ultimoEstado.permisoDeCirculacion?.qrURL,
            vigenciaCirculacion: aditionalInfo?.ultimoEstado.permisoDeCirculacion?.vencimiento ?? "")
    }
    
    func visitarInfectado(aditionalInfo: Sesion.InformacionDeUsuario?) -> TipoPasaporte? {
        return PasaporteInfectado(
            vigencia: aditionalInfo?.ultimoEstado.vencimiento ?? "",
            provinciaCoep: aditionalInfo?.ultimoEstado.datosCoep?.provincia,
            telefonoCoep: aditionalInfo?.ultimoEstado.datosCoep?.telefono
        )
    }
    
    func visitarDebeAutodiagnosticarse(aditionalInfo: Sesion.InformacionDeUsuario?) -> TipoPasaporte? {
        return nil
    }
}

private extension PasaportePresentador {
    func cargarInformacionDelUsuario() {
        guard let sesion = dependencias.usuarioFachada.obtenerUltimaSession() else {
            return
        }
        configurarVistaConSesion(sesion: sesion)
    }
    
    @objc func refrescarInformacionDelUsuario(showTips: Bool) {
        if showTips {
            self.vista?.mostrarConsejos()
        }
        vista?.mostrarLoader()
        dependencias.usuarioFachada.actualizarInformacionDeUsuario { [weak self] sesion in
            DispatchQueue.main.async { [weak self] in
                self?.vista?.ocultarLoader()
                self?.vista?.terminarRefresh()                
                self?.vista?.configurarMenu(con: self?.generarInformacionMenu())
                guard let self = self else { return }
                self.configurarVistaConSesion(sesion: sesion)
                
            }
        }
    }
    
    func configurarVistaConSesion(sesion: Sesion) {
        guard
            let informacionDeUsuario = sesion.informacionDeUsuario,
            let tipoPasaporte = informacionDeUsuario.ultimoEstado.aceptar(visitor: self,
                                                                          aditionalInfo: informacionDeUsuario),
            informacionDeUsuario.ultimoEstado.diagnostico != .debeAutodiagnosticarse
            else {
                vista?.nuevoAutodiagnostico()
                return
        }
        
        if sesion.informacionDeUsuario?.ultimoEstado.permisosDeCirculacion?.count ?? 0 >= 1 {
            let factoria = FactoriaPasaporteViewModel(
                nombre: "\(informacionDeUsuario.nombres) \(informacionDeUsuario.apellidos)",
                dNI: "\(sesion.dni)",
                sube: "\(sesion.informacionDeUsuario?.ultimoEstado.permisosDeCirculacion?[0].sube ?? "")",
                patente: "\(sesion.informacionDeUsuario?.ultimoEstado.permisosDeCirculacion?[0].patente ?? "")",
                tokenDinamico: dependencias.tokenFachada.generarTokenDinamico(),
                provincia: "\(informacionDeUsuario.domicilio?.provincia ?? "")"
            )
            self.vista?.configurar(viewModel: factoria.crearModeloPara(tipo: tipoPasaporte))

        }else {
           let factoria = FactoriaPasaporteViewModel(
                nombre: "\(informacionDeUsuario.nombres) \(informacionDeUsuario.apellidos)",
                dNI: "\(sesion.dni)",
                sube: "\(sesion.informacionDeUsuario?.ultimoEstado.permisoDeCirculacion?.sube ?? "")",
                patente: "\(sesion.informacionDeUsuario?.ultimoEstado.permisoDeCirculacion?.patente ?? "")",
                tokenDinamico: dependencias.tokenFachada.generarTokenDinamico(),
                provincia: "\(informacionDeUsuario.domicilio?.provincia ?? "")"
            )
            self.vista?.configurar(viewModel: factoria.crearModeloPara(tipo: tipoPasaporte))
        }
    }
}

private extension Estado {
    func aceptar<V: VisitadorEstado>(visitor: V, aditionalInfo: V.AditionalInfo) -> V.Resultado {
        switch self.diagnostico {
        case .debeAutodiagnosticarse:
            return visitor.visitarDebeAutodiagnosticarse(aditionalInfo: aditionalInfo)
        case .derivadoASaludLocal:
            return visitor.visitarDerivadoALaSaludLocal(aditionalInfo: aditionalInfo)
        case .infectado:
            return visitor.visitarInfectado(aditionalInfo: aditionalInfo)
        case .noInfectado:
            return visitor.visitarNoInfectado(aditionalInfo: aditionalInfo)
        case .noContagioso:
            return visitor.visitarNoContagioso(aditionalInfo: aditionalInfo)
        }
    }
    
    func estaAislado() -> Bool {
        switch self.diagnostico {
        case .derivadoASaludLocal, .infectado:
            return true
        default:
            return false
        }
    }
}

private protocol VisitadorEstado {
    associatedtype Resultado
    associatedtype AditionalInfo
    
    func visitarDerivadoALaSaludLocal(aditionalInfo: AditionalInfo) -> Resultado
    func visitarInfectado(aditionalInfo: AditionalInfo) -> Resultado
    func visitarNoInfectado(aditionalInfo: AditionalInfo) -> Resultado
    func visitarNoContagioso(aditionalInfo: AditionalInfo) -> Resultado
    func visitarDebeAutodiagnosticarse(aditionalInfo: AditionalInfo) -> Resultado
}

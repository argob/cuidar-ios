//
//  FormularioDatosDeContactoPresentador.swift
//  CovidApp
//
//  Created on 4/9/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import Foundation
import UIKit

protocol FormularioDatosDeContactoPresentadorProtocolo {
    func recibirDato(dato: String, tipoDeElemento: TiposDeElementosDeFormulario)
    func siguienteFormulario()
    func presentarFormularioAnterior()
    func mostrarTablaOpciones(para campo: TiposDeElementosDeFormulario?)
    func recibirDatoPicker(dato: String, tipoDeElemento: TiposDeElementosDeFormulario)
}

extension MVPVista where Self: FormularioDatosDeContactoVista {
    func inyectar() -> FormularioDatosDeContactoPresentadorProtocolo {
        let presentador = FormularioDatosDeContactoPresentador()
        presentador.vista = self
        return presentador
    }
}

private final class FormularioDatosDeContactoPresentador: MVPPresentador {
    weak var vista: FormularioDatosDeContactoVista?
    
    
    let domicilioFachada: DomicilioFachadaProtolo = inyectar()
    let usuarioFachada: UsuarioFachadaProtocolo = inyectar()
    let notificacionFachada: NotificacionFachadaProtocolo = inyectar()

    var datos: String?
    var datosContacto: DatosDeContacto
    var etapaActual: AutenticacionVistasNavegacion = .confirmacionDni
    
    var elementosViewModels = Dictionary<TiposDeElementosDeFormulario, ElementoDeFormularioViewModel>()
    
    init() {
        datosContacto = DatosDeContacto(con: usuarioFachada.obtenerUltimaSession()?.informacionDeUsuario)
    }
    
}

extension FormularioDatosDeContactoPresentador: FormularioDatosDeContactoPresentadorProtocolo {
    func mostrarTablaOpciones(para campo: TiposDeElementosDeFormulario?) {
        guard let campo = campo else { return }
        let opciones = elementosViewModels[campo]?.datos ?? []
        vista?.mostrarPicker(con: opciones, identificador: campo)
    }
    
    func escenaCargo() {
        vista?.escenaCargo()
        siguienteFormulario()
    }

    func recibirDatoPicker(dato: String, tipoDeElemento: TiposDeElementosDeFormulario) {
        vista?.agregarValorAlCampo(dato, identifier: tipoDeElemento)
    }
    
    func recibirDato(dato: String, tipoDeElemento: TiposDeElementosDeFormulario) {
        var reglas: [Reglas]
        
        switch tipoDeElemento {
        case .ciudad, .provincia:
            reglas = [.noVacio]
        case .calle:
            reglas = [.noVacio, .longitudCalle]
        case .numero:
            reglas = [.noVacio, .longitudNumero]
        case .codigoPostal:
            reglas = [.noVacio, .longitudaCodigoPostal]
        case .puerta, .piso:
            reglas = [.longitudAlfanumerico20]
        case .otros:
            reglas = [.longitudAlfanumerico70]
        case .telefono:
            reglas = [.codigoPais, .noVacio, .telefonoValido]
        default:
            reglas = []
        }
        
        if tipoDeElemento == .provincia {
            actualizarCiudadesParaProvincia(nombreProvincia: dato)
        }
        
        let validador = FormularioValidador()
        let mensaje = validador.validar(texto: dato, con: reglas)
        
        if mensaje == nil {
            guardarDatos(dato: dato, tipoDeElemento: tipoDeElemento)
        } else {
            removerDato(tipoDeElemento: tipoDeElemento)
        }

        presentarMensajeEnFormulario(mensaje: mensaje, tipoDeElemento: tipoDeElemento)
        actualizarBoton()
    }
    
    func presentarMensajeEnFormulario(mensaje: String?, tipoDeElemento: TiposDeElementosDeFormulario) {
        guard var elementoViewModel = elementosViewModels[tipoDeElemento] else { return }
        elementoViewModel.textoBajoCampoDeTexto = mensaje ?? textoBajoCampoTextoPorDefectoPara(tipoDeElemento)
        elementoViewModel.tipografiaEtiquetaBajoTexto.color = mensaje == nil ? .black : .red
        
        vista?.presentarErrorEnFormulario(viewModel: elementoViewModel)
    }
    
    func actualizarCiudadesParaProvincia(nombreProvincia: String) {
        guard var ciudadViewModel = elementosViewModels[.ciudad] else { return }
        let ciudades = domicilioFachada.cargarCiudadDepartamentoParaProvincia(nombreProvincia)
        ciudadViewModel.textoParaCampoDeTexto = ""
        ciudadViewModel.datos = ciudades
        ciudadViewModel.habilitado = !ciudades.isEmpty
        elementosViewModels[.ciudad] = ciudadViewModel
        guardarDatos(dato: "", tipoDeElemento: .ciudad)
        vista?.recargarCampoCiudad(viewModel: ciudadViewModel)
    }
    
    func guardarDatos(dato: String, tipoDeElemento: TiposDeElementosDeFormulario) {
        switch tipoDeElemento {
        case .calle:
            datosContacto.calle = dato
        case .ciudad:
            datosContacto.localidad = dato
        case .numero:
            datosContacto.numero = dato
        case .provincia:
            datosContacto.provincia = dato
        case .codigoPostal:
            datosContacto.codigoPostal = dato
        case .telefono:
            datosContacto.telefono = dato
        case .piso:
            datosContacto.piso = dato
        case .puerta:
            datosContacto.puerta = dato
        case .otros:
            datosContacto.otros = dato
        default:
            break
        }
    }
    
    func removerDato(tipoDeElemento: TiposDeElementosDeFormulario) {
        switch tipoDeElemento {
        case .calle:
            datosContacto.calle = nil
        case .ciudad:
            datosContacto.localidad = nil
        case .numero:
            datosContacto.numero = nil
        case .provincia:
            datosContacto.provincia = nil
        case .codigoPostal:
            datosContacto.codigoPostal = nil
        case .telefono:
            datosContacto.telefono = nil
        case .piso:
            datosContacto.piso = nil
        case .puerta:
            datosContacto.puerta = nil
        case .otros:
            datosContacto.otros = nil
        default:
            break
        }
    }
    
    func siguienteFormulario() {
        elementosViewModels.removeAll()
        switch etapaActual {
        case .escanerDni:
            etapaActual = .confirmacionDni
            return
        case .confirmacionDni:
            etapaActual = .ingresoTelefono
            crearFormularioTelefono()
        case .ingresoTelefono:
            etapaActual = .ingresoDireccion
            crearFormularioDireccion()
            return
        case .ingresoDireccion:
            enviarDatosDeContacto()
            return
        case .ingresoManual:
            return
        }
    }
    
    func presentarFormularioAnterior() {
        etapaActual = .ingresoTelefono
        crearFormularioTelefono()
        vista?.habilitarSiguiente(colorFondo: Constantes.COLOR_HABILITADO)
    }
    
    func enviarDatosDeContacto() {
        
        guard
            let numero = datosContacto.numero,
            let calle = datosContacto.calle,
            let localidad = datosContacto.localidad,
            let provincia = datosContacto.provincia,
            let telefono = datosContacto.telefono,
            datosContacto.direccionEsValida(),
            !telefono.isEmpty
        else {
                return
        }
        vista?.mostrarLoaderAutenticacion()
        let domicilioEnFormulario = Domicilio(provincia: provincia,
                                              localidad: localidad,
                                              calle: calle,
                                              numero: numero,
                                              piso: datosContacto.piso,
                                              puerta: datosContacto.puerta,
                                              codigoPostal: datosContacto.codigoPostal,
                                              otros: datosContacto.otros)
        
        let domicilio = domicilioFachada.normalizar(domicilio: domicilioEnFormulario)
        usuarioFachada.registrarUsuario(
            domicilio: domicilio,
            telefono: telefono
        ) {  [weak self]  (respuesta) in
            self?.vista?.removerLoaderAutenticacion()
            if respuesta {
                self?.vista?.finalizoAutenticacion()
            } else {
                if (UserDefaults.standard.bool(forKey: Constantes.INVALID_TOKEN)) {
                    self?.notificacionFachada.desregistrarDispositivo()
                    self?.usuarioFachada.logout()
                    self?.vista?.alertAnotherDeviceLogged()
                } else {
                    self?.vista?.presentarErrorEnFormulario(mensaje: "usuario inválido")
                }
            }
        }
    }
    
}

private extension FormularioDatosDeContactoPresentador {
    
    private func textoBajoCampoTextoPorDefectoPara(_ tipo: TiposDeElementosDeFormulario) -> String {
        switch tipo {
        case .telefono:
            return "Código de área + Número"
        case .piso, .puerta, .otros:
            return "Opcional"
        default:
            return ""
        }
    }
    
    private func tipografiaCampoTextoPorDefecto() -> TipografíaViewModel {
        return TipografíaViewModel(fuente: UIFont.robotoRegular(tamaño: 18), color: .black)
    }
    
    private func tipografiaBajoCampoTextoPorDefecto() -> TipografíaViewModel {
        return TipografíaViewModel(fuente: UIFont.robotoRegular(tamaño: 13), color: .black)
    }
    
    // MARK: ViewModel formulario de teléfono
    func crearFormularioTelefono() {
        let elementoDeFormularioTelefono = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "+54 Número de teléfono",
            textoParaCampoDeTexto: datosContacto.telefono ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: textoBajoCampoTextoPorDefectoPara(.telefono),
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO,
            identificador: .telefono,
            tipoDeElemento: .sencillo,
            prefijoCampoDeTexto: "+54")
        elementosViewModels[.telefono] = elementoDeFormularioTelefono
        
        let viewModel = FormularioDatosDeContactoViewModel(
            tituloParaFormulario: "Teléfono de contacto",
            tamañoFuenteDescripcion: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_TAMAÑO_FUENTE_NORMAL,
            elementosDeFormulario: [elementoDeFormularioTelefono],
            botonSiguiente: .crearBotonAzul(titulo: "SIGUIENTE"))
        
        vista?.presentarFormularioTelefono(viewModel: viewModel)
        actualizarBoton()
    }
    
    // MARK: ViewModel formulario de dirección
    func crearFormularioDireccion() {
        let elementoProvincia = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Provincia",
            textoParaCampoDeTexto: datosContacto.provincia ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: "",
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO,
            identificador: .provincia,
            tipoDeElemento: .seleccionador,
            datos: domicilioFachada.cargarProvincias(),
            habilitado: false,
            editable: false)
        elementosViewModels[.provincia] = elementoProvincia
        
        let ciudades = domicilioFachada.cargarCiudadDepartamentoParaProvincia(datosContacto.provincia)
        let elementoCiudad = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Localidad - Departamento/Partido",
            textoParaCampoDeTexto: datosContacto.localidad ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: "",
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO,
            identificador: .ciudad,
            tipoDeElemento: .seleccionador,
            datos: ciudades,
            habilitado: !ciudades.isEmpty,
            editable: false)
        elementosViewModels[.ciudad] = elementoCiudad
        
        let elementoCalle = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Calle",
            textoParaCampoDeTexto: datosContacto.calle ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: "",
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO,
            identificador: .calle,
            tipoDeElemento: .sencillo)
            elementosViewModels[.calle] = elementoCalle
        
        let elementoNumero = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Número",
            textoParaCampoDeTexto: datosContacto.numero ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: "",
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_DOBLE,
            identificador: .numero,
            tipoDeElemento: .doble)
            elementosViewModels[.numero] = elementoNumero
        
        let elementoPostal = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Código Postal",
            textoParaCampoDeTexto: datosContacto.codigoPostal ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: "",
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_DOBLE,
            identificador: .codigoPostal,
            tipoDeElemento: .doble)
            elementosViewModels[.codigoPostal] = elementoPostal
        
        let elementoPuerta = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Puerta",
            textoParaCampoDeTexto: datosContacto.puerta ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: textoBajoCampoTextoPorDefectoPara(.puerta),
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_DOBLE,
            identificador: .puerta,
            tipoDeElemento: .doble)
            elementosViewModels[.puerta] = elementoPuerta
        
        let elementoPiso = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Piso",
            textoParaCampoDeTexto: datosContacto.piso ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: textoBajoCampoTextoPorDefectoPara(.piso),
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_DOBLE,
            identificador: .piso,
            tipoDeElemento: .doble)
            elementosViewModels[.piso] = elementoPiso
        
        let elementoOtros = ElementoDeFormularioViewModel(
            placeholderParaCampoDeTexto: "Otros",
            textoParaCampoDeTexto: datosContacto.otros ?? "",
            tipografiaCampoDeTexto: tipografiaCampoTextoPorDefecto(),
            textoBajoCampoDeTexto: textoBajoCampoTextoPorDefectoPara(.otros),
            tipografiaEtiquetaBajoTexto: tipografiaBajoCampoTextoPorDefecto(),
            metricaDeAltura: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO,
            metricaDeAncho: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO,
            identificador: .otros,
            tipoDeElemento: .sencillo)
            elementosViewModels[.otros] = elementoOtros
        
        let viewModel = FormularioDatosDeContactoViewModel(
            tituloParaFormulario: "Tu dirección actual",
            tamañoFuenteDescripcion: Constantes.FORMULARIO_DATOS_CONTACTO_PRESENTADOR_TAMAÑO_FUENTE_NORMAL,
            elementosDeFormulario: [elementoProvincia,
                                    elementoCiudad,
                                    elementoCalle,
                                    elementoNumero,
                                    elementoPostal,
                                    elementoPiso,
                                    elementoPuerta,
                                    elementoOtros],
            botonSiguiente: .crearBotonAzul(titulo: "FINALIZAR"))
        vista?.presentarFormularioDireccion(viewModel: viewModel)
        actualizarBoton()
    }

    func actualizarBoton() {
        let habilitarSiguienteParaTelefono = (etapaActual == .ingresoTelefono) && datosContacto.telefono != nil
        let habilitarSiguienteParaDireccion = (etapaActual == .ingresoDireccion) && datosContacto.direccionEsValida() && datosContacto.validarCamposOpcionales()

        if habilitarSiguienteParaTelefono || habilitarSiguienteParaDireccion {
            vista?.habilitarSiguiente(colorFondo: Constantes.COLOR_HABILITADO)
        } else {
            vista?.deshabilitarSiguiente(colorFondo: Constantes.COLOR_DESHABILITADO)
        }
    }
}

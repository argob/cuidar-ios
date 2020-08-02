//
//  FormularioDatosPersonalesPresentador.swift
//  CovidApp
//
//  Created on 4/10/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol FormularioDatosPersonalesPresentadorProtocolo {
    func manejarAccionSiguiente()
    func mostrarComoObtenerNumeroDeTramite()
    func recibir(identificador: TiposDeElementosDeFormulario, valor: String?)
}

extension MVPVista where Self: FormularioDatosPersonalesVista {
    func inyectar() -> FormularioDatosPersonalesPresentadorProtocolo {
        let presentador = FormularioDatosPersonalesPresentador()
        presentador.vista = self
        return presentador
    }
}

private extension TiposDeElementosDeFormulario {
    static let ingresoManualCasos: [TiposDeElementosDeFormulario] = [.dni, .tramite, .genero]
}

private final class FormularioDatosPersonalesPresentador: MVPPresentador {
    weak var vista: FormularioDatosPersonalesVista?
    
    private let usuarioFachada: UsuarioFachadaProtocolo
    private let validador: FormularioValidador
    private var camposCompletados: [TiposDeElementosDeFormulario: String] = [:]
    private lazy var accionDeRecibir: (TiposDeElementosDeFormulario, String?) -> Void = { [weak self] (id, valor) in
        self?.recibir(identificador: id, valor: valor)
    }
    
    init(validador: FormularioValidador = .init(),
         usuarioFachada: UsuarioFachadaProtocolo = inyectar()) {
        self.validador = validador
        self.usuarioFachada = usuarioFachada
    }
    
    func recibir(identificador: TiposDeElementosDeFormulario, valor: String?) {
        guard let valor = valor else {
            return
        }

        var reglas: [Reglas]

        switch identificador {
        case .dni:
            reglas = [.noVacio, .soloNumeros, .longitudDNI]
        case .tramite:
            reglas = [.noVacio, .longitudNumeroTramite]
        case .genero:
            reglas = [.noVacio]
        default:
            reglas = []
        }
        
        if let error = validador.validar(texto: valor, con: reglas) {
            remover(identificador: identificador, mensaje: error)
        } else {
            procesar(identificador: identificador, valor: valor)
        }
    }
    
    func remover(identificador: TiposDeElementosDeFormulario, mensaje: String) {
        vista?.mostrarError(identificador: identificador, mensaje: mensaje)
        vista?.deshabilitarSiguiente(colorFondo: Constantes.COLOR_DESHABILITADO)
        camposCompletados.removeValue(forKey: identificador)
    }
    
    func procesar(identificador: TiposDeElementosDeFormulario, valor: String?) {
        vista?.removerError(identificador: identificador)
        camposCompletados[identificador] = valor
        
        let camposCompletados = Set(self.camposCompletados.keys)
        if TiposDeElementosDeFormulario.ingresoManualCasos.allSatisfy(camposCompletados.contains) {
            vista?.habilitarSiguiente(colorFondo: Constantes.COLOR_HABILITADO)
        } else {
            vista?.deshabilitarSiguiente(colorFondo: Constantes.COLOR_DESHABILITADO)
        }
    }
}

extension FormularioDatosPersonalesPresentador: FormularioDatosPersonalesPresentadorProtocolo {
    func escenaCargo() {
        vista?.configurar(viewModel: crearViewModel())
        vista?.deshabilitarSiguiente(colorFondo: Constantes.COLOR_DESHABILITADO)
    }
    
    func escenaAparecera() {
        vista?.definirTamaños()
    }
    
    func manejarAccionSiguiente() {
        guard
            let dni = Int(camposCompletados[.dni] ?? ""),
            let tramite = Int(camposCompletados[.tramite] ?? ""),
            let genero = camposCompletados[.genero],
            let sexo = Usuario.Sexo(rawValue: genero)
        else {
            return
        }
        vista?.mostrarLoaderAutenticacion()
        usuarioFachada.validarRegistro(dni: dni, noTramite: tramite, sexo: sexo) { [weak self] (estadoDelRegistro) in
            self?.vista?.removerLoaderAutenticacion()
            switch estadoDelRegistro {
            case let .habilitadoParaSerRegistrado(informacion):
                self?.vista?.enviarInformacionUsuario(modelo: .init(fechaNacimiento: informacion.fechaDeNacimiento))
                self?.vista?.irALaProximaSeccion()
            case let .usuarioYaRegistrado(informacion):
                self?.vista?.enviarInformacionUsuario(modelo: .init(fechaNacimiento: informacion.fechaDeNacimiento))
                self?.vista?.autenticacionTerminada()
                break
            case .invalido:
                self?.vista?.mostrarErrorDNI(con: 100)
                break
            }
        }
    }
    
    func mostrarComoObtenerNumeroDeTramite() {
        vista?.mostrarComoObtenerNumero()
    }
}

private extension FormularioDatosPersonalesPresentador {
    func crearViewModelTitulo(fuente: UIFont) -> DatosPersonalesEtiquetaViewModel {
        return DatosPersonalesEtiquetaViewModel(texto: "Para empezar necesitamos tus datos personales",
                                                color: .black,
                                                alineacion: .left,
                                                font: fuente)
    }
    
    func crearViewModelEtiqueta(texto: String, fuente: UIFont) -> DatosPersonalesEtiquetaViewModel {
        return DatosPersonalesEtiquetaViewModel(texto: texto,
                                                color: .gray,
                                                font: fuente)
    }
    
    func crearCampoTexto(placeholder: String, identificador: TiposDeElementosDeFormulario) -> ElementoDeFormularioViewModel {
        let fuenteGeneral: UIFont = .robotoRegular(tamaño: 17)
        let fuenteEnlace: UIFont = .robotoRegular(tamaño: 12)
        return ElementoDeFormularioViewModel(placeholderParaCampoDeTexto: placeholder,
                                             textoParaCampoDeTexto: "",
                                             tipografiaCampoDeTexto: .init(fuente: fuenteGeneral, color: .black),
                                             textoBajoCampoDeTexto: "",
                                             tipografiaEtiquetaBajoTexto: .init(fuente: fuenteEnlace, color: .rojoPrimario),
                                             metricaDeAltura: 60, metricaDeAncho: 0,
                                             identificador: identificador,
                                             tipoDeElemento: .sencillo,
                                             tipoTeclado: .numberPad)
    }
    
    func crearViewModelEtiquetaInstrucciones(fuente: UIFont) -> ObterNumeroDeTramiteBotonViewModel {
        let buttonViewModel = BotonViewModel(titulos: [.normal(valor: "¿Cómo obtengo mi número de trámite?")],
                                             apariencia: .init(tituloFuente: fuente, tituloColores: [.normal(valor: .grisFuerte)],subrayado: true),
                                             estaEscondido: false)
        
        return ObterNumeroDeTramiteBotonViewModel(boton: buttonViewModel) { [weak self] in
            self?.mostrarComoObtenerNumeroDeTramite()
        }
    }
    
    func crearViewModel() -> DatosPersonalesViewModel {
        let fuenteTitulo: UIFont = .robotoBold(tamaño: 20)
        let fuenteGeneral: UIFont = .robotoRegular(tamaño: 17)
        let fuenteEnlace: UIFont = .robotoRegular(tamaño: 12)
        
        let titulo = crearViewModelTitulo(fuente: fuenteTitulo)
        
        let etiquetaDNI = crearViewModelEtiqueta(texto: "DNI:", fuente: fuenteGeneral)
        
        let campoDNI = crearCampoTexto(placeholder: "DNI", identificador: .dni)
        
        let etiquetaTramite = crearViewModelEtiqueta(texto: "Nro Trámite:", fuente: fuenteGeneral)
        
        let campoTramite = crearCampoTexto(placeholder: "Nro Trámite", identificador: .tramite)
        
        let etiquetaInstruccionesTramite = crearViewModelEtiquetaInstrucciones(fuente: fuenteEnlace)
            
        let campoGenero = RadioGroupViewModel(textoOpcion1: "Femenino",
                                              textoOpcion2: "Masculino",
                                              valorOpcion1: Usuario.Sexo.mujer.rawValue,
                                              valorOpcion2: Usuario.Sexo.hombre.rawValue,
                                              identificador: .genero,
                                              accion: accionDeRecibir)
        
        var botonSiguiente: BotonViewModelAccion = .crearBotonAzul(titulo: "SIGUIENTE") { [weak self] in
            self?.manejarAccionSiguiente()
        }
        botonSiguiente.estaHabilitado = false
        return DatosPersonalesViewModel(titulo: titulo,
                                        proteccionInfo: .init(texto: "Tu información está protegida por la ley y es para uso exclusivo de las autoridades sanitarias.", color: .gray, font: .robotoRegular(tamaño: 14)),
                                        etiquetaDNI: etiquetaDNI,
                                        campoDNI: campoDNI,
                                        etiquetaTramite: etiquetaTramite,
                                        campoTramite: campoTramite,
                                        etiquetaInstruccionesNumeroTramite: etiquetaInstruccionesTramite,
                                        campoGenero: campoGenero, mensajeError: .init(mensaje: "Por favor, verificar los datos ingresados", imagen: "icon-error-dni", estaHabilitado: false, fuente: .robotoRegular(tamaño: 14)), botonSiguiente: botonSiguiente)
    }
}

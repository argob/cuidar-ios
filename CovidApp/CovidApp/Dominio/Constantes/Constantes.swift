//
//  Constantes.swift
//  CovidApp
//
//  Created on 5/27/20.
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import Foundation
import WebKit

struct Constantes {
    
    
    // MARK: - COEPS
    static let COEP_CABA = "Ciudad Autónoma de Buenos Aires" //<--- debe coincidir con los servicios COEPS

    // MARK: - COLOR
    static let COLOR_DESHABILITADO: UIColor = .grisPrincipal
    static let COLOR_HABILITADO: UIColor = .azulPrincipal
    static let COLOR_HABILITADO_MANUAL: UIColor = .white

    // MARK: - ASSETS
    static let BOTON_NO_CHEQUEADO = UIImage(named: "boton-no-chequeado")
    static let BOTON_CHEQUEADO = UIImage(named: "boton-chequeado")
    static let CAJA_NO_CHEQUEADA = UIImage(named: "caja-no-chequeada")
    static let CAJA_CHEQUEADA = UIImage(named: "caja-chequeada")

    // MARK: - TOKEN
    static let TOKEN_TIME_INTERVAL = 1500
    static let TOKEN_DIGITS = 8
    
    // MARK: - TERMINO Y CONDICIONES
    static let TERMINOS_Y_CONDICIONES_FILE_NAME = "Términos y Condiciones - CoronApp V5"
    static let FILE_TYPE = "docx"
    
    // MARK: - TERMINO
    static let TERMINO_ANCHO_BOTON: CGFloat = 40.0
    static let TERMINO_ESPACIO: CGFloat = 20.0
    static let TERMINO_TITULO_TERMINOS = "Términos y Condiciones"
    
    // MARK: - LEGALES
    static let LEGALES_TAG = 10001
    static let LEGALES_VISTA_ACEPTAR_ALTO:CGFloat = 250
    static let LEGALES_VISTA_ACEPTAR_OFFSET:CGFloat = 10
    static let haAbiertoLaAppAntesKey = "com.covidapp.haAbiertoLaAppAntesKey"
    static let LEGAL_DELTA = "com.covidapp.TYCDelta"
    static let LEGAL_VERSION = "com.covidapp.TYCVersion"
    static let LEGAL_CANCEL_ALERT = "Si no acepta los Términos y Condiciones no podrá seguir usando CuidAr"

    // MARK: - DOMICILIO
    static let DOMICILIO_ARCHIVO_DE_PROVINCIAS = "Provincias.json"
    static let DOMICILIO_ARCHIVO_DE_CIUDADES = "Ciudades.json"
    
    
    // MARK: - PANTALLA DE CARGA
    static let LOAD_PAGE_BACKGROUND_COLOR = UIColor.black.withAlphaComponent(0.4)
    static let LOAD_PAGE_BACKGROUND_SQUARE_COLOR =  UIColor(red: 68 / 255, green: 68 / 255, blue: 68 / 255, alpha: 0.7)
    static let LOAD_PAGE_ACTIVITY_INDICATOR_SIZE: CGFloat = 40
    static let LOAD_PAGE_SQUARE_SIZE: CGFloat = 80
    static let LOAD_PAGE_RADIO_SIZE: CGFloat = 10
    
    // MARK: - TABLA OPCIONES VISTA
    static let TABLA_OPCIONES_VISTA_CELDA_OPCION = "celdaOpcion"
    static let TABLA_OPCIONES_VISTA_PLACEHOLDER = "Escribe la Ciudad/Provincia"
    static let TABLA_OPCIONES_VISTA_ALTURA_ITEMS: CGFloat = 44.0
    static let TABLA_OPCIONES_VISTA_CANCELAR = "Cancelar"
    static let TABLA_OPCIONES_VISTA_ESPACIO_CANCELAR: CGFloat = 85.0
    
    // MARK: - CONTENEDOR MENU LATERAL
    static let CONTENEDOR_MENU_LATERAL_CELL_ID = "cell"
   
    // MARK: - CONFIRMACION PRESENTADOR
    static let CONFIRMACION_PRESENTADOR_TITULO: LabelAppearance = .init(fuente: .robotoMedium(tamaño: 18), colorTexto: .grisPrincipal)
    static let CONFIRMACION_PRESENTADOR_ETIQUETA: LabelAppearance = .init(fuente: .robotoBold(tamaño: 16), colorTexto: .grisPrincipal)
    static let CONFIRMACION_PRESENTADOR_VALOR: LabelAppearance = .init(fuente: .robotoRegular(tamaño: 16), colorTexto: .grisPrincipal)
       
    // MARK: - FORMULARIO DATOS CONTACTO PRESENTADOR
    static let FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ALTURA_ELEMENTO: Int = 60
    static let FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_DOBLE: Int = 180
    static let FORMULARIO_DATOS_CONTACTO_PRESENTADOR_ANCHO_ELEMENTO_FORMULARIO_SENSILLO: Int = 0
    static let FORMULARIO_DATOS_CONTACTO_PRESENTADOR_TAMAÑO_FUENTE_NORMAL: CGFloat = 18
    
    // MARK: - ESCANER VIEW CONTROLLER
    static let ESCANER_VIEW_CONTROLLER_ALTO_HD: CGFloat = 720.0
    static let ESCANER_VIEW_CONTROLLER_ANCHO_HD: CGFloat = 1280.0
    static let ESCANER_VIEW_CONTROLLER_ALTO_FHD: CGFloat = 1080.0
    static let ESCANER_VIEW_CONTROLLER_ANCHO_FHD: CGFloat = 1920.0
    
    
    // MARK: - AUTOEVALUACION PRESENTADOR
    static let AUTOEVALUACION_PRESENTADOR_SINTOMAS_MINIMOS = 3
    static let AUTOEVALUACION_PRESENTADOR_VALOR_MAXIMO_TEMPERATURA_HUMANA: Double = 42.0
    static let AUTOEVALUACION_PRESENTADOR_VALOR_MINIMO_TEMPERATURA_HUMANA: Double = 34.0
    static let AUTOEVALUACION_PRESENTADOR_TEMPERATURA_DEFAULT: Double = 37
    static let AUTOEVALUACION_PRESENTADOR_VALOR_DE_PASO_TEMPERATURA = 0.1
    static let AUTOEVALUACION_PRESENTADOR_MAXIMO_CARACTERES: Int = 4
    static let AUTOEVALUACION_PRESENTADOR_MAXIMO_ENTEROS: Int = 2
    static let AUTOEVALUACION_PRESENTADOR_SEPARADOR: String = ","
    static let AUTOEVALUACION_PRESENTADOR_FORMATO_TEMPERATURA = "%.1f"
    
    static let INVALID_TOKEN = "invalidToken"
    static let ANOTHER_DEVICE_LOGGED = "Para continuar es necesario que vuelvas a ingresar tu DNI. Puede deberse a que hayas ingresado a Cuidar desde otro dispositivo o un control de seguridad periódico"
    
    // MARK: - CONSEJOS
    static let CONSEJOS_URL = Keys.STATIC_WEB + "consejos/"
    static let CONSEJOS_CANTIDAD_DISPONIBLES = CONSEJOS_URL + "index.json"
}

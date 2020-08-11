//
//  AutoevaluacionPresenter.swift
//  CovidApp
//
//  Created on 8/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol AutoevaluacionPresentadorProtocolo: UbicacionFachadaDelegado {
    func siguiente()
    func atras()
    func volverAEmpezar()
    func usuarioAceptoAlertaDeTemperaturaFueraDeRango(reiniciarValorInicial: Bool)
    func alertaAceptada()
    func actualizarCajaSeleccionable(elemento: AutoevaluacionItemViewModel, valor: Bool) -> AutoevaluacionItemViewModel?
}

extension MVPVista where Self: AutoevaluacionVista {
    func inyectar() -> AutoevaluacionPresentadorProtocolo {
        let presentador = AutoevaluacionPresentador()
        presentador.vista = self
        return presentador
    }
}

private final class AutoevaluacionPresentador: MVPPresentador {
    
    var autoevaluacionFachada: AutoevaluacionFachadaProtocolo = inyectar()
    var ubicacionFachada: UbicacionFachadaProtocolo = inyectar()
    
    private typealias `Self` = AutoevaluacionPresentador
    private typealias GeneracionDeContenido = (Bool) -> Void
    private typealias ComandosDeGeneracionDeContedido = (AutoevaluacionPresentador) -> GeneracionDeContenido
    
    private var pasoActual: Int = 0
    private var comandosDeContenido: [ComandosDeGeneracionDeContedido] = [
        Self.generarContenidoParaTemperatura,
        Self.generarContenidoParaSintomas,
        Self.generarContenidoAntecedentes,
        Self.generarResumen
    ]
    
    private var temperaturaSeleccionada = Constantes.AUTOEVALUACION_PRESENTADOR_TEMPERATURA_DEFAULT
    private var sintomaSeleccionados: [String: ItemAutoevaluado] = [:]
    private var antecendentesSeleccionados: [String: ItemAutoevaluado] = [:]

    weak var vista: AutoevaluacionVista?
    
    init() {
        self.ubicacionFachada.delegado = self
    }
}

extension AutoevaluacionPresentador: AutoevaluacionPresentadorProtocolo {
    func actualizarCajaSeleccionable(elemento: AutoevaluacionItemViewModel, valor: Bool) -> AutoevaluacionItemViewModel? {
        guard var elementoActualizado = elemento as? AutoevaluacionCajaSeleccionableViewModel else {
            return nil
        }
        elementoActualizado.valor = valor
        return elementoActualizado
    }
    
    func escenaCargo() {
        vista?.configurarVista(viewModel: crearVistaGeneralViewModel())
        vista?.configurarBarraDeProgreso(pasos: comandosDeContenido.count, pasoActual: 1)
        pasoActual = 0
        generarContenidoParaPasoActual(refrescar: true)
        formatearAccionParaPasoActual()
        autoevaluacionFachada.agregarAutoevaluacion(
            indicadores: .init(temperatura: Constantes.AUTOEVALUACION_PRESENTADOR_TEMPERATURA_DEFAULT))
    }
    
    func escenaAparecera() {
        vista?.configurarBarraNavegacion(viewModel: .autoevaluacion)
    }
    
    func siguiente() {
        guard pasoActual < comandosDeContenido.count - 1 else {
            self.vista?.mostrarAlertaDeEnviarDatos(contenido: self.generaAlertaDeclaracionJuramentada())
            return
        }
        
        pasoActual += 1
        vista?.actualizarBarraDeProgreso(direccion: .siguiente)
        generarContenidoParaPasoActual(refrescar: true)
        formatearAccionParaPasoActual()
    }
    
    func atras() {
        guard pasoActual > 0 else {
            vista?.irAEscenaPrevia()
            return
        }
        pasoActual -= 1
        vista?.actualizarBarraDeProgreso(direccion: .anterior)
        vista?.habilitarBotonSiguiente()
        generarContenidoParaPasoActual(refrescar: true)
        formatearAccionParaPasoActual()
    }
    
    func volverAEmpezar() {
       pasoActual = 0
       vista?.actualizarBarraDeProgreso(direccion: .primerPaso)
       vista?.habilitarBotonSiguiente()
       generarContenidoParaPasoActual(refrescar: true)
       formatearAccionParaPasoActual()
    }


    func alertaAceptada() {
        vista?.mostrarLoader()
        autoevaluacionFachada.agregarAutoevaluacion(sintomas: sintomaSeleccionados.map { $1 })
        autoevaluacionFachada.agregarAutoevaluacion(antecedentes: antecendentesSeleccionados.map { $1 })
        if autoevaluacionFachada.tieneSintomasCompatibles() {
            // Se solicita la ubicación en caso de tener síntomas compatibles para poder derivar al ciudadano al Centro de Salud más cercano. Este es el único lugar y momento donde se le requiere la ubicación al usuario.
            ubicacionFachada.solicitarPermisos()
            vista?.mostrarLoader()
        } else {
            terminarAutoEvaluacion()
        }
    }
    
    func terminarAutoEvaluacion() {
        autoevaluacionFachada.terminarAutoevaluacion { [weak self] (estado) in
            guard let self = self else { return }
            self.vista?.ocultarLoader()
            switch estado {
            case .success:
                self.vista?.irASiguienteEscena()
            case .failure(let error) where error == .sinConexionAInternet:
                let viewModel = AlertaErrorEjecutarClienteViewModel.crearAlertaDeConexion { [weak self] in
                    self?.alertaAceptada()
                }
                self.vista?.mostrarAlertaDeErrorAlSalvarDatos(viewModel: viewModel)
            case .failure(let error) where error == .tokenInvalido:
                self.vista?.showAlertInvalidToken()
            case .failure:
                let viewModel = AlertaErrorEjecutarClienteViewModel.crearAlertaReintentable(mensaje: "Algo inesperado ha ocurrido") { [weak self] in
                    self?.alertaAceptada()
                }
                self.vista?.mostrarAlertaDeErrorAlSalvarDatos(viewModel: viewModel)
            }
        }
    }
    
    func usuarioAceptoAlertaDeTemperaturaFueraDeRango(reiniciarValorInicial: Bool) {
        if reiniciarValorInicial {
            temperaturaSeleccionada = Constantes.AUTOEVALUACION_PRESENTADOR_TEMPERATURA_DEFAULT
            generarContenidoParaPasoActual(refrescar: true)
        }
    }
}

private extension AutoevaluacionPresentador {
    func generarContenidoParaPasoActual(refrescar: Bool) {
        let comandoParaGenerarContenido = comandosDeContenido[pasoActual](self)
        comandoParaGenerarContenido(refrescar)
    }
    
    func generarContenidoParaTemperatura(refrescar: Bool) {
        sintomaSeleccionados.removeAll()
        autoevaluacionFachada.listarConsejosTemperatura { [weak self] (consejos) in
            guard let self = self else { return }
            let items = self.formatearTemperatura(consejos: consejos, valorInicial: self.temperaturaSeleccionada)
            self.vista?.configurar(items: items, refrescar: refrescar)
        }
    }

    func generarContenidoParaSintomas(refrescar: Bool) {
        antecendentesSeleccionados.removeAll()
        autoevaluacionFachada.listarSintomas { [weak self] (sintomas) in
            guard let self = self else { return }
            let sintomasSinResponder = sintomas.reduce(into: [:]) { $0[$1.id] = ItemAutoevaluado(item: $1, valor: false) }
            self.sintomaSeleccionados = self.sintomaSeleccionados.merging(sintomasSinResponder) { (lhs, rhs) in return lhs }
            let items = self.formatear(sintomas: sintomas)
            self.vista?.configurar(items: items, refrescar: refrescar)
        }
        evaluarBotonSiguienteParaSintomas()
    }
    
    func generarResumen(refrescar: Bool) {
        let items = self.formatearResumen()
        
        self.vista?.configurar(items: items, refrescar: refrescar)
    }

    func generarContenidoAntecedentes(refrescar: Bool) {
        autoevaluacionFachada.listarAntecedentes { [weak self] (antecedentes) in
            guard let self = self else { return }
            let antecedentesSinResponder = antecedentes.reduce(into: [:]) { $0[$1.id] = ItemAutoevaluado(item: $1, valor: false) }
            self.antecendentesSeleccionados = self.antecendentesSeleccionados.merging(antecedentesSinResponder) { (lhs, rhs) in return lhs }
            let items = self.formatear(antecedentes: antecedentes)
            self.vista?.configurar(items: items, refrescar: refrescar)
        }
    }
    
    func generaAlertaDeclaracionJuramentada() -> AlertaViewModel {
        return .init(
            titulo: "COVID19 -\nMinisterio de Salud ",
            mensaje: "Este formulario tiene carácter de declaración jurada, hacer una falsa declaración puede considerarse una contravención grave.",
            tituloCancelar: "CANCELAR",
            tituloAceptar: "ENVIAR"
        )
    }
    
    func generaAlertDeTemperaturaAnormal() -> AlertaViewModel {
        return .init(
            titulo: "COVID19 -\nMinisterio de Salud ",
            mensaje: "Por favor ingrese una temperatura válida.",
            tituloCancelar: "CANCELAR",
            tituloAceptar: "ACEPTAR"
        )
    }
}

private extension AutoevaluacionPresentador {
    
    func formatearAccionParaPasoActual() {
        if pasoActual == comandosDeContenido.count - 1 {
            vista?.actualizar(tituloDeAccion: "CONFIRMAR")
        } else {
            vista?.actualizar(tituloDeAccion: "SIGUIENTE")
        }
        vista?.actualizarBotonBack(visible: pasoActual != 0)
    }
    
    func formatearTemperatura(consejos: [ItemAutoevaluable], valorInicial: Double) -> [AutoevaluacionItemViewModel] {
        return [
            creaTextConLogoViewModel(texto: "Realizá el autodiagnóstico para ayudarte a determinar los pasos a seguir según tus síntomas y factores de riesgo. Recordá que un autodiagnóstico sin síntomas asociados al COVID-19 dura 48 hs, y que podés volver a realizarlo cuando lo consideres necesario.",
                                     textFont: MetricasTemperatura.fuenteRecordatorio,
                                    colorDeFondo: MetricasTemperatura.colorDeFondoCabecera,
                                    logo: MetricasTemperatura.imagenDeCabecera),
            creaTextBasicoViewModel(texto: "¿Cuál es tu temperatura\ncorporal actual?",
                                    textFont: Metricas.fuenteNegritaRegular,
                                    margenes: MetricasTemperatura.margenesPreguntaTemperatura),
            creaIncrementalDecrementalViewModel(valorInicial: valorInicial) { [weak self] valor, vieneDeTextField in
                self?.accionDeTemperatura(para: valor, reiniciarValorInicial: vieneDeTextField)
            },
            creaTextBasicoViewModel(texto: "Consejos para medir la temperatura",
                                    textFont: MetricasTemperatura.fuenteTituloConsejosCortos,
                                    margenes: MetricasTemperatura.margenesTituloConsejosCortos),
        ] + consejos.prefix(upTo: Constantes.AUTOEVALUACION_PRESENTADOR_SINTOMAS_MINIMOS) .enumerated().map {
            creaTextoEnumeradoViewModel(texto: $1.descripcionDelUsuario, numero: $0 + 1, margenes: Metricas.margenesBasicos)
        } + [
            creaLinkViewModel(texto: "Más información") { [weak self] in
                self?.formatearConsejosDetallados()
            }
        ]
    }
    
    func formatearResumen() -> [AutoevaluacionItemViewModel] {
        let title = creaTextBasicoViewModel(
                    texto: "Resumen de autodiagnóstico",
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .center,
                    margenes:  MetricasSintomas.margenesTituloPregunta)

        let temperatura = creaTextBasicoViewModel(texto: "Mi temperatura es: " + String(format:"%.1f",temperaturaSeleccionada),
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .left,
                    margenes:  MetricasSintomas.margenesTituloPregunta)

        var sintomas = creaTextBasicoViewModel(texto: "No poseo ningún síntoma",
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .left,
                    margenes:  MetricasSintomas.margenesTituloPregunta)
        
        if hayRegistros(items: sintomaSeleccionados) {
            sintomas = creaTextBasicoViewModel(texto: "Mis síntomas son: \n\t" + formatearItemResumen(items: sintomaSeleccionados),
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .left,
                    margenes:  MetricasSintomas.margenesTituloPregunta)
        }
        var antecedentes = creaTextBasicoViewModel(texto: "No poseo ninguna enfermedad previa",
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .left,
                    margenes:  MetricasSintomas.margenesTituloPregunta)
        
        if hayRegistros(items: antecendentesSeleccionados) {
         antecedentes = creaTextBasicoViewModel(texto: "Mis antecedentes son: \n\t" + formatearItemResumen(items: antecendentesSeleccionados),
                    textFont: Metricas.fuenteNegritaRegular,
                    alineacionDeTexto: .left,
                    margenes:  MetricasSintomas.margenesTituloPregunta)
        }
        
        let volver = creaBotonVolver(identificador: .volverAEmpezar, titulo: "Volver a empezar")

        return [title] + [temperatura] + [sintomas] + [antecedentes] + [volver]

    }
    func hayRegistros(items :[String: ItemAutoevaluado]) -> Bool {
        for item in items{
            if (item.value.getValor()) {
                return true
            }
        }
        return false
    }
    
    func formatearItemResumen(items :[String: ItemAutoevaluado]) -> String {
        var itemsFormateados : String = ""
        for item in items {
            if item.value.getValor() {
                if itemsFormateados.isEmpty {
                    itemsFormateados = "• "+item.value.descripcion
                }else {
                    itemsFormateados = itemsFormateados + "\n\t• " + item.value.descripcion
                }
            }
        }
        return itemsFormateados
    }

    func formatear(sintomas: [ItemAutoevaluable]) -> [AutoevaluacionItemViewModel] {
        return sintomas.flatMap { sintoma in
            [creaTextBasicoViewModel(texto: sintoma.descripcionDelUsuario,
                                     textFont: Metricas.fuenteNegritaRegular,
                                     alineacionDeTexto: .left,
                                     margenes:  MetricasSintomas.margenesTituloPregunta),
             creaPreguntaViewModel(identificador: sintoma.id,
                                   afirmativo: "SÍ",
                                   negativo: "NO",
                                   valor: sintomaSeleccionados[sintoma.id]?.valor?.boolValue)
             { [weak self] seleccion in
                self?.sintomaSeleccionados[sintoma.id]?.set(valor: seleccion)
                self?.generarContenidoParaPasoActual(refrescar: false)
                self?.evaluarBotonSiguienteParaSintomas()
            }]
        }
    }
    
    func formatear(antecedentes: [ItemAutoevaluable]) -> [AutoevaluacionItemViewModel] {
        let title = creaTextBasicoViewModel(
            texto: "Si tu situación de salud contempla alguna de las siguientes opciones, seleccioná las que correspondan",
            textFont: Metricas.fuenteNegritaRegular,
            alineacionDeTexto: .left
        )
        return [title] + antecedentes.map { antecedente in
            creaCajaSeleccionableViewModel(
                identificador: antecedente.id,
                texto: antecedente.descripcionDelUsuario,
                valor: antecendentesSeleccionados[antecedente.id]?.valor?.boolValue ?? false)
            { [weak self] seleccion, celda in
                self?.antecendentesSeleccionados[antecedente.id]?.set(valor: seleccion)
                self?.generarContenidoParaPasoActual(refrescar: false)
            }
        }
    }
    
    func formatearConsejosDetallados()  {
        autoevaluacionFachada.listarConsejosTemperatura { [weak self] (consejos) in
            guard let self = self else { return }
            let items: [AutoevaluacionItemViewModel] = [
                self.creaTextBasicoViewModel(texto: "Consejos para medir la temperatura",
                                             textFont: MetricasTemperatura.fuenteConsejos,
                                             alineacionDeTexto: .left)
            ] + consejos.enumerated().map {
                self.creaTextoEnumeradoViewModel(
                    texto: $1.descripcionDelUsuario,
                    numero: $0 + 1,
                    margenes: MetricasTemperatura.margenesPuntosDetallados
                )
            }
            self.vista?.mostrarDetalle(items: items)
        }
    }
}

private extension AutoevaluacionPresentador {
    
    private struct MetricasTemperatura {
        static let colorDeFondoCabecera: UIColor = .grisSecundario
        static let imagenDeCabecera: UIImage! = UIImage(named: "icon-diagnostico")?.withRenderingMode(.alwaysTemplate)
        static let fuenteDeCabecera: UIFont = .robotoBold(tamaño: 20)
        static let fuenteTituloConsejosCortos: UIFont = .robotoMedium(tamaño: 16)
        static let fuenteRecordatorio: UIFont =  .robotoRegular(tamaño: 14)
        static let fuenteConsejos: UIFont =  .robotoMedium(tamaño: 20)
        static let fuenteLink: UIFont = .robotoRegular(tamaño: 14)
        static let fuenteSelectorTemperatura: UIFont = .robotoBold(tamaño: 28)
        static let margenesIncrementalDecremental = UIEdgeInsets(top: 3, left: 35, bottom: 18, right: 35)
        static let margenesDeCabecera: UIEdgeInsets = UIEdgeInsets(top: 20, left: 35, bottom: 20, right: 35)
        static let margenesPuntosDetallados: UIEdgeInsets = UIEdgeInsets(top: 23, left: 35, bottom: 5, right: 35)
        static let margenesPreguntaTemperatura = UIEdgeInsets(top: 25, left: 35, bottom: 22, right: 35)
        static let margenesTituloConsejosCortos = UIEdgeInsets(top: 22, left: 35, bottom: 22, right: 35)
    }
    
    private struct MetricasSintomas {
        static let margenesTituloPregunta: UIEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 31, right: 35)
        static let margenesPreguntas: UIEdgeInsets = UIEdgeInsets(top: 1, left: 35, bottom: 45, right: 35)
        static let fuenteSintomas: UIFont = .robotoRegular(tamaño: 14)
    }
    
    private struct MetricasAntecedentes {
        static let margenesCajaDeSeleccion: UIEdgeInsets = UIEdgeInsets(top: 17, left: 35, bottom: 17, right: 35)
        static let fuenteAntecedentes: UIFont = .robotoRegular(tamaño: 16)
    }
    
    private struct Metricas {
        static let fuenteNegritaRegular: UIFont =  .robotoMedium(tamaño: 18)
        static let fuentNegrita: UIFont = .robotoMedium(tamaño: 16)
        static let fuenteNumerica: UIFont = .robotoBold(tamaño: 14)
        static let fuenteRegular: UIFont = .robotoRegular(tamaño: 12)
        static let margenesBasicos: UIEdgeInsets = UIEdgeInsets(top: 8, left: 35, bottom: 8, right: 35)
    }
    
    func crearVistaGeneralViewModel() -> AutoevaluacionGeneralViewModel {
        return .init(tabla: .init(permiteSeleccion: false,
                                  alturaDeCelda: UITableView.automaticDimension,
                                  estiloDeSeparador: .none),
                     boton: .init(titulos: [.normal(valor: "SIGUIENTE")],
                                  apariencia: BotonApariencia.init(tituloFuente: .encodeSansSemiBold(tamaño: 16),
                                                                   tituloColores: [.normal(valor: .white)],
                                                                   colorFondo: .azulPrincipal,
                                                                   anchoBorde: 0,
                                                                   radioEsquina: 29)))
            
            
    }
    
    func creaTextConLogoViewModel(texto: String, textFont: UIFont, colorDeFondo: UIColor, logo: UIImage) -> AutoevaluacionTextoConLogoViewModel {
        return AutoevaluacionTextoConLogoViewModel(
            titulo: .init(texto: texto,
                          apariencia: .init(fuente: textFont,
                                            colorTexto: .grisFuerte)),
            alineacionDeTexto: .left,
            margen: MetricasTemperatura.margenesDeCabecera,
            colorDeFondo: colorDeFondo,
            logo: logo
        )
    }

    func creaTextBasicoViewModel(texto: String, textFont: UIFont, alineacionDeTexto: NSTextAlignment = .center, margenes: UIEdgeInsets = Metricas.margenesBasicos) -> AutoevaluacionItemViewModel {
        return AutoevaluacionTextBasicoViewModel(
            titulo: .init(texto: texto,
                          apariencia: .init(fuente: textFont,
                                            colorTexto: .grisPrincipal)),
            alineacionDeTexto: alineacionDeTexto,
            margen: margenes
        )
    }
    
    func creaBotonVolver(identificador:Identificador, titulo:String) -> AutoevaluacionItemViewModel {
        return AutoevaluacionBotonVolverViewModel(boton: .init(titulo: .crearBotonBlanco(titulo: titulo), identificador: identificador))
    }

    func creaTextoEnumeradoViewModel(texto: String, numero: Int, margenes: UIEdgeInsets) -> AutoevaluacionItemViewModel {
        return AutoevaluacionTextoEnumeradoViewModel(
            texto: texto,
            numero: numero,
            colorDeNumero: .grisTerciario,
            fuenteNumero: Metricas.fuenteNumerica,
            colorDeTexto: .grisPrincipal,
            alineacionDeTexto: .left,
            fuenteTexto: Metricas.fuenteRegular,
            margen: margenes
        )
    }
    
    func creaIncrementalDecrementalViewModel(valorInicial: Double,
                                             cambio: @escaping (Double, Bool) -> Void)  -> AutoevaluacionItemViewModel {
        return AutoevaluacionIncrementalDecrementalViewModel(
            valor: valorInicial,
            fuente: MetricasTemperatura.fuenteSelectorTemperatura,
            formato: Constantes.AUTOEVALUACION_PRESENTADOR_FORMATO_TEMPERATURA,
            valorDePaso: Constantes.AUTOEVALUACION_PRESENTADOR_VALOR_DE_PASO_TEMPERATURA,
            valorMaximo: Constantes.AUTOEVALUACION_PRESENTADOR_VALOR_MAXIMO_TEMPERATURA_HUMANA,
            valorMinimo: Constantes.AUTOEVALUACION_PRESENTADOR_VALOR_MINIMO_TEMPERATURA_HUMANA,
            separadorDecimal: Constantes.AUTOEVALUACION_PRESENTADOR_SEPARADOR,
            margen: MetricasTemperatura.margenesIncrementalDecremental,
            cambio: cambio,
            accionEditando: accionEditandoTemperatura(),
            accionTerminaDeEditar: accionFinalizaDeEditar()
        )
    }
    
    func creaPreguntaViewModel(identificador: String,
                               afirmativo: String,
                               negativo: String,
                               valor: Bool?,
                               seleccion: @escaping (Bool?) -> Void) -> AutoevaluacionItemViewModel {
        return  AutoevaluacionPreguntaViewModel(
            identificador: identificador,
            tituloAfirmativo: .init(texto: afirmativo,
                                    apariencia: .init(fuente: MetricasSintomas.fuenteSintomas,
                                                      colorTexto: .grisFuerte)),
            tituloNegativo: .init(texto: negativo,
                                  apariencia: .init(fuente: MetricasSintomas.fuenteSintomas,
                                                    colorTexto: .grisFuerte)),
            margen: MetricasSintomas.margenesPreguntas,
            valor: valor,
            seleccion: seleccion
        )
    }
    
    func creaLinkViewModel(texto: String, seleccion: @escaping () -> Void) -> AutoevaluacionItemViewModel {
        return AutoevaluacionLinkViewModel(
            texto: texto,
            colorDeTexto: .grisPrincipal,
            textAlignment: .center,
            fuente: MetricasTemperatura.fuenteLink,
            margen: Metricas.margenesBasicos,
            seleccion: seleccion
        )
    }
        
    func creaCajaSeleccionableViewModel(identificador: String,
                                        texto: String,
                                        valor: Bool,
                                        seleccion: @escaping (Bool, UITableViewCell) -> Void) -> AutoevaluacionItemViewModel {
        return AutoevaluacionCajaSeleccionableViewModel(
            identificador: identificador,
            titulo: .init(texto: texto,
                          apariencia: .init(fuente: MetricasAntecedentes.fuenteAntecedentes,
                                            colorTexto: .grisFuerte)),
            margen: MetricasAntecedentes.margenesCajaDeSeleccion,
            valor: valor,
            seleccion: seleccion
        )
    }
}

private extension AutoevaluacionPresentador {
    func accionDeTemperatura(para valor: Double, reiniciarValorInicial: Bool) {
        if valor > Constantes.AUTOEVALUACION_PRESENTADOR_VALOR_MAXIMO_TEMPERATURA_HUMANA || valor <= Constantes.AUTOEVALUACION_PRESENTADOR_VALOR_MINIMO_TEMPERATURA_HUMANA {
            vista?.mostrarAlertaDeTemperatura(contenido: generaAlertDeTemperaturaAnormal(), reiniciarValorInicial: reiniciarValorInicial)
        } else {
            temperaturaSeleccionada = valor
            autoevaluacionFachada.agregarAutoevaluacion(indicadores: .init(temperatura: valor))
        }
    }
    
    func accionEditandoTemperatura() -> (UITextField, NSRange, String) -> Bool {
        return { (textField, range: NSRange, string: String) -> Bool in
            let textoActual = textField.text ?? ""
            guard let rangoDeTexto = Range(range, in: textoActual) else { return false }
            var textoIngresado = textoActual.replacingCharacters(in: rangoDeTexto, with: string)
            
            if textoIngresado.count == Constantes.AUTOEVALUACION_PRESENTADOR_MAXIMO_ENTEROS && string != "" {
                textField.text = textoIngresado + Constantes.AUTOEVALUACION_PRESENTADOR_SEPARADOR
                return false
            }
                                
            if string == "",
                let ultimoCaracter = textoIngresado.last,
                String(ultimoCaracter) == Constantes.AUTOEVALUACION_PRESENTADOR_SEPARADOR {
                textoIngresado.removeLast()
                textField.text = textoIngresado
                return false
            }
                                
            return textoIngresado.count <= Constantes.AUTOEVALUACION_PRESENTADOR_MAXIMO_CARACTERES
        }
    }
    
    func accionFinalizaDeEditar() -> (UITextField) -> Double? {
        return { (textField) -> Double? in
            guard let texto = textField.text else {
                return nil
            }
            var textoActual = texto.replacingOccurrences(of: Constantes.AUTOEVALUACION_PRESENTADOR_SEPARADOR, with: ".")
            if let index = textoActual.range(of: Constantes.AUTOEVALUACION_PRESENTADOR_SEPARADOR) {
                textoActual.removeSubrange(index)
            }
            return Double(textoActual) ?? Constantes.AUTOEVALUACION_PRESENTADOR_TEMPERATURA_DEFAULT
        }
    }
    
}

private extension AutoevaluacionPresentador {
    func evaluarBotonSiguienteParaSintomas() {
        let preguntas = sintomaSeleccionados.values
        if preguntas.compactMap({ $0.valor }).count ==  preguntas.count {
            vista?.habilitarBotonSiguiente()
        } else {
            vista?.deshabilitarBotonSiguiente()
        }
    }
}

private extension AutoevaluacionPresentador {
    func permisosDenegados() {
        terminarAutoEvaluacion()
    }
    func permisosOtorgados() {
        ubicacionFachada.obtenerUbicacion()
    }
    func ubicacionDetectada(ubicacion: GeoLocalizacion) {
        autoevaluacionFachada.agregarUbicacion(ubicacion)
        terminarAutoEvaluacion()
    }
    func ubicacionNoDetectada() {
        terminarAutoEvaluacion()
    }
}

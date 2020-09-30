//
//  FactoriaPasaporteViewModel.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol TipoPasaporte {
    var vigencia: String { get set }
    func aceptar<V: VisitadorTipoPasaporte>(visitador: V) -> V.Resultado
}

struct PasaporteNoInfectado: TipoPasaporte {
    var vigencia: String
    var qrString: String?
    var vigenciaCirculacion: String
    var tipoActividad: String
    var permisosDeCirculacion: [Estado.PermisoDeCirculacion]?
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(noInfectado: self)
    }
}

struct PasaporteNoContagioso: TipoPasaporte {
    var vigencia: String
    var qrString: String?
    var vigenciaCirculacion: String
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(noContagioso: self)
    }
}

struct PasaporteDerivadoALaSalud: TipoPasaporte {
    var vigencia: String
    var qrString: String?
    var tagPims: String?
    var motivoPims: String?
    var provinciaCoep: String?
    var telefonoCoep: String?
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(derivadoALaSalud: self)
    }
}

struct PasaporteInfectado: TipoPasaporte {
    var vigencia: String
    var provinciaCoep: String?
    var telefonoCoep: String?
    func aceptar<V>(visitador: V) -> V.Resultado where V : VisitadorTipoPasaporte {
        visitador.visitar(infectado: self)
    }
}

protocol VisitadorTipoPasaporte {
    associatedtype Resultado
    func visitar(noInfectado: PasaporteNoInfectado) -> Resultado
    func visitar(derivadoALaSalud: PasaporteDerivadoALaSalud) -> Resultado
    func visitar(noContagioso: PasaporteNoContagioso) -> Resultado
    func visitar(infectado: PasaporteInfectado) -> Resultado
}

final class FactoriaPasaporteViewModel {
    typealias TokenDinamico = (token: String, segundoToken: String, tercerToken: String)
    typealias ResultadoColores = (color1: UIColor, color2: UIColor)

    let nombre: String
    let dNI: String
    var sube: String?
    var patente: String?
    let tokenDinamico: TokenDinamico?
    let provincia:String?
    private lazy var formateador = FormateadorTiempoRestante()
    
    
    init(nombre: String, dNI: String,sube: String?,patente: String?, tokenDinamico: TokenDinamico?, provincia: String?) {
        self.nombre = nombre
        self.dNI = dNI
        self.sube = sube
        self.patente = patente
        self.tokenDinamico = tokenDinamico
        self.provincia  = provincia
    }
    
    func crearModeloPara(tipo: TipoPasaporte) -> PasaporteViewModel {
        var info: [PasaporteElemento] = []
        info.append(contentsOf: tipo.aceptar(visitador: self))
        return .init(elementos: info)
    }
}
 
extension FactoriaPasaporteViewModel: VisitadorTipoPasaporte {
    func visitar(noInfectado: PasaporteNoInfectado) -> [PasaporteElemento] {
        
        let certificatesCount: Int = noInfectado.permisosDeCirculacion?.count ?? 0

        if certificatesCount > 0 && !(formateador.ejecutar(fecha: noInfectado.vigenciaCirculacion)?.vencido ?? true) {
            let vigencia = obtenerMinimaFechaVencimiento(vigenciaEstadoStringFecha: noInfectado.vigencia, vigenciaCirculacionStringFecha: noInfectado.vigenciaCirculacion)
            let tipoActividad = noInfectado.tipoActividad
            
            if pasoLaVigencia(vigenciaEstadoStringFecha: vigencia) {
                return generarContenidoNoInfectadoConQRInvalido(vigencia: noInfectado.vigencia)
            }
            
            if certificatesCount > 1 {
                return generarContenidoNoInfectadoConQRMultipleValido(certificates: noInfectado.permisosDeCirculacion!, vigencia: vigencia, tipoActividad: tipoActividad)
            }else{
                return generarContenidoNoInfectadoConQRValido(vigencia: vigencia, qrString: (noInfectado.permisosDeCirculacion?[0].qrURL)!, tipoActividad: tipoActividad)
            }
        } else {
            return generarContenidoNoInfectadoConQRInvalido(vigencia: noInfectado.vigencia)
        }
    }

    func visitar(derivadoALaSalud noCircular: PasaporteDerivadoALaSalud) -> [PasaporteElemento] {
        return generarContenidoParaDerivadoASalud(tipoPase: noCircular)
    }
    
    func visitar(noContagioso: PasaporteNoContagioso) -> [PasaporteElemento] {
        if let qrString = noContagioso.qrString,
           !(formateador.ejecutar(fecha: noContagioso.vigenciaCirculacion)?.vencido ?? true) {
            return generarContenidoNoContagiosoQRValido(qrString: qrString)
        } else {
            return generarContenidoNoContagiosoQRInvalido()
        }
    }
    
    func visitar(infectado: PasaporteInfectado) -> [PasaporteElemento] {
        return generarContenidoParaInfectado(tipoPase: infectado)
    }
    
    private func obtenerMinimaFechaVencimiento(vigenciaEstadoStringFecha: String, vigenciaCirculacionStringFecha: String) -> String {
        guard
            let vigenciaEstado = formateador.obtenerfechaDesdeString(fechaString: vigenciaEstadoStringFecha),
            let vigenciaCirculacion = formateador.obtenerfechaDesdeString(fechaString: vigenciaCirculacionStringFecha)
        else {
            return ""
        }
        if vigenciaEstado < vigenciaCirculacion {
            return vigenciaEstadoStringFecha
        }
        return vigenciaCirculacionStringFecha
    }
    
    private func pasoLaVigencia(vigenciaEstadoStringFecha: String) -> Bool {
        guard
            let vigenciaEstado = formateador.obtenerfechaDesdeString(fechaString: vigenciaEstadoStringFecha)
        else {
            return false
        }
        if vigenciaEstado < Date() {
            return true
        }
        return false
    }
}

private extension FactoriaPasaporteViewModel {
    func generarContenidoNoInfectadoConQRValido(vigencia: String, qrString: String, tipoActividad: String) -> [PasaporteElemento] {
        let tiempoFormateado = formatearFechaVigencia(vigencia)
        return [
            crearEstado("Podés salir a trabajar", fontSize: 30, fondo: .verde, imagen: "estado-circular"),
            crearInformacionGeneral(descripcion: "Recordá siempre las medidas sanitarias."),
            crearResultadoToken(resultado: "Certificado único \nde circulación", estado: "Habilitado", periodo: tipoActividad, color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: qrString),
            
            crearResultadoToken(resultado: "Autodiagnóstico", estado: "Sin síntomas", periodo: "Vence \(tiempoFormateado)", color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: nil),

            BotonCeldaViewModel(titulo: .crearBotonBlanco(titulo: "HACER OTRO AUTODIAGNÓSTICO"), identificador: .autodiagnostico)
        ]
    }
    
    func generarContenidoNoInfectadoConQRMultipleValido(certificates: [Estado.PermisoDeCirculacion], vigencia: String, tipoActividad: String) -> [PasaporteElemento] {
        let tiempoFormateado = formatearFechaVigencia(vigencia)
        
        let certificateSelected = UserDefaults.standard.value(forKey: "CerificateSelected") as? Int
        
        if certificateSelected != nil {
            for certificate in certificates {
                if certificate.idCertificado == certificateSelected {
                    patente = certificate.patente
                    sube = certificate.sube
                    
                    return [
                        crearEstado("Podés salir a trabajar", fontSize: 30, fondo: .verde, imagen: "estado-circular"),
                        crearInformacionGeneral(descripcion: "Recordá siempre las medidas sanitarias."),
                        crearCertificadoMultiple(certificates: certificates, selectedCertificate: certificate.idCertificado!),
                        crearResultadoToken(resultado: "Certificado único \nde circulación", estado: "Habilitado", periodo: certificate.tipoActividad!, color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: certificate.qrURL),
                        
                        crearResultadoToken(resultado: "Autodiagnóstico", estado: "Sin síntomas", periodo: "Vence \(tiempoFormateado)", color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: nil),

                        BotonCeldaViewModel(titulo: .crearBotonBlanco(titulo: "HACER OTRO AUTODIAGNÓSTICO"), identificador: .autodiagnostico)
                    ]
                }
            }
        }
        
        return [
            crearEstado("Podés salir a trabajar", fontSize: 30, fondo: .verde, imagen: "estado-circular"),
            crearInformacionGeneral(descripcion: "Recordá siempre las medidas sanitarias."),
            crearCertificadoMultiple(certificates: certificates,selectedCertificate: certificates[0].idCertificado!),
            crearResultadoToken(resultado: "Certificado único \nde circulación", estado: "Habilitado", periodo: tipoActividad, color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: certificates[0].qrURL),
            
            crearResultadoToken(resultado: "Autodiagnóstico", estado: "Sin síntomas", periodo: "Vence \(tiempoFormateado)", color: .verde, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: nil),

            BotonCeldaViewModel(titulo: .crearBotonBlanco(titulo: "HACER OTRO AUTODIAGNÓSTICO"), identificador: .autodiagnostico)
        ]
    }
    
    func generarContenidoNoInfectadoConQRInvalido(vigencia: String) -> [PasaporteElemento] {
        let tiempoFormateado = formatearFechaVigencia(vigencia)
        return [
            crearEstado("Quedate\nen casa", fontSize: 30, fondo: .azul, imagen: "estado-no-contagioso"),
            crearInformacionGeneral(descripcion: "Recordá que solo podés salir de tu casa para realizar compras en comercios de cercanía."),
                            
            crearResultadoToken(resultado: "Autodiagnóstico", estado: "Sin síntomas", periodo: "Vence \(tiempoFormateado)", color: .azul, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: nil),
            
            BotonCeldaViewModel(titulo: .crearBotonBlanco(titulo: "HACER OTRO AUTODIAGNÓSTICO"), identificador: .autodiagnostico),
            crearCertificadoEstado(estado: "No disponible", color: .azul),
            BotonCeldaViewModel(titulo: .crearBotonAzul(titulo: "AGREGAR"), identificador: .habilitarCirculacion)
        ]
    }
    
    func generarContenidoParaDerivadoASalud(tipoPase pase: PasaporteDerivadoALaSalud) -> [PasaporteElemento] {
        let tiempoFormateado = formatearFechaVigencia(pase.vigencia)
        let estado = pase.tagPims ?? "En observación"
        let informacion = pase.motivoPims ?? "MÁS INFORMACIÓN"
        let resultado = pase.tagPims != nil ? "Aislamiento requerido" : "Derivado al sistema de\nSalud"
        return [
            crearEstado("No podés estar en\ncontacto con otras\npersonas", fontSize: 22, numberLines: 3, fondo: .rosa, imagen: "estado-infectado"), pase.provinciaCoep != nil ?
                crearInformacionGeneral(descripcion: "Contactate con el sistema de Salud. \n\(pase.provinciaCoep ?? ""): \(pase.telefonoCoep ?? "") \nMientras tanto, mantené el aislamiento y minimizá el contacto con otras personas.") : crearInformacionGeneral(descripcion: "Contactate con el sistema de Salud. \nMientras tanto, mantené el aislamiento y minimizá el contacto con otras personas."),
            crearResultadoToken(resultado: resultado, estado: estado, periodo: "Vence \(tiempoFormateado)", color: .rosa, informacion: informacion, informacionColor: pase.motivoPims != nil ? .negroTerciario : .azulCyan, token: tokenDinamico, qrString: nil, esPim: pase.tagPims != nil ? true : false),
            crearCertificadoEstado(estado: "No permitido", color: .rosa),
            crearInformacionAdicional()
        ]
    }
    
    func generarContenidoParaInfectado(tipoPase pase: PasaporteInfectado) -> [PasaporteElemento] {
        let tiempoFormateado = formatearFechaVigencia(pase.vigencia)
        return [
            crearEstado("No podés estar en\ncontacto con otras\npersonas", fontSize: 22, numberLines: 3, fondo: .rosa, imagen: "estado-infectado"),
            crearInformacionGeneral(descripcion: "Contactate con el sistema de Salud. \n\(pase.provinciaCoep ?? ""): \(pase.telefonoCoep ?? "") \nMientras tanto, mantené el aislamiento y minimizá el contacto con otras personas."),
            crearResultadoToken(resultado: "Derivado al sistema de Salud", estado: "COVID-19 Positivo", periodo: "Vence \(tiempoFormateado)", color: .rosa, informacion: "MÁS INFORMACIÓN", informacionColor: .azulCyan, token: tokenDinamico, qrString: nil),
            crearCertificadoEstado(estado: "No permitido", color: .rosa),
            crearInformacionAdicional()
        ]
    }
    
    func generarContenidoNoContagiosoQRValido(qrString: String) -> [PasaporteElemento] {
        return [crearPasaporteResultadoSinTiempoViewModel(mensaje: "",
                                                          estatus: "PODÉS IR A TRABAJAR",
                                                          descripcion: "Recordá las medidas sanitarias al volver a tu casa".uppercased(),
                                                       colores: (color1: .verdePrimario, color2: .verdeSecundario)),
                crearPasaporteTokenSeguridadViewModel(qrString: qrString,
                                                      tokenDinamico: tokenDinamico)
        ]
    }
    
    func generarContenidoNoContagiosoQRInvalido() -> [PasaporteElemento] {
        return [crearPasaporteResultadoSinTiempoViewModel(mensaje: "",
                                                          estatus: "QUEDATE EN CASA",
                                                          descripcion: "Recordá que solo podés salir de tu casa para realizar compras en comercios de cercanía. Para realizar actividades exceptuadas de la cuarentena requerís un certificado.".uppercased(),
                                                          colores: (color1: .azulPrimario, color2: .azulSecundario)),
                BotonCeldaViewModel(titulo: .crearBotonBlanco(titulo: "HABILITAR LA CIRCULACIÓN"),
                                    identificador: .habilitarCirculacion),
                crearTokenDinamivoViewModel(tokenDinamico: tokenDinamico)
        ]
    }
}

private extension FactoriaPasaporteViewModel {
    
    func crearEstado(_ estado: String, fontSize: CGFloat, numberLines: Int = 2, fondo: UIColor, imagen: String) -> PasaporteEstadoViewModel {
        return PasaporteEstadoViewModel(
            colorFondo: fondo,
            estado: .init(texto: estado, apariencia: .init(fuente: .robotoBold(tamaño: fontSize), numberLines: numberLines, colorTexto: .white)),
            titulo: .init(texto: "Credencial", apariencia: .init(fuente: .robotoRegular(tamaño: 16), colorTexto: .white)),
            imagen: UIImage(named: imagen))
    }
    
    func crearInformacionGeneral(descripcion: String) -> PasaporteIdentificacionViewModel {
    return  PasaporteIdentificacionViewModel(
            nombre: .init(texto: nombre, apariencia: .init(fuente: .robotoBold(tamaño: 18), colorTexto: .black)),
            dNI: .init(texto: dNI, apariencia: .init(fuente: .robotoMedium(tamaño: 16), colorTexto: .black)),
            descripcion: .init(texto: descripcion, apariencia: .init(fuente: .robotoMedium(tamaño: 16), colorTexto: .negroSecundario)),
            patente: .init(patente ?? ""),
            sube: .init(sube ?? ""),
            provincia: .init(provincia ?? ""))
    }
    
    func crearCertificadoEstado( estado: String, color: UIColor) -> CertificadoEstadoViewModel {
        return CertificadoEstadoViewModel(
            titulo: LabelViewModel(texto: "Certificado único de circulación", apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 16), colorTexto: .negroSecundario)),
            estado: LabelViewModel(texto: estado, apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 22), colorTexto: color))
        )
    }
    
    func crearCertificadoMultiple( certificates: [Estado.PermisoDeCirculacion], selectedCertificate: Int) -> MultipleCertificatesViewModel {
        return MultipleCertificatesViewModel(certificates: certificates,selectedCertificate: selectedCertificate)
    }
    
    func crearResultadoToken(resultado: String, estado: String, periodo: String, color: UIColor, informacion: String, informacionColor: UIColor, token: TokenDinamico?, qrString: String?, esPim: Bool = false) -> ResultadoTokenViewModel {
        let qrImagen = qrString != nil ? generateQRCode(from: qrString!): nil
        return ResultadoTokenViewModel(
            resultado: LabelViewModel(texto: resultado, apariencia: LabelAppearance(fuente: .robotoBold(tamaño: 15), numberLines: 2, colorTexto: .negroSecundario)),
            estado: LabelViewModel(texto: estado, apariencia: LabelAppearance(fuente: .robotoBold(tamaño:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         22), numberLines: 1, colorTexto: color)),
            periodo: LabelViewModel(texto: periodo, apariencia: LabelAppearance(fuente: .robotoBold(tamaño: qrString == nil ? 12 : 16), colorTexto: qrString == nil ? .negroSecundario : .azulCyan)),
            informacion: LabelViewModel(texto: informacion, apariencia: LabelAppearance(fuente: .robotoMedium(tamaño: 14), colorTexto: informacionColor)),
            QRImage: qrImagen,
            descripcionToken: LabelViewModel(texto: "Token de seguridad", apariencia: LabelAppearance(fuente: .robotoRegular(tamaño: 12), colorTexto: .darkGray)),
            primerToken: token?.token,
            segundoToken: token?.segundoToken,
            tercerToken: token?.tercerToken, esPim: esPim)
    }
    
    func crearPasaporteTokenSeguridadViewModel(qrString: String?, tokenDinamico: TokenDinamico?) -> PasaporteTokenSeguridadViewModel {
        let qrImagen = qrString != nil ? crearQR(enunciadoBase64: qrString) : nil
        return .init(borderColor: .grisBorde,
                     tituloBorderColor: .white,
                     mensaje: .init(texto: "Esta credencial es válida sólo si coincide el token de seguridad entre teléfonos",
                                    apariencia: .init(fuente: .robotoRegular(tamaño: 14),
                                                      colorTexto: .negroSecundario)),
                     primerEmoji: tokenDinamico?.token,
                     segundoEmoji: tokenDinamico?.segundoToken,
                     tercerEmoji: tokenDinamico?.tercerToken,
                     QRImage: qrImagen)
    }
    
    func crearTokenDinamivoViewModel(tokenDinamico: TokenDinamico?) -> PasaporteTokenDinamicoViewModel {
        return .init(borderColor: .grisBorde,
                     tituloBorderColor: .white,
                     mensaje: .init(texto: "Esta credencial es válida sólo si coincide el token de seguridad entre teléfonos",
                     apariencia: .init(fuente: .robotoRegular(tamaño: 14),
                                       colorTexto: .negroSecundario)),
                     primerEmoji: tokenDinamico?.token,
                     segundoEmoji: tokenDinamico?.segundoToken,
                     tercerEmoji: tokenDinamico?.tercerToken)
    }
    
    func crearInformacionAdicional() -> InformacionAdicionalViewModel {
        let atributosPrincipales = [NSAttributedString.Key.font: UIFont.robotoMedium(tamaño: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
        let atributoLink = [NSAttributedString.Key.font: UIFont.robotoMedium(tamaño: 14), NSAttributedString.Key.foregroundColor: UIColor.azulCyan, NSAttributedString.Key.underlineStyle: 1] as [NSAttributedString.Key : Any]

        let attributedStringPrincipal = NSMutableAttributedString(string:"Ante cualquier duda podés comunicarte al\n+54 9 11 2256 0566 o a los números que\nfiguran en el siguiente ", attributes:atributosPrincipales)
        let attributedStringLink = NSMutableAttributedString(string:"link", attributes:atributoLink)

        attributedStringPrincipal.append(attributedStringLink)
        
        return InformacionAdicionalViewModel(informacion: attributedStringPrincipal)
    }
    
    func crearPasaporteResultadoSinTiempoViewModel(mensaje: String, estatus: String, descripcion: String, colores: ResultadoColores) -> PasaporteResultadoTiempoViewModel {
        return .init(colorFondoPrimeraSeccion: colores.color1,
                     colorFondoSegundaSeccion: colores.color2,
                     tiempo: .init(texto: "",
                                  apariencia: .init(fuente: .robotoBold(tamaño: 35.0),
                                                    colorTexto: .white)),
                     tiempoDescripcion: .init(texto: mensaje,
                                              apariencia: .init(fuente: .robotoRegular(tamaño: 13),
                                                                colorTexto: .white)),
                     estatus: .init(texto: estatus,
                                    apariencia: .init(fuente: .robotoBold(tamaño: 14.0),
                                                      colorTexto: .white)),
                     descripcion: .init(texto: descripcion,
                                        apariencia: .init(fuente: .robotoBold(tamaño: 12.0),
                                                          colorTexto: .white)))
    }
}

private extension FactoriaPasaporteViewModel {
    func crearQR(enunciadoBase64: String?) -> UIImage? {
        guard let enunciadoBase64 = enunciadoBase64 else {
            return nil
        }
        guard let imageData = Data.init(base64Encoded: enunciadoBase64, options: .init(rawValue: 0)) else {
            return UIImage()
        }
      
        return UIImage(data: imageData)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil}
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        return UIImage(ciImage: scaledQrImage)
    }
    
    func formatearFechaVigencia(_ fecha: String) -> String {
        guard let fecha = formateador.obtenerfechaDesdeString(fechaString: fecha) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: fecha)
    }
}

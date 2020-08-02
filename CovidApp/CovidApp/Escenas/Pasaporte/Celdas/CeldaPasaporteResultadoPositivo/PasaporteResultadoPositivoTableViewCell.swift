//
//  PasaporteResultadoPositivoTableViewCell.swift
//  CovidApp
//
//  Created on 11/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class PasaporteResultadoPositivoTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
    @IBOutlet var primeraFilaVista: [UIView]!
    @IBOutlet weak var vistaResultado: UIView!
    @IBOutlet weak var vistaContenedor: UIView!
    @IBOutlet weak var tituloEstadoLabel: UILabel!
    @IBOutlet weak var resultadoLabel: UILabel!
    @IBOutlet weak var imagenResultado: UIImageView!
    @IBOutlet weak var mensajeResultadoLabel: UILabel!
    @IBOutlet weak var masInformacion: UILabel!
    @IBOutlet weak var tiempoContenedor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurar(viewModel: PasaporteResultadoViewModel) {
        
        vistaContenedor.clipsToBounds = true
        vistaContenedor.layer.cornerRadius = 10
        vistaContenedor.layer.borderWidth = 1.0
        vistaContenedor.layer.borderColor = viewModel.colorFondoPrimeraSeccion.cgColor
        
        tituloEstadoLabel.configurar(modelo: viewModel.titulo)
        resultadoLabel.configurar(modelo: viewModel.resultado)
        mensajeResultadoLabel.configurar(modelo: viewModel.mensaje)
        configurarTiempoContenedor(viewModel: viewModel)
        imagenResultado.image = viewModel.estatusImagen
        
        configurarColorPrimeraFila(color: viewModel.colorFondoPrimeraSeccion)
        vistaResultado.backgroundColor = viewModel.colorFondoSegundaSeccion
        vistaContenedor.backgroundColor = viewModel.colorFondoTerceraSeccion
        
        masInformacion.attributedText = viewModel.masInformacion.attributedText
        
    }
}

private extension PasaporteResultadoPositivoTableViewCell {
    func configurarColorPrimeraFila(color: UIColor) {
        primeraFilaVista.forEach { $0.backgroundColor = color }
    }
    
    func configurarTiempoContenedor(viewModel: PasaporteResultadoViewModel) {
        limpiarTiempoContenedor()
        let view = UIView(frame: tiempoContenedor.bounds)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        tiempoContenedor.addSubview(view)
        configurarConstraintsTiempo(vista: view)
        configurarConstraintsTiempoContenedor(vistaContendora: view,
                                              tiempo: crearEtiquetaTiempo(viewModel: viewModel.tiempo),
                                              descripcion: crearEtiquetaTiempoDescripcion(viewModel: viewModel.tiempoDescripcion))
    }
    
    func crearEtiquetaTiempoDescripcion(viewModel: LabelViewModel) -> UILabel {
        let tiempoDescripcion = UILabel()
        tiempoDescripcion.numberOfLines = 2
        tiempoDescripcion.configurar(modelo: viewModel)
        tiempoDescripcion.adjustsFontSizeToFitWidth = true
        tiempoDescripcion.minimumScaleFactor = 0.0
        tiempoDescripcion.sizeToFit()
        tiempoDescripcion.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tiempoDescripcion.translatesAutoresizingMaskIntoConstraints = false
        return tiempoDescripcion
    }
    
    func crearEtiquetaTiempo(viewModel: LabelViewModel) -> UILabel? {
        guard !viewModel.texto.isEmpty else { return nil }
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.configurar(modelo: viewModel)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func limpiarTiempoContenedor() {
        tiempoContenedor.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func configurarConstraintsTiempo(vista: UIView) {
        let constraints: [NSLayoutConstraint] = [
            vista.leadingAnchor.constraint(equalTo: tiempoContenedor.leadingAnchor),
            vista.trailingAnchor.constraint(equalTo: tiempoContenedor.trailingAnchor),
            vista.topAnchor.constraint(equalTo: tiempoContenedor.topAnchor),
            vista.bottomAnchor.constraint(equalTo: tiempoContenedor.bottomAnchor)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configurarConstraintsTiempoContenedor(vistaContendora: UIView, tiempo: UIView?, descripcion: UIView) {
        vistaContendora.addSubview(descripcion)
        var constraints: [NSLayoutConstraint] = [
            descripcion.topAnchor.constraint(equalTo: vistaContendora.topAnchor, constant: 20),
            descripcion.bottomAnchor.constraint(equalTo: vistaContendora.bottomAnchor, constant: -20)]
        if let tiempo = tiempo {
            vistaContendora.addSubview(tiempo)
            let subConstraints: [NSLayoutConstraint] = [
                tiempo.leadingAnchor.constraint(equalTo: vistaContendora.leadingAnchor, constant: 5),
                tiempo.centerYAnchor.constraint(equalTo: descripcion.centerYAnchor),
                descripcion.leadingAnchor.constraint(equalTo: tiempo.trailingAnchor, constant: 1),
                descripcion.trailingAnchor.constraint(equalTo: vistaContendora.trailingAnchor, constant: -5)
            ].compactMap { $0 }
            
            constraints.append(contentsOf: subConstraints)
        } else {
            let subConstraints: [NSLayoutConstraint] = [
                descripcion.leadingAnchor.constraint(equalTo: vistaContendora.leadingAnchor, constant: 10),
                descripcion.trailingAnchor.constraint(equalTo: vistaContendora.trailingAnchor, constant: -10),
               
            ].compactMap { $0 }
            
           constraints.append(contentsOf: subConstraints)
        }
        
        NSLayoutConstraint.activate(constraints.compactMap { $0 })
    }
}


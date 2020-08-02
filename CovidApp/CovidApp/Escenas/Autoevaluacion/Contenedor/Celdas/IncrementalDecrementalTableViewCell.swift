//
//  IncrementalDecrementalTableViewCell.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class IncrementalDecrementalTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {

    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    private struct Metricas {
        static let alturaMinima: CGFloat = 52
    }
        
    lazy var vista: IncrementalDecrementalView = {
        let vista = IncrementalDecrementalView(frame: contentView.frame)
        vista.translatesAutoresizingMaskIntoConstraints = false
        return vista
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configurar(viewModel: AutoevaluacionIncrementalDecrementalViewModel) {
        vista.campoDeTexto.font = viewModel.fuente
        vista.formato = viewModel.formato
        vista.valor = viewModel.valor
        vista.valorDePaso = viewModel.valorDePaso
        vista.valorMaximo = viewModel.valorMaximo
        vista.valorMinimo = viewModel.valorMinimo
        vista.accionEmpiezaAEditar = viewModel.accionEmpiezaAEditar
        vista.accionCambiarValor = viewModel.cambio
        vista.accionEditando = viewModel.accionEditando
        vista.accionFinalizaDeEditar = viewModel.accionTerminaDeEditar
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension IncrementalDecrementalTableViewCell {
    func commonInit() {
        contentView.addSubview(vista)
        configuraLayout()
    }
    
    func configuraLayout() {
        margenDerecho = vista.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        margenIzquierdo = vista.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenSuperior = vista.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = vista.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let alturaMinima = vista.heightAnchor.constraint(equalToConstant: Metricas.alturaMinima)
        let constraints = [alturaMinima, margenSuperior, margenIzquierdo, margenDerecho, margenInferior]
        NSLayoutConstraint.activate(constraints.compactMap { $0 })
    }
}

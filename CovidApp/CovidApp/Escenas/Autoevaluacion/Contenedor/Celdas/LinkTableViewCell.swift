//
//  LinkTableViewCell.swift
//  CovidApp
//
//  Created on 4/7/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

final class LinkTableViewCell: UITableViewCell, UITableViewCellRegistrable, MargenesEnCeldaProtocolo {
    
    var margenSuperior: NSLayoutConstraint?
    var margenInferior: NSLayoutConstraint?
    var margenIzquierdo: NSLayoutConstraint?
    var margenDerecho: NSLayoutConstraint?
    
    lazy var linkTextView: LinkTextView = {
        let link = LinkTextView()
        link.isScrollEnabled = false
        link.textContainerInset = .zero
        link.textContainer.lineFragmentPadding = 0
        link.translatesAutoresizingMaskIntoConstraints = false
        link.isEditable = false
        link.isSelectable = true
        return link
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configurar(viewModel: AutoevaluacionLinkViewModel) {
        linkTextView.putInformation(texto: viewModel.texto,
                                    color: viewModel.colorDeTexto)
        linkTextView.textAlignment = viewModel.textAlignment
        linkTextView.font = viewModel.fuente
        linkTextView.accionTap = viewModel.seleccion
        configurarMargenesEnCelda(con: viewModel.margen)
    }
}

private extension LinkTableViewCell {
    func commonInit() {
        contentView.addSubview(linkTextView)
        configuraLayout()
    }
    
    func configuraLayout() {
        margenDerecho = linkTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        margenIzquierdo = linkTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        margenSuperior = linkTextView.topAnchor.constraint(equalTo: contentView.topAnchor)
        margenInferior = linkTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let constrains = [margenIzquierdo, margenDerecho, margenSuperior, margenInferior]
        NSLayoutConstraint.activate(constrains.compactMap { $0 })
    }
}

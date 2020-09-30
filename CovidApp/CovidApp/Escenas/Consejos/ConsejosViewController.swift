//
//  ConsejosViewController.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit
import WebKit

protocol ConsejosVista: class {
    func configurarVista(url:URL)
    func centrarLoadingIndicator()
    func dismiss()
}

final class ConsejosViewController: BaseViewController, MVPVista {
    
    var loadingIndicator = UIActivityIndicatorView()
    
    let webView = WKWebView()
    lazy var presentador: ConsejosPresentadorProtocolo = self.inyectar()
    lazy var enrutador: Enrutador = self.inyectar()
}

extension ConsejosViewController : ConsejosVista {
    func centrarLoadingIndicator() {
        let container: UIView = UIView()
        
        container.frame = CGRect(x: webView.center.x, y: webView.center.y, width: 80, height: 80)
        container.backgroundColor = .clear
        container.addSubview(loadingIndicator)
        
        webView.addSubview(container)
    }
    
    func configurarVista(url:URL) {
        webView.isUserInteractionEnabled = false
        view = webView
        
        loadingIndicator.startAnimating()
        webView.load(URLRequest(url: url))
    }
    
    func dismiss() {
        if (UserDefaults.standard.bool(forKey: Constantes.INVALID_TOKEN)) {
            let alert = UIAlertController(title: "Alerta", message: Constantes.ANOTHER_DEVICE_LOGGED, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.enrutador.desvinculaciónTerminada()
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ConsejosViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        presentador.terminoDeCargarWebView()
    }
    
    override func loadView() {
        webView.navigationDelegate = self
    }
}
extension WKWebView{
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//
//  SplashViewController.swift
//  CovidApp
//
//  Created on 23/04/2020.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = Bundle.main.appVersion
    }

}

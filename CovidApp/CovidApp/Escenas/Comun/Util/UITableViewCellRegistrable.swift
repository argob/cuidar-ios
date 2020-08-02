//
//  UITableViewCellRegistrable.swift
//  CovidApp
//
//  Created on 10/04/20.
//  Copyright © 2020 Secretaría de Innovación Pública. All rights reserved.
//

import UIKit

protocol UITableViewCellRegistrable {
    static var cellIdentifier: String { get }
}

extension UITableViewCellRegistrable {
    static var cellIdentifier: String {
        return String(describing: self)
    }

    static private var bundle: Bundle {
        return Bundle(for: PasaporteViewController.self)
    }

    static private var nib: UINib {
        return UINib(nibName: self.cellIdentifier, bundle: self.bundle)
    }
}

extension UITableViewCellRegistrable where Self: UITableViewCell {
    static func registerCell(inTableView tableView: UITableView) {
        tableView.register(self.nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    static func registerCodeCell(inTableView tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: self.cellIdentifier)
    }
}

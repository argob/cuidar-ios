//
//  MultipleCertificateTableViewCell.swift
//  CovidApp
//
//  Copyright © 2020 Secretaría de Innovación Pública, República Argentina. All rights reserved.
//

import UIKit


protocol DelegadoCertificadosTableViewCell: class {
    func certificateSelected(selectedCertificate:Estado.PermisoDeCirculacion)
}

final class MultipleCertificateTableViewCell: UITableViewCell, UITableViewCellRegistrable {
    
        
    @IBOutlet weak var certificateSelected: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: DelegadoCertificadosTableViewCell?
    
    var certificateList : [Estado.PermisoDeCirculacion]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(viewModel: MultipleCertificatesViewModel) {
        pickerView.delegate = self
        pickerView.dataSource = self
        certificateList = viewModel.certificates
        
        for certificate in certificateList! {
            if certificate.idCertificado == viewModel.selectedCertificate {
                certificateSelected.text = certificate.motivoCirculacion
            }
        }
    }
}

extension MultipleCertificateTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource {
   
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
       return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return certificateList!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return certificateList![row].motivoCirculacion
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.certificateSelected.text = self.certificateList![row].motivoCirculacion
        delegate?.certificateSelected(selectedCertificate: self.certificateList![row])
    }
}

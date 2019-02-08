//
//  pickerviewTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class pickerviewTableViewCell: UITableViewCell, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return cobaNumber.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(cobaNumber[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       
            selectedNumber = String(cobaNumber[row])
            textKuantitas.text = selectedNumber
         
      

       
    }
    
   
    
    
    var selectedNumber : String?
    
    var cobaNumber = Array(1...100)
   
   
    @IBOutlet weak var textKuantitas: CustomTextField!
   
    func createPicker()
    {
        let picker = UIPickerView()
        picker.delegate = self
        textKuantitas.inputView = picker
        picker.selectRow(0, inComponent: 0, animated: true)
    
    }

    override func awakeFromNib() {
        
        createPicker()
        
        //add done button
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
      
        textKuantitas.inputAccessoryView = toolbar
        
        textKuantitas.addTarget(self, action: #selector(textFieldChange), for: .editingDidEndOnExit)
        
    }
    
    @objc func textFieldChange(target: CustomTextField)
    {
        print("hey")
    }
    
    @objc func doneClicked()
    {

        textKuantitas.endEditing(true);
    }
}

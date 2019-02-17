//
//  pickerviewTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class pickerviewTableViewCell: UITableViewCell {
   /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return cobaNumber.count + 1
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if row == 0 {
			return ""
		}
        return String(cobaNumber[row-1])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
		if row != 0{
			selectedNumber = String(cobaNumber[picker.selectedRow(inComponent: 0) - 1])
			// selectedNumber = String(cobaNumber[row])
			textKuantitas.text = selectedNumber
		}
        
		

       
    }
    
   
    
    
    var selectedNumber : String?
    
    var cobaNumber = Array(1...100)
   
   
    @IBOutlet weak var textKuantitas: CustomTextField!
   
   let picker = UIPickerView()

    override func awakeFromNib() {
        
       
        picker.delegate = self
        picker.dataSource = self
        textKuantitas.inputView = picker
       //picker.selectedRow(inComponent: 0)+1
        
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
		if picker.selectedRow(inComponent: 0) == 0 {
			textKuantitas.text = ""
		}else {
       textKuantitas.text = "\(picker.selectedRow(inComponent: 0))"
		}
		textKuantitas.endEditing(true)
		textFieldChange(target: textKuantitas)
    }
	*/
}

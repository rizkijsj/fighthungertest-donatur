//
//  waktuPickerTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class waktuPickerTableViewCell: UITableViewCell , UIPickerViewDelegate , UIPickerViewDataSource{
	
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
            
        default:
            return 0
        }
        
    }
	
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return "jam \(row)"
        case 1:
            return "min \(row)"
        default:
            return ""
        }
   
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        let hourSelected = hours[pickerView.selectedRow(inComponent: 0)]
        let minuteSelected = minutes[pickerView.selectedRow(inComponent: 1)]
        textWaktu.text = "\(hourSelected):\(minuteSelected)"
        
      
    }
    
   
    func createPicker()
    {
        let picker = UIPickerView()
        picker.delegate = self
        //textWaktu.inputView = picker
    }
    
    
   var hours = Array(0...24)
   var minutes = Array(00...59)
  
    
    @IBOutlet weak var textWaktu: CustomTextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
      /*
        createPicker()
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add done button
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        textWaktu.inputAccessoryView = toolbar
		*/
    }

    @objc func doneClicked()
    {
        contentView.endEditing(true)
    }

}

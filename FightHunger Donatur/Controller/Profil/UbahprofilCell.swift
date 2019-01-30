//
//  UbahprofilCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class UbahprofilCell: UITableViewCell , UITextFieldDelegate{

    @IBOutlet weak var namaTxt: CustomTextField!
    @IBOutlet weak var telfonTxt: CustomTextField!
    @IBOutlet weak var emailTxt: CustomTextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if namaTxt.isFirstResponder
        {
            telfonTxt.becomeFirstResponder()
        }else if telfonTxt.isFirstResponder
        {
            emailTxt.becomeFirstResponder()
        }else
        {
            emailTxt.resignFirstResponder()
        }
        
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        namaTxt.delegate = self
        telfonTxt.delegate = self
        emailTxt.delegate = self
        
        //add done button
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telfonTxt.inputAccessoryView = toolbar
        
    }
    
    @objc func doneClicked()
    {
        contentView .endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

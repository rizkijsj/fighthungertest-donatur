//
//  UbahprofilViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class UbahprofilViewController: UIViewController, UITextFieldDelegate {

    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.delegate = self
        namaTxt.delegate = self
        telfonTxt.delegate = self
        
        //add done button
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telfonTxt.inputAccessoryView = toolbar
     
    }
    
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
    
    @IBAction func submitBtn(_ sender: Any) {
        
        //validation
        
    }
    
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBOutlet weak var emailTxt: CustomTextField!
    
    @IBOutlet weak var namaTxt: CustomTextField!
    
    @IBOutlet weak var telfonTxt: CustomTextField!
}

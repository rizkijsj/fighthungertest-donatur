//
//  LoginViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var telpTxtField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        telpTxtField.delegate = self
        
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telpTxtField.inputAccessoryView = toolbar
        
        errorMssg.isHidden = true
       
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }

    @IBOutlet weak var errorMssg: UILabel!
    @IBAction func LanjutButton(_ sender: Any) {
        
        //validation
        
        if telpTxtField.text != ""
        {
           performSegue(withIdentifier: "toVerif", sender: self)
        }
        else if telpTxtField.text == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "This field cannot be empty!"
        }
        
    }
    
    
}

//
//  DaftarViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class DaftarViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var errorMssg: UILabel!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var telpTxtField: CustomTextField!
    @IBOutlet weak var namaTxtField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //uitextfield delegate
        namaTxtField.delegate = self
        telpTxtField.delegate = self
        emailTxtField.delegate = self
        
        //hidden label
        errorMssg.isHidden = true
        
        //add done button
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telpTxtField.inputAccessoryView = toolbar
        namaTxtField.inputAccessoryView = toolbar
        emailTxtField.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBAction func btnLanjut(_ sender: Any) {
        
       
    }
    
 

}

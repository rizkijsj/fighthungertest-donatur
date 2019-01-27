//
//  OTPViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var otpTxt4: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt1: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change bg color
         otpTxt1.backgroundColor = UIColor.clear
         otpTxt2.backgroundColor = UIColor.clear
         otpTxt3.backgroundColor = UIColor.clear
         otpTxt4.backgroundColor = UIColor.clear
        
        otpTxt1.becomeFirstResponder()
        
        //add border
        addBottomBorder(textField: otpTxt1)
        addBottomBorder(textField: otpTxt2)
        addBottomBorder(textField: otpTxt3)
        addBottomBorder(textField: otpTxt4)
        
        //uitextfield delegate
        otpTxt1.delegate = self
        otpTxt2.delegate = self
        otpTxt3.delegate = self
        otpTxt4.delegate = self
    }
    
    func addBottomBorder(textField: UITextField)
    {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        
        textField.layer.addSublayer(layer)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if((textField.text?.count)! < 1) && string.count > 0
        {
            if textField == otpTxt1
            {
                otpTxt2.becomeFirstResponder()
            }
            
            if textField == otpTxt2
            {
                otpTxt3.becomeFirstResponder()
            }
            
            if textField == otpTxt3
            {
                otpTxt4.becomeFirstResponder()
            }
            
            if textField == otpTxt4
            {
                otpTxt4.resignFirstResponder()
            }
            
            //showing text
            textField.text = string
            return false
        }
        
       else if((textField.text?.count)! >= 1) && string.count == 0
        {
            
            if textField == otpTxt2
            {
                otpTxt1.becomeFirstResponder()
            }
            
            if textField == otpTxt3
            {
                otpTxt2.becomeFirstResponder()
            }
            
            if textField == otpTxt4
            {
                otpTxt3.becomeFirstResponder()
            }
            
            if textField == otpTxt1
            {
                otpTxt1.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        }
        
        else if((textField.text?.count)! >= 1)
        {
            textField.text = string
            return false
        }
        
        return true
    }

}

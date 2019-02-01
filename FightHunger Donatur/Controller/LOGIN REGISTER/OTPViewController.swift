//
//  OTPViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class OTPViewController: UIViewController , UITextFieldDelegate{

    @IBAction func kirimUlang(_ sender: Any) {
        
        //Validation kirim ulang
    
    }
    
  
    @IBOutlet weak var lnjtBtn: UIButton!
    
    @IBOutlet weak var otpTxt6: UITextField!
    @IBOutlet weak var otpTxt5: UITextField!
    @IBOutlet weak var otpTxt4: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt1: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    var tempTampungTerima = [String]()
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            lnjtBtn.layer.cornerRadius = 6.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        
        
        //Change bg color
         otpTxt1.backgroundColor = UIColor.clear
         otpTxt2.backgroundColor = UIColor.clear
         otpTxt3.backgroundColor = UIColor.clear
         otpTxt4.backgroundColor = UIColor.clear
         otpTxt5.backgroundColor = UIColor.clear
         otpTxt6.backgroundColor = UIColor.clear
        
        //otpTxt1.becomeFirstResponder()
        
        //add border
        addBottomBorder(textField: otpTxt1)
        addBottomBorder(textField: otpTxt2)
        addBottomBorder(textField: otpTxt3)
        addBottomBorder(textField: otpTxt4)
        addBottomBorder(textField: otpTxt5)
        addBottomBorder(textField: otpTxt6)
        
        //uitextfield delegate
        otpTxt1.delegate = self as? UITextFieldDelegate
        otpTxt2.delegate = self as? UITextFieldDelegate
        otpTxt3.delegate = self as? UITextFieldDelegate
        otpTxt4.delegate = self as? UITextFieldDelegate
        otpTxt5.delegate = self as? UITextFieldDelegate
        otpTxt6.delegate = self as? UITextFieldDelegate
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        otpTxt1.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        otpTxt2.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        otpTxt3.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        otpTxt4.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        otpTxt5.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        otpTxt6.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        
        //add done button above keyboard
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        otpTxt1.inputAccessoryView = toolbar
        otpTxt2.inputAccessoryView = toolbar
        otpTxt3.inputAccessoryView = toolbar
        otpTxt4.inputAccessoryView = toolbar
        otpTxt5.inputAccessoryView = toolbar
        otpTxt6.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otpTxt1.becomeFirstResponder()
    }
    
    
    @IBAction func lanjutBtn(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        guard let email = tempTampungTerima[0] as? String else { return }
        guard let username = tempTampungTerima[1] as? String else { return }
        guard let phonenumber = tempTampungTerima[2] as? String else { return }
        let combinedOTP = otpTxt1.text! + otpTxt2.text! + otpTxt3.text! + otpTxt4!.text! + otpTxt5.text! + otpTxt6.text!
        print("ini kodenya\(combinedOTP)")
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: combinedOTP)
        
        if connector().signUpIn(email: email, nama: username, phonenumber: phonenumber, kodeotp: credential){
            print("masuk pak eko")
        }
        
        
        
    }
    
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1) && (string.count > 0)
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
                otpTxt5.becomeFirstResponder()
            }
            if textField == otpTxt5
            {
                otpTxt6.becomeFirstResponder()
            }
            if textField == otpTxt6
            {
                otpTxt6.becomeFirstResponder()
            }
            
            //showing text
            textField.text = string
            return false
        }
        
        else if ((textField.text?.count)! >= 1) && (string.count == 0)
            
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
            
            if textField == otpTxt5
            {
                otpTxt4.becomeFirstResponder()
            }
            if textField == otpTxt6
            {
                otpTxt5.becomeFirstResponder()
            }
            if textField == otpTxt1
            {
                otpTxt1.becomeFirstResponder()
            }
            
            textField.text = ""
            return false
        }
            
        else if (textField.text?.count)! >= 1
        {
            textField.text = string
            return false
        }
        
        return true
    }
    
    func addBottomBorder(textField: UITextField)
    {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        
        textField.layer.addSublayer(layer)
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let otp1 = otpTxt1.text
        let otp2 = otpTxt2.text
        let otp3 = otpTxt3.text
        let otp4 = otpTxt4.text
        let otp5 = otpTxt5.text
        let otp6 = otpTxt6.text
        
        print("asu")
        //syaratnya
        let formFilled = otp1 != nil && otp1 != "" && otp2 != nil && otp2 != "" && otp3 != nil && otp3 != "" && otp4 != nil && otp4 != "" && otp5 != nil && otp5 != "" && otp6 != nil && otp6 != ""

        print(formFilled)
        if formFilled
        {
            setContinueButton(enabled: true)
        }
        
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    func resetForm() {
        
        setContinueButton(enabled: true)
        activityView.stopAnimating()
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        
    }
    @IBAction func `return`(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

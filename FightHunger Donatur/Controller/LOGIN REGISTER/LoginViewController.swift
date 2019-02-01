//
//  LoginViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController , UITextFieldDelegate,UIAlertViewDelegate{

    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var lnjtBtn: UIButton!
    @IBOutlet weak var telpTxtField: CustomTextField!
    @IBOutlet weak var continueButton: UIButton!
    var phonenumber = ""
    
    var activityView:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lnjtBtn.layer.cornerRadius = 6.0
        
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telpTxtField.inputAccessoryView = toolbar
        
        errorMssg.isHidden = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        //delegate textfield
        telpTxtField.delegate = self as? UITextFieldDelegate
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        telpTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width , height: 80.0)
    }
    
    

    @IBOutlet weak var errorMssg: UILabel!
    @IBAction func LanjutButton(_ sender: Any) {
        setContinueButton(enabled: false)
        
        activityView.startAnimating()
        
        let stringHeadChecker = String(phonenumber.prefix(1))
        if stringHeadChecker == "0"{
            phonenumber = "+62\(phonenumber.dropFirst(1))"
        } else if stringHeadChecker == "8"{
            phonenumber = "+62" + phonenumber
        }

        
        print("phonenumber:\(phonenumber)")
        
        connector().verifyLogin(phoneNo: phonenumber) { (status,errorText) in
            if status {
                //kalau berhasil
                
                self.performSegue(withIdentifier: "LoginToVerify", sender: nil)
                print("segue")
                
                
            } else {
                //ada error
                self.errorMssg.isHidden = false
                self.errorMssg.text = errorText
                self.resetForm()
            }
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
    
   
    
    @objc func textFieldChanged(_ target:UITextField) {
        guard let currentNumber = telpTxtField.text else {return}
        phonenumber = currentNumber
        //syaratnya
        let formFilled = phonenumber != nil && phonenumber != ""
        if formFilled
        {
            setContinueButton(enabled: true)
        }
        else if phonenumber == nil
        {
            errorMssg.isHidden = false
            errorMssg.text = "Phone number cannot be empty!"
            setContinueButton(enabled: false)
        }
        
    }
    
    
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    func resetForm() {
        
        setContinueButton(enabled: true)
        activityView.stopAnimating()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        
    }
    
}

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


    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var otpTxt6: UITextField!
    @IBOutlet weak var otpTxt5: UITextField!
    @IBOutlet weak var otpTxt4: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt1: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var userExistance: Bool!
    var tempTampungTerima = [String]()
    var activityView:UIActivityIndicatorView!
	var successLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessibility()
        continueButton.layer.cornerRadius = 6.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
//        back button
//        let buttonSize = CGFloat(16.0)
//        if #available(iOS 11.0, *){
////            backBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
////            backBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        }else{
////            var frame = backBtn.frame
////            frame.size.width = buttonSize
////            frame.size.height = buttonSize
////            backBtn.frame = frame
//        }
        
        
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
        otpTxt1.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        otpTxt2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        otpTxt3.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        otpTxt4.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        otpTxt5.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        otpTxt6.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        //add done button above keyboard
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:
            
            #selector(doneClicked))
        
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
//        self.navigationController?.navigationBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width , height: 80.0)
       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
   
    
    @IBAction func lanjutBtn(_ sender: Any) {
        setContinueButton(enabled: false)
        activityView.startAnimating()
        let defaults = UserDefaults.standard
        
        let combinedOTP = otpTxt1.text! + otpTxt2.text! + otpTxt3.text! + otpTxt4!.text! + otpTxt5.text! + otpTxt6.text!
        print("ini kodenya\(combinedOTP)")
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: combinedOTP)
        
        if userExistance{
            connector().logIn(kodeotp: credential) { (result) in
                if result{
					if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
						let controllers = self.navigationController?.viewControllers
						for vc in controllers! {
							if vc is DonatingController {
								_ = self.navigationController?.popToViewController(vc as! DonatingController, animated: true)
							}
						}
					}else {
						self.navigationController?.popToRootViewController(animated: true)
					}
                    //self.performSegue(withIdentifier: "LoginToHome", sender: nil)
                }
            }
        }else{
            guard let email = tempTampungTerima[0] as? String else { return }
            guard let username = tempTampungTerima[1] as? String else { return }
            guard let phonenumber = tempTampungTerima[2] as? String else { return }
            let status = defaults.bool(forKey: "ngepostDonasi")
            
            connector().signUp(email: email, nama: username, phonenumber: phonenumber, kodeotp: credential) { (result) in
                if result{
                    print("sukses untuk sign up / login")
                    if status {
						if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
							let data = DonatingController()
							self.navigationController?.popToViewController(data, animated: true)
						}else {
							self.navigationController?.popToRootViewController(animated: true)
						}
						
                        //self.performSegue(withIdentifier: "OTPToHome", sender: nil)
                    }
                }else{
                    print("gagal sign in di vc")
                }
            }
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
                otpTxt6.resignFirstResponder()
            }
            
            //showing text
            textField.text = string
            return false
        }
        
        else if ((textField.text?.count)! >= 1) && (string.count == 0)
            
        {
            if textField == otpTxt2
            {
                otpTxt1.resignFirstResponder()
            }
            
            if textField == otpTxt3
            {
                otpTxt2.resignFirstResponder()
            }
            
            if textField == otpTxt4
            {
                otpTxt3.resignFirstResponder()
            }
            
            if textField == otpTxt5
            {
                otpTxt4.resignFirstResponder()
            }
            if textField == otpTxt6
            {
                otpTxt5.resignFirstResponder()
            }
            if textField == otpTxt1
            {
                otpTxt1.resignFirstResponder()
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    
    func accessibility()
    {
        backBtn.isAccessibilityElement = true
        labelTitle.isAccessibilityElement = true
        backBtn.accessibilityTraits = UIAccessibilityTraits.button
        backBtn.accessibilityLabel = "Back"
        
     
        labelTitle.adjustsFontForContentSizeCategory = true
    }
}

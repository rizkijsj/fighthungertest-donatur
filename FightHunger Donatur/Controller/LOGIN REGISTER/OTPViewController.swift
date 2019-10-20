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


    @IBOutlet var textFieldsOutletCollection: [UITextField]!
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
	var textFieldsIndexes:[UITextField:Int] = [:]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		for index in 0 ..< textFieldsOutletCollection.count {
			textFieldsIndexes[textFieldsOutletCollection[index]] = index
		}
		
        accessibility()
        continueButton.layer.cornerRadius = 6.0
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

        //add border
        addBottomBorder(textField: otpTxt1)
        addBottomBorder(textField: otpTxt2)
        addBottomBorder(textField: otpTxt3)
        addBottomBorder(textField: otpTxt4)
        addBottomBorder(textField: otpTxt5)
        addBottomBorder(textField: otpTxt6)

        //uitextfield delegate
        otpTxt1.delegate = self
        otpTxt2.delegate = self
        otpTxt3.delegate = self
        otpTxt4.delegate = self
        otpTxt5.delegate = self
        otpTxt6.delegate = self
		
        //add done button above keyboard
		let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
		let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:
            
            #selector(doneClicked))
        
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        otpTxt1.inputAccessoryView = toolbar
        otpTxt2.inputAccessoryView = toolbar
        otpTxt3.inputAccessoryView = toolbar
        otpTxt4.inputAccessoryView = toolbar
        otpTxt5.inputAccessoryView = toolbar
        otpTxt6.inputAccessoryView = toolbar
    }
	
	enum Direction { case left, right }
	
	func setNextResponder(_ index:Int?, direction:Direction) {
		
		guard let index = index else { return }
		
		if direction == .left {
			index == 0 ?
				(_ = textFieldsOutletCollection.first?.resignFirstResponder()) :
				(_ = textFieldsOutletCollection[(index - 1)].becomeFirstResponder())
		} else {
			index == textFieldsOutletCollection.count - 1 ?
				(_ = textFieldsOutletCollection.last?.resignFirstResponder()) :
				(_ = textFieldsOutletCollection[(index + 1)].becomeFirstResponder())
		}
		
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		/*
		The commented code shows Replaces empty textfield with an empty character
		when deletion, the previous text will be deleted.
		
		If uncommented, the text will return to the previous
		*/
		
		//if textField.text == nil || textField.text == "" {
		textField.text = "\u{200B}"
		//}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		print("OTP Changed: \(string) + \(range.length) / \(range.description)")
		
		if range.length == 0 {
			if string == "0" || string == "1" || string == "2" || string == "3" || string == "4" || string == "5" || string == "6" || string == "7" || string == "8" || string == "9" {
				setNextResponder(textFieldsIndexes[textField], direction: .right)
				textField.text = string
				textFieldChanged(textField)
				return true
			}else {
				setNextResponder(textFieldsIndexes[textField], direction: .left)
				textField.text = ""
				textFieldChanged(textField)
				return false
			}
		} else if range.length == 1 {
			setNextResponder(textFieldsIndexes[textField], direction: .left)
			textField.text = ""
			textFieldChanged(textField)
			return false
		}
		return false
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
        
        let combinedOTP: String = "\(otpTxt1.text ?? "")\(otpTxt2.text ?? "")\(otpTxt3.text ?? "")\(otpTxt4.text ?? "")\(otpTxt5.text ?? "")\(otpTxt6.text ?? "")"
        print("ini kodenya\(combinedOTP)")
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: combinedOTP)
        
        if userExistance{
            connector().logIn(kodeotp: credential) { (result) in
                if result{
					self.successLogin = true
					if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
						print("Exit using Segue")
						self.dismiss(animated:true, completion: nil)
						//self.performSegue(withIdentifier: "completedOTP", sender: self)
					}else {
						print("Nope, Dismissed")
						self.dismiss(animated:true, completion: nil)
					}
					
                    //self.performSegue(withIdentifier: "LoginToHome", sender: nil)
				}else {
					self.dismiss(animated:true, completion: nil)
				}
            }
        }else{
            guard let email = tempTampungTerima[0] as? String else { return }
            guard let username = tempTampungTerima[1] as? String else { return }
            guard let phonenumber = tempTampungTerima[2] as? String else { return }
			
            connector().signUp(email: email, nama: username, phonenumber: phonenumber, kodeotp: credential) { (result) in
                if result{
                    print("sukses untuk sign up / login")
						self.successLogin = true
						if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
							print("Exit using Segue")
							self.dismiss(animated:true, completion: nil)
							//self.performSegue(withIdentifier: "completedOTP", sender: self)
						}else {
							print("Nope, Dismissed")
							self.dismiss(animated:true, completion: nil)
						}
                        //self.performSegue(withIdentifier: "OTPToHome", sender: nil)
                    }
            }
        }
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
        if formFilled{
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
        //self.dismiss(animated: true, completion: nil)
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

//
//  UbahprofilViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class UbahprofilViewController: UIViewController, UITextFieldDelegate {

    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        handleSaveProfile()
        
    }
    
    @IBOutlet weak var emailTxt: CustomTextField!
    
    @IBOutlet weak var namaTxt: CustomTextField!
    
    @IBOutlet weak var telfonTxt: CustomTextField!
    @IBOutlet weak var continueButton: UIBarButtonItem!
    var activityView:UIActivityIndicatorView!

    @IBOutlet weak var errorMssg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = view.center
        view.addSubview(activityView)
        
        emailTxt.delegate = self
        namaTxt.delegate = self
        telfonTxt.delegate = self
        errorMssg.isHidden = true
        //
        emailTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        namaTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        //add done button
		let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
		let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telfonTxt.inputAccessoryView = toolbar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          continueButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        loadUserProfileData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if namaTxt.isFirstResponder
        {
            emailTxt.becomeFirstResponder()
        }else
        {
            emailTxt.resignFirstResponder()
        }
        
        return false
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
		_ = telfonTxt.text
        //phonenumber = currentNumber
        let email = emailTxt.text
        let nama = namaTxt.text
        
        
        //syaratnya
        let formFilled = /*phonenumber != nil && phonenumber != "" &&*/ email != nil && email != "" && email?.contains("@") == true && email?.contains(".com") == true && nama != nil && nama != ""
        
        //testing
        print(formFilled)
        if formFilled
        {
            setContinueButton(enabled: true)
            errorMssg.isHidden = true
        }
//        else if phonenumber == nil || phonenumber == ""
//        {
//            errorMssg.isHidden = false
//            errorMssg.text = "Phone number cannot be empty!"
//            setContinueButton(enabled: false)
//        }
        else if email == nil || email == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Email cannot be empty!"
            setContinueButton(enabled: false)
        }else if nama == nil || nama == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Nama cannot be empty!"
            setContinueButton(enabled: false)
        }else if email?.contains("@") == false || email?.contains(".com") == false{
            errorMssg.isHidden = false
            errorMssg.text = "Enter the right email format"
            setContinueButton(enabled: false)
        }
        
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    
    @objc func handleSaveProfile() {
        
        activityView.startAnimating()
        
        guard let username = namaTxt.text else { return }
        guard let email = emailTxt.text else { return }
        // 1. Upload the profile image to Firebase Storage
        
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("Profile changed!")
                        
                        connector().saveProfile(username: username, email: email) { success in
                            if success {
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                self.resetForm()
                            }
                        }
                        
                    } else {
                        print("Error: \(error!.localizedDescription)")
                        self.resetForm()
                    }
                }
        
        
    }
    
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.tintColor = UIColor(displayP3Red: 193/255, green: 27/255, blue: 42/255, alpha: 1)
            continueButton.isEnabled = true
        } else {
            //continueButton.tintColor = .black
            continueButton.isEnabled = false
        }
    }
    
    func resetForm() {
        
        //setContinueButton(enabled: true)
        activityView.stopAnimating()
        setContinueButton(enabled: false)
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        
    }
    
    func loadUserProfileData(){
        guard let userProfile = UserService.currentUserProfile else { return }
        emailTxt.text = userProfile.email
        namaTxt.text =  userProfile.username
        telfonTxt.text = userProfile.phonenumber
    }
}

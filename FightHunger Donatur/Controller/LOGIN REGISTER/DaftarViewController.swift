//
//  DaftarViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class DaftarViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var errorMssg: UILabel!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var telpTxtField: CustomTextField!
    @IBOutlet weak var namaTxtField: CustomTextField!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var continueButton: UIButton!
    var activityView:UIActivityIndicatorView!
    
    var tempTampungKirim = [String]()
    var phonenumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
       continueButton.layer.cornerRadius = 6.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        //delegate textfield
        emailTxtField.delegate = self as? UITextFieldDelegate
        telpTxtField.delegate = self as? UITextFieldDelegate
        namaTxtField.delegate = self as? UITextFieldDelegate
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        telpTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        namaTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
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
    
    
    @objc func textFieldChanged(_ target:UITextField) {
        guard let currentNumber = telpTxtField.text else {return}
        phonenumber = currentNumber
        let email = emailTxtField.text
        let nama = namaTxtField.text
        
        
        //syaratnya
        let formFilled = phonenumber != nil && phonenumber != "" && email != nil && email != "" && email?.contains("@") == true && email?.contains(".com") == true && nama != nil && nama != ""
        
        //testing
        print(phonenumber.count)
        print(formFilled)
        if formFilled
        {
            setContinueButton(enabled: true)
            errorMssg.isHidden = true
        }
        else if phonenumber == nil || phonenumber == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Phone number cannot be empty!"
            setContinueButton(enabled: false)
        }
        else if email == nil || email == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Phone number cannot be empty!"
            setContinueButton(enabled: false)
        }else if nama == nil || nama == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Phone number cannot be empty!"
            setContinueButton(enabled: false)
        }else if email?.contains("@") == false || email?.contains(".com") == false{
            errorMssg.isHidden = false
            errorMssg.text = "Enter the right email format"
            setContinueButton(enabled: false)
        }
        
    }
    
    
    
    @IBAction func btnLanjut(_ sender: Any) {
        
        setContinueButton(enabled: false)
        
        activityView.startAnimating()
        
        let stringHeadChecker = String(phonenumber.prefix(1))
        if stringHeadChecker == "0"{
            phonenumber = "+62\(phonenumber.dropFirst(1))"
        } else if stringHeadChecker == "8"{
            phonenumber = "+62" + phonenumber
        }
        
        
        print("phonenumber:\(phonenumber)")
        connector().verifyRegister(phoneNo: phonenumber) { (status,errorText) in
            if status {
                //kalau berhasil
                    self.sendDataToNextVC()
                    self.performSegue(withIdentifier: "RegisToVerify", sender: nil)
                    print("segue")


            } else {
                //ada error
                self.errorMssg.isHidden = false
                self.errorMssg.text = errorText
                self.resetForm()
            }
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! OTPViewController
        info.tempTampungTerima = tempTampungKirim
        tempTampungKirim = []
    }
    
    func sendDataToNextVC(){
        tempTampungKirim.append(emailTxtField.text!)
        tempTampungKirim.append(namaTxtField.text!)
        tempTampungKirim.append(telpTxtField.text!)
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
        
        //setContinueButton(enabled: true)
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
}

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
	@IBOutlet weak var infoText: UITextView!
	
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
      self.navigationController?.popViewController(animated: true)
       // self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backBtn: UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
    }
    
    @IBOutlet weak var labelTitle: UILabel!
//    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var errorMssg: UILabel!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var telpTxtField: CustomTextField!
    @IBOutlet weak var namaTxtField: CustomTextField!
    
  
    @IBOutlet weak var continueButton: UIButton!
    var activityView:UIActivityIndicatorView!
    
    var tempTampungKirim = [String]()
    var phonenumber = ""
    
    func accessibility()
    {
        //backBtn.isAccessibilityElement = true
        labelTitle.isAccessibilityElement = true
        //backBtn.accessibilityTraits = UIAccessibilityTraits.button
        //backBtn.accessibilityLabel = "Back"
        labelTitle.adjustsFontForContentSizeCategory = true
    }
    
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
        
        
        
//        button back
//        let buttonSize = CGFloat(16.0)
//        if #available(iOS 11.0, *){
//            backBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//            backBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        }else{
//            var frame = backBtn.frame
//            frame.size.width = buttonSize
//            frame.size.height = buttonSize
//            backBtn.frame = frame
//        }
        
        //delegate textfield
        emailTxtField.delegate = self
        telpTxtField.delegate = self
        namaTxtField.delegate = self
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        telpTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        namaTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        //hidden label
        errorMssg.isHidden = true
        
        //add done button
		let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
		let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telpTxtField.inputAccessoryView = toolbar
        namaTxtField.inputAccessoryView = toolbar
        emailTxtField.inputAccessoryView = toolbar
		
		
				let textFont = UIFont.preferredFont(forTextStyle: .footnote)
		
		let htmlData =  NSString(string: "Dengan lanjut, anda setuju dengan <a href=\"https://www.fighthunger.id/privacypolicy.html\">kebijakan privasi</a> dan <a href=\"https://www.fighthunger.id/Termsandcondition.html\">syarat dan ketentuan</a>.").data(using: String.Encoding.unicode.rawValue)
        
		
		let attributedString:NSMutableAttributedString = try! NSMutableAttributedString(data: htmlData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
		
		print("Error here?")
		attributedString.addAttribute(.font, value: textFont, range: NSRange.init(location: 0, length: attributedString.length))
		//attributedString.attribute(.font: textFont)
		print("We have String?")
		infoText.attributedText = attributedString
		print("Did we crashed")
    }
    
    
    @objc func textFieldChanged(_ target:UITextField) {
        guard let currentNumber = telpTxtField.text else {return}
        phonenumber = currentNumber
        let email = emailTxtField.text
        let nama = namaTxtField.text
        
        
        //syaratnya
        let formFilled = !phonenumber.isEmpty && phonenumber != "" && email != nil && email != "" && isValidEmail(emailID: email ?? "") == true && nama != nil && nama != ""
        
        //testing
        print(phonenumber.count)
        print(formFilled)
        if formFilled
        {
            setContinueButton(enabled: true)
            errorMssg.isHidden = true
        }
        else if phonenumber.isEmpty || phonenumber == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Phone number cannot be empty!"
            setContinueButton(enabled: false)
        }
        else if email == nil || email == ""
        {
            errorMssg.isHidden = false
            errorMssg.text = "Email  cannot be empty!"
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
	func isValidEmail(emailID:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: emailID)
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
        info.userExistance = false
        tempTampungKirim = []
    }
    
    func sendDataToNextVC(){
        tempTampungKirim.append(emailTxtField.text!)
        tempTampungKirim.append(namaTxtField.text!)
        tempTampungKirim.append(phonenumber)
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
        
        setContinueButton(enabled: false)
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

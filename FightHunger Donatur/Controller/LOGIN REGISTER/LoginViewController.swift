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
    
    @IBAction func back(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var lnjtBtn: UIButton!
    @IBOutlet weak var telpTxtField: CustomTextField!
    @IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var textInfo: UITextView!
	var phonenumber = ""
    
    var dataPostTampungLoginVC = [String:Any]()
    
    var activityView:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        accessibility()
        lnjtBtn.layer.cornerRadius = 6.0
        
		let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
		let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,doneBtn], animated: false)
        
        telpTxtField.inputAccessoryView = toolbar
        
        errorMssg.isHidden = true
		
		
		let textFont = UIFont.preferredFont(forTextStyle: .footnote)
		/*
		let textAttributes: [NSAttributedString.Key: Any] = [
			.font: textFont
			]
		*/
		
		  let htmlData =  NSString(string: "Dengan lanjut, anda setuju dengan <a href=\"https://www.fighthunger.id/privacypolicy.html\">kebijakan privasi</a> dan <a href=\"https://www.fighthunger.id/Termsandcondition.html\">syarat dan ketentuan</a>.").data(using: String.Encoding.unicode.rawValue)

		
		let attributedString:NSMutableAttributedString = try! NSMutableAttributedString(data: htmlData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
		
		attributedString.addAttribute(.font, value: textFont, range: NSRange.init(location: 0, length: attributedString.length))
		//attributedString.attribute(.font: textFont)
		
		textInfo.attributedText = attributedString
		
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
//       back button
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
        
        
        
        
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        //delegate textfield
        telpTxtField.delegate = self
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        telpTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
       
    }
    
    func accessibility()
    {
        backBtn.isAccessibilityElement = true
        telpTxtField.isAccessibilityElement = true
        
        labelTitle.isAccessibilityElement = true
        
        backBtn.accessibilityTraits = UIAccessibilityTraits.button
        telpTxtField.accessibilityTraits = UIAccessibilityTraits.staticText
        
        backBtn.accessibilityLabel = "Back"
        telpTxtField.accessibilityLabel = "Nomor telfon"
        
        labelTitle.adjustsFontForContentSizeCategory = true
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! OTPViewController
        info.userExistance = true
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
		if phonenumber.count > 8{
			let formFilled = phonenumber != ""
			if formFilled{
				setContinueButton(enabled: true)
			}else{
				errorMssg.isHidden = false
				errorMssg.text = "Phone number cannot be empty!"
				setContinueButton(enabled: false)
			}
		}
        
    }
    
    
    
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    func resetForm() {
        
        setContinueButton(enabled: false)
        activityView.stopAnimating()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        
    }
    
}

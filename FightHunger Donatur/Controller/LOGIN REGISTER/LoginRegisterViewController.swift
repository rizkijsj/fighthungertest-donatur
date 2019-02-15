//
//  LoginRegisterViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        
		if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
//			let data = DonatingController()
//			print("lala")
//			self.navigationController?.popToViewController(data!, animated: true)
			
			let controllers = self.navigationController?.viewControllers
			for vc in controllers! {
				if vc is DonatingController {
					_ = self.navigationController?.popToViewController(vc as! DonatingController, animated: true)
				}
			}
		}else {
          
//            self.navigationController?.popToRootViewController(animated: true)
//                   performSegue(withIdentifier: "toNewHome", sender: self)
             self.dismiss(animated: true, completion: nil)
		}


       
    }
    
    func getScaledFont(forFont name: String, textStyle: UIFont.TextStyle) -> UIFont {
        
        let userFont =  UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let pointSize = userFont.pointSize
        guard let customFont = UIFont(name: name, size: pointSize) else {
            fatalError("""
                Failed to load the "\(name)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            return UIFont.init(name: name, size: 34)!
            // Fallback on earlier versions
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       btnMasuk.layer.cornerRadius = 6.0
       btnDaftar.layer.cornerRadius = 6.0
       accessibility()
        
        //donating.storyboard
         if let _ = UserDefaults.standard.object(forKey: "tempPostData") as? [String]{
            titleLabel.text = "Lanjutkan donasi anda!"
            bodyLabel.text =  "Data donasi anda akan tersimpan setelah masuk atau daftar"
          
            
        }// profile.storyboard
         else
         {
            titleLabel.text = "Mari kita berdonasi!"
            bodyLabel.text =  "Apakah anda siap berpartisipasi mengurangi kelaparan ?"
        }
		
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
        
    }
    

    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var btnMasuk: UIButton!
    
    @IBOutlet weak var btnDaftar: UIButton!
    
    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var lblMariMulai: UILabel!
 
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    func accessibility()
    {
        backBtn.isAccessibilityElement = true
        btnMasuk.isAccessibilityElement = true
        btnDaftar.isAccessibilityElement = true
        
        labelBody.isAccessibilityElement = true
        lblMariMulai.isAccessibilityElement = true
        
        
        //Button
        backBtn.accessibilityTraits = UIAccessibilityTraits.button
        backBtn.accessibilityLabel = "Back Button"
        
        //LABEL
        labelBody.adjustsFontForContentSizeCategory = true
        lblMariMulai.adjustsFontForContentSizeCategory = true
        
       
    }
    
}

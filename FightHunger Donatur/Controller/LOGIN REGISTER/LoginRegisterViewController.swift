//
//  LoginRegisterViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
//            performSegue(withIdentifier: "toNewHome", sender: self)
    }
    
    func getScaledFont(forFont name: String, textStyle: UIFont.TextStyle) -> UIFont {
        
        /// Uncomment the code below to check all the available fonts and have them printed in the console to double check the font name with existing fonts 😉
        
        /*for family: String in UIFont.familyNames
         {
         print("\(family)")
         for names: String in UIFont.fontNames(forFamilyName: family)
         {
         print("== \(names)")
         }
         }*/
        
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
        
        let buttonSize = CGFloat(16.0)
        if #available(iOS 11.0, *){
            backBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            backBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        }else{
            var frame = backBtn.frame
            frame.size.width = buttonSize
            frame.size.height = buttonSize
            backBtn.frame = frame
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
        
    }
    

    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnMasuk: UIButton!
    
    @IBOutlet weak var btnDaftar: UIButton!
    
    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var lblMariMulai: UILabel!
 
    
    @IBOutlet weak var backBtn: UIButton!
    
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

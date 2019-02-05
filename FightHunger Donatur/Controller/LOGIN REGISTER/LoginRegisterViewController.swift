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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

       btnMasuk.layer.cornerRadius = 6.0
       btnDaftar.layer.cornerRadius = 6.0
       accessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
   

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnMasuk: UIButton!
    
    @IBOutlet weak var btnDaftar: UIButton!
    
    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var lblMariMulai: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    func accessibility()
    {
        backBtn.isAccessibilityElement = true
        btnMasuk.isAccessibilityElement = true
        btnDaftar.isAccessibilityElement = true
        labelTitle.isAccessibilityElement = true
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

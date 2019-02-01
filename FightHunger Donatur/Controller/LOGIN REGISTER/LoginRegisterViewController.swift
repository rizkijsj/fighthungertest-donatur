//
//  LoginRegisterViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    @IBAction func backbutton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

       btnMasuk.layer.cornerRadius = 6.0
       btnDaftar.layer.cornerRadius = 6.0
        
    }
    

    @IBOutlet weak var btnMasuk: UIButton!
    
    @IBOutlet weak var btnDaftar: UIButton!
    

}

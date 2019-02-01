//
//  LoginRegisterViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    @IBAction func backToHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
            performSegue(withIdentifier: "toNewHome", sender: self)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

       btnMasuk.layer.cornerRadius = 6.0
       btnDaftar.layer.cornerRadius = 6.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    @IBOutlet weak var btnMasuk: UIButton!
    
    @IBOutlet weak var btnDaftar: UIButton!
    

}

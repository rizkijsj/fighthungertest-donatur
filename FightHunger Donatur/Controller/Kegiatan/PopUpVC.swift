//
//  PopUpVC.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 16/02/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    var imageimg = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

      imageView.image = imageimg
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
}

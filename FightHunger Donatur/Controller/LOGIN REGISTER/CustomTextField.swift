//
//  CustomTextField.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loginTextField()
    }
    
    private func loginTextField()
    {
        let Color = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = Color.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: bounds.size.height - width, width: bounds.size.width, height: bounds.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }

}

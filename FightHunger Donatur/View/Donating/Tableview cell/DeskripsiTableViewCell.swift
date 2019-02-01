//
//  DeskripsiTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class DeskripsiTableViewCell: UITableViewCell , UITextFieldDelegate{

    @IBOutlet weak var deskripsiTxt:CustomTextField!
   // var activeTxt: CustomTextField!
    
    //show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveKeyboard(textField: deskripsiTxt, moveDistance: -250, up: true)
    }
    
    //hide keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        moveKeyboard(textField: deskripsiTxt, moveDistance: -250, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        deskripsiTxt.resignFirstResponder()
        return true
    }
    
    func moveKeyboard(textField : CustomTextField , moveDistance: Float, up:Bool)
    {
        let MoveDuration = 0.3
        let movement = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("moveTextfield", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(MoveDuration)
       // self.contentView.frame = CGRectOffse
        UIView.commitAnimations()
    }
    
     
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       deskripsiTxt.delegate = self
   
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}

//
//  NamaTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class NamaTableViewCell: UITableViewCell , UITextFieldDelegate{

    @IBOutlet weak var namaTxt: CustomTextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        namaTxt.resignFirstResponder()
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       namaTxt.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

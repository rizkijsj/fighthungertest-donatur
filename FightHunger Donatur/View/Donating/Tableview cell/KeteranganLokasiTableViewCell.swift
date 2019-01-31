//
//  KeteranganLokasiTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class KeteranganLokasiTableViewCell: UITableViewCell , UITextFieldDelegate {

    @IBOutlet weak var keteranganTxt: CustomTextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        keteranganTxt.resignFirstResponder()
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        keteranganTxt.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}

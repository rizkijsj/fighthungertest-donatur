//
//  waktuPickerTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class waktuPickerTableViewCell: UITableViewCell , UIPickerViewDelegate , UIPickerViewDataSource{
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 0
	}
	
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
        
    }
    
    
    
    
   var hours = Array(0...23)
   var minutes = Array(0...59)
   var selectedTeks: String?
    
    @IBOutlet weak var textWaktu: CustomTextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SectionOneHomeCell.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class SectionOneHomeCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentStatus: UILabel!
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var contentExpiredDate: UILabel!
    @IBOutlet weak var contentOrganisationName: UILabel!
    @IBOutlet weak var contentOrganisationIcon: UIImageView!
    @IBOutlet weak var contentActivityTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

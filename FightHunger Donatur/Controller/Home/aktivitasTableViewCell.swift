//
//  aktivitasTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class aktivitasTableViewCell: UITableViewCell {

    @IBOutlet weak var wktPost: UILabel!
    @IBOutlet weak var namaOrg: UILabel!
    @IBOutlet weak var fotoOrg: UIImageView!
    @IBOutlet weak var kadaluarsaDonasi: UILabel!
    @IBOutlet weak var namaDonasi: UILabel!
    @IBOutlet weak var statusDonasi: UILabel!
    @IBOutlet weak var fotoDonasi: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

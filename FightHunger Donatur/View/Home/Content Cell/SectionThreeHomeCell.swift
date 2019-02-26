//
//  SectionThreeHomeCell.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Kingfisher

class SectionThreeHomeCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var contentAddress: UILabel!
    
	@IBOutlet weak var organizationCellCard: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		//mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
		contentImage.kf.cancelDownloadTask()
		contentImage.image = nil
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

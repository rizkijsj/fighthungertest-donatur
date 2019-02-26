//
//  SectionTwoHomeCell.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Kingfisher

class SectionTwoHomeCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentDesc: UILabel!
    @IBOutlet weak var contentOrganisationIcon: UIImageView!
    @IBOutlet weak var contentOrganisationName: UILabel!
    @IBOutlet weak var contentActivityDate: UILabel!
    
	@IBOutlet weak var programCellCard: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	override func prepareForReuse() {
		super.prepareForReuse()
		
		//mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
		contentImage.kf.cancelDownloadTask()
		contentImage.image = nil
		contentOrganisationIcon.kf.cancelDownloadTask()
		contentOrganisationIcon.image = nil
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

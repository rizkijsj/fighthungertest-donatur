//
//  SectionOneHomeCell.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Kingfisher

class SectionOneHomeCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentStatus: UILabel!
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var contentExpiredDate: UILabel!
    @IBOutlet weak var contentOrganisationName: UILabel!
    @IBOutlet weak var contentOrganisationIcon: UIImageView!
    @IBOutlet weak var contentActivityTime: UILabel!
	@IBOutlet weak var sectionItemCard: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		//mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
		contentImage.kf.cancelDownloadTask()
		contentImage.image = nil
		contentOrganisationIcon.kf.cancelDownloadTask()
		contentOrganisationIcon.image = nil
	}
  /*
    func set(post:Post) {
        
        ImageService.getImage(withURL: post.postphotourl) { image, url in
            self.contentImage.image = image
            
        }
        contentName.text = post.namaitem
        contentExpiredDate.text = post.deskripsi
        contentStatus.text = post.status
        contentActivityTime.text = post.waktuambil
        print(post.namaitem)
    }
    */
    /*
    func setOrg(post:Post) {
        
        ImageService.getImage(withURL: post.logokomunitas) { image, url in
            self.contentOrganisationIcon.image = image
            
        }
        contentName.text = post.namaitem
    }
    */
}

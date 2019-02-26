//
//  RiwayatTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Kingfisher

class RiwayatTableViewCell: UITableViewCell {

    @IBOutlet weak var keteranganWkt: UILabel!
    @IBOutlet weak var namaOrgn: UILabel!
    @IBOutlet weak var fotoOrgn: UIImageView!
    @IBOutlet weak var keteranganDonasi: UILabel!
    @IBOutlet weak var namaDonasi: UILabel!
    @IBOutlet weak var fotoDonasi: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	override func prepareForReuse() {
		super.prepareForReuse()
		
		//mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
		fotoDonasi.kf.cancelDownloadTask()
		fotoDonasi.image = nil
		fotoOrgn.kf.cancelDownloadTask()
		fotoOrgn.image = nil
	}

}

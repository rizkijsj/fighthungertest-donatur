//
//  KegiatanTerbaruController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class KegiatanTerbaruController: UITableViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var isiKegiatan: UILabel!
    @IBOutlet weak var titleKegiatan: UILabel!
    @IBOutlet weak var imgOrganisasi: UIImageView!

    @IBOutlet weak var btnDonasi: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

      
        tableView.delegate = self
        tableView.dataSource = self
        btnDonasi.layer.cornerRadius = 6.0
        
		
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
	

}

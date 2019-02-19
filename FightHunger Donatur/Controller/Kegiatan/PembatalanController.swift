//
//  PembatalanController.swift
//  
//
//  Created by Antonius George on 19/02/19.
//

import UIKit

class PembatalanController: UITableViewController {

	@IBOutlet weak var konfirmasiBtn: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()

       konfirmasiBtn.layer.cornerRadius = 6.0
		
    }

	@IBAction func cancelBtn(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        if section == 0
		{
			return 1
		}else if section == 1
		{
			return 5
		}else
		{
			return 1
		}
    }

	

}

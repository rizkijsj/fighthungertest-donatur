//
//  PembatalanController.swift
//  
//
//  Created by Antonius George on 19/02/19.
//

import UIKit

class PembatalanController: UITableViewController {

	@IBOutlet weak var textViewLabel: UITextView!
	@IBOutlet weak var konfirmasiBtn: UIButton!
	
	//var selectedIndexpath:IndexPath?
	override func viewDidLoad() {
        super.viewDidLoad()

       konfirmasiBtn.layer.cornerRadius = 6.0
	   textViewLabel.isHidden = true
    }

	@IBAction func cancelBtn(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	// MARK: - Table view data source

	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0
		{
			if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4
			{
				tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
			}
			
			else
			{
				tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
				textViewLabel.isHidden = false
			}
		}
		
	}
	
	

	

}

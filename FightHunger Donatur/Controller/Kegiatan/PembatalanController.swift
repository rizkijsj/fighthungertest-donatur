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
	
	var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
	
	
	//var selectedIndexpath:IndexPath?
	override func viewDidLoad() {
        super.viewDidLoad()

       konfirmasiBtn.layer.cornerRadius = 6.0
	   textViewLabel.isHidden = true
		textViewLabel.layer.borderColor = UIColor.black.cgColor
		textViewLabel.layer.borderWidth = 1.0
    }

	@IBAction func cancelBtn(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	// MARK: - Table view data source
	
	func resetChecked(){
		for inRow in 1...5 {
			tableView.cellForRow(at: IndexPath(row: inRow, section: 0))?.accessoryType = .none
		}
	}

	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0
		{
			resetChecked()
			if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4
			{
				tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
				
				selectedIndex = indexPath
				textViewLabel.isHidden = true
			}
			
			else
			{
				tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
				selectedIndex = indexPath
				textViewLabel.isHidden = false
				
			}
		}
		
	}
	
	

	

}

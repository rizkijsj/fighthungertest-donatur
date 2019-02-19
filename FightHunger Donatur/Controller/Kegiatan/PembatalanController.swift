//
//  PembatalanController.swift
//  
//
//  Created by Antonius George on 19/02/19.
//

import UIKit

class PembatalanController: UITableViewController, UITextViewDelegate {

	@IBOutlet weak var textViewLabel: UITextView!
	@IBOutlet weak var konfirmasiBtn: UIButton!
	
	@IBOutlet weak var reason1: UILabel!
	@IBOutlet weak var reason2: UILabel!
	@IBOutlet weak var reason3: UILabel!
	@IBOutlet weak var reason4: UILabel!
	
	
	var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
	var reasonCancelling:String = ""
	
	
	//var selectedIndexpath:IndexPath?
	override func viewDidLoad() {
        super.viewDidLoad()

       konfirmasiBtn.layer.cornerRadius = 6.0
	   textViewLabel.isHidden = true
		//textViewLabel.layer.borderColor = UIColor.black.cgColor
		//textViewLabel.layer.borderWidth = 1.0
		
		textViewLabel.clipsToBounds = false
		textViewLabel.layer.applySketchShadow(
			color: .black,
			alpha: 1,
			x: 0,
			y: 0,
			blur: 1,
			spread: 0
		)
		self.hideKeyboardWhenTappedAround() 
		textViewLabel.delegate = self

    }
	
	func textViewDidChange(_ textView: UITextView) {
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		self.tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
		self.tableView.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}else if text == "|"{
			return false
		}
		return true
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func getReason() -> String {
		var reason:String = ""
		
		if selectedIndex.row == 1 {
			reason = reason1.text!
		}else if selectedIndex.row == 2{
			reason = reason2.text!
		}else if selectedIndex.row == 3{
			reason = reason3.text!
		}else if selectedIndex.row == 4{
			reason = reason4.text!
		}else if selectedIndex.row == 5{
			reason = textViewLabel.text
		}
		
		return reason
	}

	@IBAction func confirmCancel(_ sender: Any) {
		//self.dismiss(animated: true, completion: nil)
		reasonCancelling = getReason()
		performSegue(withIdentifier: "cancellingDonation", sender: self)
	}
	// MARK: - Table view data source
	@IBAction func cancelCancelling(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
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
				textViewLabel.becomeFirstResponder()
				
			}
		}
		
	}
	
	

	

}

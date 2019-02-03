//
//  NewHomeViewController.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class NewHomeViewController: UIViewController {
	
	@IBOutlet weak var donateButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	// activity data should always referred to your data source, which it will be real time updated data
	var activityData = [1]
	var temporaryArrayData = ["asd", "bsdn", "kausrg", "asjdfyr"]
	// new activity data should always referred to your data source, which it will be real time updated data
	var newActivityData = [1,3]
	// partner data should always referred to your data source, which it will be real time updated data
	var partnerData = [1,2,3]
	
	var activityList = connector().transactionList()
	var organizationList = connector().organizationList()
	var programList = connector().programList()
	
	var selectedIndexPath:IndexPath?
	var toDetail:Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Set what needs to display within your view
		setupView()
	}
	
	func setupView(){
		// Register all required cell that have to display in UITableView
		tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
		tableView.register(UINib(nibName: "SectionTwoHomeCell", bundle: nil), forCellReuseIdentifier: "newActivityCellID")
		tableView.register(UINib(nibName: "SectionThreeHomeCell", bundle: nil), forCellReuseIdentifier: "partnerCellID")
		
		// Set the donate button corner radius to comply design requirement
		donateButton.layer.cornerRadius = donateButton.frame.height / 4
		donateButton.layer.masksToBounds = true
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if toDetail {
			
		}else{
			guard let nextIndexPath = selectedIndexPath else {return}
			
			if nextIndexPath.section == 0 {
				let activityVC = segue.destination as! KegiatanViewController
				activityVC.passingObject = activityList[nextIndexPath.row]
				activityVC.transactionID = activityList[nextIndexPath.row].id
			}else if nextIndexPath.section == 1{
				/// MARK: - TODO
				/// Does program controller does not exist
				
				//let programVC = segue.destination as! KegiatanViewController
				//programVC = programList[nextIndexPath.row]
			}else if nextIndexPath.section == 2{
				let organizationVC = segue.destination as! Organisasi
				organizationVC.organisasiObject = organizationList[nextIndexPath.row]
				organizationVC.organisasiID = organizationList[nextIndexPath.row].id
			}
		}
	}
	
}

extension NewHomeViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		// Consider to use section to separate the content based on design objective, "Activity" section, "New Activity" Section, "Partner" Section
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return activityList.count
		case 1:
			return programList.count
		case 2:
			return organizationList.count
		default:
			return 0
		}
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.white
		//headerView.isUserInteractionEnabled = true
		let label = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 44))
		label.textColor = .black
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		headerView.addSubview(label)
		
		//let seeMore = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
		let seeMore = UILabel(frame: CGRect(x: -16, y: 0, width: self.view.frame.width, height: 44))
		seeMore.textColor = .red
		seeMore.textAlignment = .right
		seeMore.text = "Semua"
		seeMore.isUserInteractionEnabled = true
		seeMore.font = UIFont.preferredFont(forTextStyle: .caption1)
		
		switch section {
		case 0:
			label.text = "Aktivitas"
		case 1:
			label.text = "Kegiatan Terbaru"
			
			let openMoreProgram = UITapGestureRecognizer.init(target: self, action: #selector(toMoreProgram))
			seeMore.gestureRecognizers = [openMoreProgram]
			headerView.addSubview(seeMore)
		case 2:
			label.text = "Mitra Kami"
			
			let openMoreOrganization = UITapGestureRecognizer.init(target: self, action: #selector(toMoreOrganization))
			seeMore.gestureRecognizers = [openMoreOrganization]
			headerView.addSubview(seeMore)
		default:
			label.text = ""
		}
		return headerView
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		toDetail = false
		
		if indexPath.section == 0{
			selectedIndexPath = indexPath
			print("Somewhere in Activity with \(activityList[indexPath.row].name)")
		}else if indexPath.section == 1 {
			selectedIndexPath = indexPath
			print("Somewhere in Program with \(programList[indexPath.row].name)")
		}else if indexPath.section == 2 {
			selectedIndexPath = indexPath
			print("Somewhere in Organization with \(organizationList[indexPath.row].name)")
		}
		
		
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			return 150
		case 1:
			return 324
		case 2:
			return 88
		default:
			return 0
		}
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let dateFormat = DateFormatter()
		let timeFormat = DateFormatter()
		dateFormat.locale = Locale.init(identifier: "Id")
		timeFormat.locale = Locale.init(identifier: "Id")
		dateFormat.dateFormat = "MMMM dd yyyy"
		timeFormat.dateFormat = "HH:mm"
		
		switch indexPath.section {
		case 0:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as? SectionOneHomeCell)!
			
			
			
			loadImage(link: activityList[indexPath.row].image, object: cell.contentImage)
			
			cell.contentName.text = activityList[indexPath.row].name
			cell.contentStatus.text = updateDonationStatus(donationStage: activityList[indexPath.row].status)
			cell.contentExpiredDate.text = activityList[indexPath.row].description
			
			
			cell.contentActivityTime.text = timeFormat.string(from: activityList[indexPath.row].pickUpTime)
			
			if activityList[indexPath.row].status > 1 {
				if let orgID = activityList[indexPath.row].organizationId, let orgObject = connector().organizationDetail(organizationID: orgID){
					loadImage(link: orgObject.logo, object: cell.contentOrganisationIcon)
					cell.contentOrganisationName.text = orgObject.name
				}
			}else {
				cell.contentOrganisationName.text = ""
				cell.contentOrganisationIcon.image = nil
			}
			
			return cell
		case 1:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "newActivityCellID", for: indexPath) as? SectionTwoHomeCell)!
			
			return cell
		case 2:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "partnerCellID", for: indexPath) as? SectionThreeHomeCell)!
			
			return cell
		default:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as? SectionOneHomeCell)!
			
			return cell
		}
		
		
	}
	
	
	//hide navbar when scrolling
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		if(velocity.y>0) {
			//Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
			UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(true, animated: true)
				
				//print("Hide")
			}, completion: nil)
			
		} else {
			UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(false, animated: true)
				
				//print("Unhide")
			}, completion: nil)
		}
	}
	
	func loadImage(link:String, object: UIImageView){
		DispatchQueue.global(qos: .background).async {
			let imageFile = UIImage.init(url: URL.init(string: link))
			
			DispatchQueue.main.async {
				object.image = imageFile!
			}
			
		}
	}
	func updateDonationStatus(donationStage:Int) -> String{
		
		switch donationStage {
		case 1:
			return "Menunggu Claim"
		case 2:
			return "Menunggu Kurir"
		case 3:
			return "Di Jemput"
		case 4:
			return "Di Antar"
		default:
			return ""
		}
		
	}
	
	@objc func toMoreProgram(){
		toDetail = true
		print("Should segue to More Programs here")
	}
	
	@objc func toMoreOrganization(){
		toDetail = true
		print("Should segue to More Organization Here")
	}
	
}

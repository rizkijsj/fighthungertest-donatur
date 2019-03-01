//
//  NewHomeViewController.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import StoreKit

import Firebase
import Kingfisher
import DeepDiff

class NewHomeViewController: UIViewController {
	
	@IBOutlet weak var donateButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var profileButtonOutlet: UIButton!
	
	let repeatedLoginAttempt = RepeatingTimer(timeInterval: 5)
	
	var posts = [Post]()
	var organisasi = [OrganisasiProfile]()
    //var kegiatans = [Kegiatan]()
    
    var selectedKegiatanObject:Kegiatan?
	// activity data should always referred to your data source, which it will be real time updated data
	var activityData = [1]
	var temporaryArrayData = ["asd", "bsdn", "kausrg", "asjdfyr"]
	// new activity data should always referred to your data source, which it will be real time updated data
	var newActivityData = [1,3]
	// partner data should always referred to your data source, which it will be real time updated data
	var partnerData = [1,2,3]
	
	//var activityListRaw = connector().transactionList()
	var activityList:[Post] = []
	var organizationList:[OrganisasiProfile] = []
	var programList:[Kegiatan] = []
	
	var skipLoadActivity = false
	var skipLoadOrganization = false
	var skipLoadProgramList = false
	
	var selectedIndexPath:IndexPath?
	var toDetail:Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Set what needs to display within your view
		
		//self.tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
//		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
		
		profileButtonOutlet.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
		profileButtonOutlet.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
		profileButtonOutlet.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
		
		self.navigationController?.hidesBarsOnSwipe = true
		
		setupView()
		UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		UserDefaults.standard.synchronize()
		
		self.profileButtonOutlet.imageView?.image = UIImage.init(named: "profilBtn")!
		self.profileButtonOutlet.titleLabel?.text = ""
		self.profileButtonOutlet.tintColor = .black
		
		
		repeatedLoginAttempt.eventHandler = {
			if let userProfile = UserService.currentUserProfile {
				
				if self.activityList.isEmpty {
					self.skipLoadActivity = false
				}
				
				let uid = userProfile.uid
				self.observePost(id: uid)
				self.repeatedLoginAttempt.suspend()
			} else {print("Error")}
		}
		/*
		programList.append(programObject.init(proId: "123", orgID: "123", proName: "Aksi anti kelaparan balita", proLocName: "Jalan Melati timur, Jakarta Barat", proLocCoor: CLLocationCoordinate2D.init(latitude: 106, longitude: -5) , proTime: "30 Februari 2019", proDesc: "Memberikan pelajaran kepada calon orang tua tentang gizi yang di butuhkan oleh balita untuk tumbuh sehat", proImageLink: "https://media.beritagar.id/2018-07/d40a43d6130bc0eb4269f1e383f9c27d.jpg"))
	
		programList.append(programObject.init(proId: "321", orgID: "321", proName: "Penyaluran sumbangan untuk gempa", proLocName: "Jalan H. Mamot, Jakarta Utara", proLocCoor: CLLocationCoordinate2D.init(latitude: 106, longitude: -5) , proTime: "30 Februari 2019", proDesc: "Gempa yang terjadi bulan ini masih terasa dampaknya. Maka untuk membantu korban gempa dengan menyalurkan sembako yang terkumpul atas nama organisasi kami. ", proImageLink: "https://upload.wikimedia.org/wikipedia/commons/a/ae/Korban-tewas-gempa-ekuador-lebih-650-orang-232427-1.jpg"))
		*/
		
		
		let tapDonateButton = UITapGestureRecognizer.init(target: self, action: #selector(toDonate))
		donateButton.addGestureRecognizer(tapDonateButton)
		repeatedLoginAttempt.resume()
		
		
		DispatchQueue.main.async {
			print("Observing Organisasi")
			self.observeOrganisasi()
			
			print("Observing Kegiatan")
			self.observeKegiatan()
		}
		
		self.tableView.reloadData()
		
		
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1), NSAttributedString.Key.font:UIFont.init(name: "Avenir-Heavy", size: 22)!]
		self.navigationController?.hidesBarsOnSwipe = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewHomeViewController.networkStatusChanged(_:)), name: NSNotification.Name(ReachabilityStatusChangedNotification), object: nil )
        NetworkHelper().monitorReachabilityChanges()
        
		//observePosts()
		//self.tableView.reloadData()
		
		if UserDefaults.standard.bool(forKey: "willShowReview") && !UserDefaults.standard.bool(forKey: "willShowReviewHasbeenShown"){
			UserDefaults.standard.set(true, forKey: "willShowReviewHasbeenShown")
			
			if #available(iOS 10.3, *) {
				SKStoreReviewController.requestReview()
			}
			
		}
		
		
		if UserDefaults.standard.bool(forKey: "willShowSuccess") && !UserDefaults.standard.bool(forKey: "willAcceptedHasbeenShown"){
			UserDefaults.standard.set(true, forKey: "willAcceptedHasbeenShown")
			if #available(iOS 10.3, *) {
				SKStoreReviewController.requestReview()
			}
			
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.hidesBarsOnSwipe = false
		self.navigationController?.navigationBar.isHidden = false
	}
    
    @objc func networkStatusChanged(_ notification: NSNotification ) {
        let status = NetworkHelper().connectionStatus()
        print(status)
        switch status {
        case .offline:
            let offlineAlert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
            offlineAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(offlineAlert,animated: true,completion: nil)
        case .online(.wwan),.unknown: break
            
            //self.observePost()
        case .online(.wiFi): break
            
            //self.observePosts()
        }
    }
	
	func setupView(){
		// Register all required cell that have to display in UITableView
		tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
		tableView.register(UINib(nibName: "SectionTwoHomeCell", bundle: nil), forCellReuseIdentifier: "newActivityCellID")
		tableView.register(UINib(nibName: "SectionThreeHomeCell", bundle: nil), forCellReuseIdentifier: "partnerCellID")
		
		// Set the donate button corner radius to comply design requirement
		donateButton.layer.cornerRadius = donateButton.frame.height / 6
		donateButton.layer.masksToBounds = true
	}
	
	
	
	@IBAction func toProfile(_ sender: UIButton) {
		selectedIndexPath = nil
		toDetail = false
		connector().verifyUserLoginState { (state) in
			if state{
				self.performSegue(withIdentifier: "Profil", sender: self)
				
			}else{
				self.performSegue(withIdentifier: "Login", sender: self)
				
			}
		}
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print(self.posts)
		if toDetail {
			
		}else{
			guard let nextIndexPath = selectedIndexPath else {return}
			
			if nextIndexPath.section == 0 {
				let activityVC = segue.destination as! KegiatanViewController
				activityVC.passingObject = activityList[nextIndexPath.row]
				activityVC.transactionID = activityList[nextIndexPath.row].id
				activityVC.passingOrgObject = organizationList
			}else if nextIndexPath.section == 1{
				let programVC = segue.destination as! KegiatanTerbaruController
				programVC.passingObject = programList[nextIndexPath.row]
			}else if nextIndexPath.section == 2{
				let organizationVC = segue.destination as! Organisasi
				organizationVC.organisasiObject = organizationList[nextIndexPath.row]
			}
		}
		if segue.identifier == "Profil" {
			let vc = segue.destination as! ProfilController
			vc.passingOrgObject = organizationList
            
		}
		
		/*
		if segue.identifier == "Login" {
			let navigation: UINavigationController = segue.destination as! UINavigationController
			
			var vc = LoginRegisterViewController.init()
			vc = navigation.viewControllers[0] as! LoginRegisterViewController
			//if you need send something to destnation View Controller
			//vc.delegate = self
		}
		*/
		
	}
	
	func processOngoingDonation(rawData:[Post],completion: @escaping ([Post]) -> Void){
		
		var filteredData:[Post] = []
		
		rawData.forEach { (post) in
			if post.status == 1{
				filteredData.append(post)
			}else if post.status == 2{
				filteredData.append(post)
			}else if post.status == 3{
				filteredData.append(post)
			}else if post.status == 4{
				filteredData.append(post)
			}else if post.status == 5{
				UserDefaults.standard.set(true, forKey: "willShowSuccess")
			}
		}
        filteredData.sort(by: {$0.timestamp > $1.timestamp})
		completion(filteredData)
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
		if section == 0 && activityList.count == 0 {
			return 0
		} else if section == 1 && programList.count == 0 {
			return 0
		} else if section == 2 && organizationList.count == 0 {
			return 0
		}
		return 44
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = .white
		//UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
		//headerView.isUserInteractionEnabled = true
		let label = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 44))
		label.textColor = .black
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		headerView.addSubview(label)
		
		//let seeMore = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
		let seeMore = UILabel(frame: CGRect(x: -16, y: 0, width: self.view.frame.width, height: 44))
		seeMore.textColor = .red
		seeMore.textAlignment = .right
		//seeMore.text = "Lihat Semua"
		seeMore.isUserInteractionEnabled = true
		seeMore.font = UIFont.preferredFont(forTextStyle: .caption1)
		
		switch section {
		case 0:
			label.text = "Aktivitas"
			if activityList.count == 0{
				headerView.isHidden = true
			}
		case 1:
			label.text = "Kegiatan Terbaru"
			/*
			let openMoreProgram = UITapGestureRecognizer.init(target: self, action: #selector(toMoreProgram))
			seeMore.gestureRecognizers = [openMoreProgram]
			headerView.addSubview(seeMore)
			*/
			if programList.count == 0{
				headerView.isHidden = true
			}
		case 2:
			label.text = "Mitra Kami"
			/*
			let openMoreOrganization = UITapGestureRecognizer.init(target: self, action: #selector(toMoreOrganization))
			seeMore.gestureRecognizers = [openMoreOrganization]
			headerView.addSubview(seeMore)
			*/
			if organizationList.count == 0{
				headerView.isHidden = true
			}
		default:
			label.text = ""
		}
		return headerView
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		toDetail = false
		
		if indexPath.section == 0{
			selectedIndexPath = indexPath
			print("Somewhere in Activity with \(activityList[indexPath.row].namaitem)")
			self.performSegue(withIdentifier: "keAktivitas", sender: self)
		}else if indexPath.section == 1 {
			selectedIndexPath = indexPath
			print("Somewhere in Program with \(programList[indexPath.row].programName)")
			self.performSegue(withIdentifier: "toProgram", sender: self)
		}else if indexPath.section == 2 {
			selectedIndexPath = indexPath
			print("Somewhere in Organization with \(organizationList[indexPath.row].name)")
			self.performSegue(withIdentifier: "toOrg", sender: self)
		}
		
		
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		
		switch indexPath.section {
		case 0:
			return 192
		case 1:
			return 376
		case 2:
			return 136
		default:
			return 0
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return ""
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
			
			cell.sectionItemCard.backgroundColor = .white
			cell.sectionItemCard.layer.cornerRadius = cell.sectionItemCard.frame.height / 16
			//cell.sectionItemCard.clipsToBounds = true
			cell.sectionItemCard.layer.applySketchShadow(
				color: .lightGray,
				alpha: 0.5,
				x: 0,
				y: 1,
				blur: 4,
				spread: 0
			)
			
			cell.contentImage.layer.cornerRadius = cell.contentImage.frame.height / 16
			cell.contentName.text = activityList[indexPath.row].namaitem
			cell.contentStatus.text = updateDonationStatus(donationStage: activityList[indexPath.row].status)
			
			let descriptions = activityList[indexPath.row].deskripsi.split(separator: "|")
			
			cell.contentExpiredDate.text = "\(descriptions[2].dropFirst(1))"
			cell.contentActivityTime.text = timeFormat.string(from: Date(timeIntervalSince1970: activityList[indexPath.row].waktuambil))
			
			cell.contentImage.kf.indicatorType = .activity
			cell.contentImage.kf.setImage(
				with: activityList[indexPath.row].postphotourl,
				placeholder: UIImage.init(color: .white),
				options: [
					.transition(.fade(1))
				])
			{
				result in
				switch result {
				case .success( _):
					print("Yey")
				case .failure( _):
					print("Nay")
				}
			}
			
			/*
			ImageService.getImage(withURL: activityList[indexPath.row].postphotourl) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
			*/
			if activityList[indexPath.row].status == 2 || activityList[indexPath.row].status == 3 || activityList[indexPath.row].status == 4{
				
				cell.contentOrganisationName.text = activityList[indexPath.row].namakomunitas
				//cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
				//cell.contentOrganisationIcon.kf.setImage(with: activityList[indexPath.row].logokomunitas)
				cell.contentOrganisationIcon.kf.indicatorType = .activity
				cell.contentOrganisationIcon.kf.setImage(
					with: activityList[indexPath.row].logokomunitas,
					placeholder: UIImage.init(color: .white),
					options: [
						.transition(.fade(1))
					])
				{
					result in
					switch result {
					case .success( _):
						print("Yey")
					case .failure( _):
						print("Nay")
					}
				}
				/*
				ImageService.getImage(withURL: activityList[indexPath.row].logokomunitas) { image, url, fromCache in
					if fromCache {
						cell.contentOrganisationIcon.image = image
					} else {
						self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
					}
				}
				*/
				
			}else {
				cell.contentOrganisationName.text = ""
				cell.contentOrganisationIcon.image = nil
			}
			
			//cell.set(post: posts[indexPath.row])
			
			return cell
		case 1:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "newActivityCellID", for: indexPath) as? SectionTwoHomeCell)!
			cell.programCellCard.backgroundColor = .white
			cell.programCellCard.layer.cornerRadius = cell.programCellCard.frame.height / 24
			//cell.sectionItemCard.clipsToBounds = true
			cell.programCellCard.layer.applySketchShadow(
				color: .lightGray,
				alpha: 0.5,
				x: 0,
				y: 1,
				blur: 4,
				spread: 0
			)

			cell.contentImage.kf.indicatorType = .activity
			cell.contentImage.kf.setImage(
				with: programList[indexPath.row].programImage,
				placeholder: UIImage.init(color: .white),
				options: [
					.transition(.fade(1))
				])
			{
				result in
				switch result {
				case .success( _):
					print("Yey")
				case .failure( _):
					print("Nay")
				}
			}
			
			/*
			ImageService.getImage(withURL: programList[indexPath.row].programImage) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
			*/
			cell.contentActivityDate.text = programList[indexPath.row].programDate
			cell.contentTitle.text = programList[indexPath.row].programName
			cell.contentDesc.text = programList[indexPath.row].programInformation
			
			cell.contentOrganisationName.text = programList[indexPath.row].orgName
			
			cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
			
			DispatchQueue.main.async {
				self.organizationList.forEach { (orgProfile) in
					if orgProfile.id == self.programList[indexPath.row].orgId {
						cell.contentOrganisationIcon.kf.indicatorType = .activity
						cell.contentOrganisationIcon.kf.setImage(
							with: orgProfile.logo,
							placeholder: UIImage.init(color: .white),
							options: [
								.transition(.fade(1))
							])
						{
							result in
							switch result {
							case .success( _):
								print("Yey")
							case .failure( _):
								print("Nay")
							}
						}
						
						/*
						ImageService.getImage(withURL: orgProfile.logo ) { image, url, fromCache in
							if fromCache {
								cell.contentOrganisationIcon.image = image
							} else {
								self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
							}
							return
						}
						*/
					}
				}
			}
			
			
			
			
			return cell
		case 2:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "partnerCellID", for: indexPath) as? SectionThreeHomeCell)!
	
			cell.organizationCellCard.backgroundColor = .white
			cell.organizationCellCard.layer.cornerRadius = cell.organizationCellCard.frame.height / 8
			//cell.sectionItemCard.clipsToBounds = true
			cell.organizationCellCard.layer.applySketchShadow(
				color: .lightGray,
				alpha: 0.5,
				x: 0,
				y: 1,
				blur: 4,
				spread: 0
			)
			
			cell.contentName.text = organizationList[indexPath.row].name
			cell.contentAddress.text = organizationList[indexPath.row].locationName
		
			cell.contentImage.kf.indicatorType = .activity
			cell.contentImage.kf.setImage(
				with: organizationList[indexPath.row].logo,
				placeholder: UIImage.init(color: .white),
				options: [
					.transition(.fade(1))
				])
			{
				result in
				switch result {
				case .success( _):
					print("Yey")
				case .failure( _):
					print("Nay")
				}
			}
			/*
			ImageService.getImage(withURL: organizationList[indexPath.row].logo) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
			*/
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
			UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(true, animated: true)
				self.donateButton.updateConstraintsIfNeeded()
				self.view.layoutIfNeeded()
				//print("Hide")
			}, completion: nil)
		} else {
			UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(false, animated: true)
				self.donateButton.updateConstraintsIfNeeded()
				self.view.layoutIfNeeded()
				//print("Unhide")
			}, completion: nil)
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
	
	@objc func toDonate(){
		toDetail = false
		selectedIndexPath = nil
		performSegue(withIdentifier: "PostDonasi", sender: self)
		print("Should segue to More Programs here")
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

extension NewHomeViewController{
	
	
	
	func observePost(id: String) {
		
		let postsRef = Database.database().reference().child("UsersPost/\(id)/")
		
		print(id)
		postsRef.observe(.value, with: { snapshot in
			if self.skipLoadActivity {self.skipLoadActivity = false; return }
			var tempPosts = [Post]()
			//var tempIdProfile = String
			
			for child in snapshot.children {
				if let childSnapshot = child as? DataSnapshot,
					let dict = childSnapshot.value as? [String:Any],
					
					let author = dict["author"] as? [String:Any],
					let uid = author["uid"] as? String,
					let email = author["email"] as? String,
					let name = author["username"] as? String,
					let phnumber = author["phonenumber"] as? String,
					
					//					let organisasi = dict["komunitas"] as? [String:Any],
					//					let orgID = organisasi["id"] as? String,
					//					let orgName = organisasi["name"] as? String,
					//					let orgDesc = organisasi["description"] as? String,
					//					let orgLink = organisasi["link"] as? String,
					//					let orgLogo = organisasi["logo"] as? String,
					//					let orgEmail = organisasi["email"] as? String,
					//					let orgPhone = organisasi["phone"] as? String,
					//					let orgLocName = organisasi["locationname"] as? String,
					//					let orgLocCoor = organisasi["locationcoor"] as? [String:Any],
					//					let orgLati = orgLocCoor["latitude"] as? String,
					//					let orgLong = orgLocCoor["longitude"] as? String,
					
					let komunitas = dict["komunitas"] as? [String:Any],
					let id = komunitas["id"] as? String,
					let logo = komunitas["logo"] as? String,
					let namakomunitas = komunitas["name"] as? String,
					let logourl = URL(string: logo),
					let phonenumber = komunitas["phone"] as? String,
					
					
					
					let alamat = dict["alamat"] as? [String:Any],
					let address = alamat["namalokasi"] as? String,
					let keteranganlokasi = alamat["keteranganlokasi"] as? String,
					let latitude = alamat["latitude"] as? Double,
					let longitude = alamat["longitude"] as? Double,
					
					
					
					let transaksi = dict["transaksi"] as? [String:Any],
					let namaKurir = transaksi["namakurir"] as? String,
					let descKurir = transaksi["deskripsikurir"] as? String,
					let status = transaksi["status"] as? Int,
					let alasanbatal = transaksi["alasanbatal"] as? String,
					let waktuambil = transaksi["waktuambil"] as? Double,
					let waktusampai = transaksi["waktusampai"] as? Double,
					
					
					let barang = dict["barang"] as? [String:Any],
					let postphotourl = barang["postphotourl"] as? String,
					let photourl = URL(string: postphotourl),
					
					let namaitem = barang["namabarang"] as? String,
					let jumlah = barang["jumlahbarang"] as? String,
					let deskripsi = barang["deskripsibarang"] as? String,
					
					
					
					
					
					
					let transactionid = dict["idtransaction"] as? String,
					let timestamp = dict["timestamp"] as? Double
					
				{
					
					
					
					let userProfile = UserProfile(uid: uid, email: email, phonenumber: phnumber, username: name)
					//let orgProfile = OrganisasiProfile(orgId: orgID, orgPhone: orgPhone, orgEmail: orgEmail, orgName: orgName, orgDesc: orgDesc, orgLogo: orgLogo, orgLocName: orgLocName, latitude: orgLati, longitude: orgLong, orgLink: orgLink)
					
					
					print("mamamia")
					
					
					let post = Post(id: childSnapshot.key, author: userProfile, idkomunitas: id, logokomunitas: logourl, namakomunitas: namakomunitas, phonekomunitas: phonenumber, postphotourl: photourl, namaitem: namaitem, deskripsi: deskripsi, jumlahbarang: jumlah, alamat: address, keteranganlokasi: keteranganlokasi, latitude: latitude, longitude: longitude, waktuambil: waktuambil, waktusampai: waktusampai, namakurir: namaKurir, deskripsikurir: descKurir, timestamp: timestamp, status: status, alasanbatal: alasanbatal,idtransaction: transactionid)
					
					
					
					if userProfile.uid == Auth.auth().currentUser?.uid
					{
						tempPosts.append(post)
						
					}
				}
			}
			print("berhasil ambil data post")
			
			
			DispatchQueue.main.async {
				
				self.processOngoingDonation(rawData: tempPosts, completion: { (post) in
//					self.activityList = post
					
					let changes = diff(old: self.activityList, new: post)
					//self.programList = tempKegiatan
					
					self.tableView.reload(changes: changes, section: 0, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
						self.activityList = post
					}, completion: nil)
					
				})
				
//				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
//					self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
//				}, completion: nil)
				
			}
			
		})
	}
	
	func observeOrganisasi() {
		
		//        guard let userProfile = UserService.currentUserProfile else { return }
		//        let uid = userProfile.uid
		
		let orgRef = Database.database().reference().child("users/komunitas")
		
		
		orgRef.observe(.value, with: { snapshot in
			if self.skipLoadOrganization {self.skipLoadOrganization = false; return }
			var tempOrganisasi = [OrganisasiProfile]()
			//var tempIdProfile = String
			//print("Check12")
			for child in snapshot.children {
				print(child)
				if let childSnapshot = child as? DataSnapshot,
					let dict = childSnapshot.value as? [String:Any],
					
					let locationcoor = dict["locationcoor"] as? [String:Any],
					let latitude = locationcoor["latitude"] as? Double,
					let longitude = locationcoor["longitude"] as? Double,
					let address = dict["locationname"] as? String,
					//                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitude] as NSString).doubleValue), longitude: Double(([latitude] as NSString).doubleValue)),
					let logo = dict["logo"] as? String,
					let logourl = URL(string: logo),
					
					let link = dict["link"] as? String,
					let linkwebsite = URL(string: link),
					
					let name = dict["name"] as? String,
					let phonenumber = dict["phone"] as? String,
					let deskripsi = dict["description"] as? String,
					let email = dict["email"] as? String,
					let id = dict["id"] as? String{
					print("nelis ndud ndud")
					let organisasi = OrganisasiProfile(orgId: id, orgPhone: phonenumber, orgEmail: email, orgName: name, orgDesc: deskripsi, orgLogo: logourl, orgLocName: address, latitude: latitude, longitude: longitude, orgLink: linkwebsite)
					
					
					tempOrganisasi.append(organisasi)
					print(tempOrganisasi)
					//                    if userProfile.uid == Auth.auth().currentUser?.uid
					//                    {
					//                        tempOrganisasi.append(post)
					//
					//                    }
				}else {print("Error?")}
			}
			
			DispatchQueue.main.async {
				
				print("berhasil ambil data organisasi")
//				self.organizationList = tempOrganisasi
//				//self.tableView.reloadData()
//
//				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
//					self.tableView.reloadSections(IndexSet.init(integer: 2), with: .automatic)
//				}, completion: nil)
				
				let changes = diff(old: self.organizationList, new: tempOrganisasi)
				//self.programList = tempKegiatan

				
				self.tableView.reload(changes: changes, section: 2, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
					self.organizationList = tempOrganisasi
				}, completion: nil)
				
			}
			
			
		})
		
	}
    
    func observeKegiatan() {
        
        let postsRef = Database.database().reference().child("Kegiatan/")
        
        print("mama")
        
        
        postsRef.observe(.value, with: { snapshot in
			if self.skipLoadProgramList {self.skipLoadProgramList = false; return }
            var tempKegiatan = [Kegiatan]()
            //var tempIdProfile = String
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let name = author["name"] as? String,
                    
                    let deskripsi = dict["deskripsikegiatan"] as? String,
                    let lokasi = dict["lokasikegiatan"] as? String,
                    let namakegiatan = dict["namakegiatan"] as? String,
                    let waktu = dict["waktukegiatan"] as? String,
                    let kegiatanid = dict["idkegiatan"] as? String,
                    let photourl = dict["kegiatanphotourl"] as? String,
                    let logourl = URL(string: photourl),
					let _ = dict["timestamp"] as? Double
                    
                {
                    
                    
                    print("kakakia")
                    
                    
                    let kegiatan = Kegiatan(id: kegiatanid, orgId: uid, orgName: name, programimage: logourl, programname: namakegiatan, programlocation: lokasi, programdate: waktu, programinformation: deskripsi)
                    
                    
                        tempKegiatan.append(kegiatan)
                        
                    
                    
                    
                }
                else{
                    print("ada yg salah")
                }
            }
            
			DispatchQueue.main.async {
				
				print("berhasil ambil data organisasi")
				print(tempKegiatan)
				
				let changes = diff(old: self.programList, new: tempKegiatan)
				//self.programList = tempKegiatan
				
				self.tableView.reload(changes: changes, section: 1, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
					self.programList = tempKegiatan
				}, completion: nil)

//				self.tableView.reload(changes: changes, updateData: {
//					self.programList = tempKegiatan
//				})
				
				//self.kegiatans = tempKegiatan
				//self.tableView.reloadData()
				/*
				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
					self.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
				}, completion: nil)
				*/
			}
            
        })
    }
	
}

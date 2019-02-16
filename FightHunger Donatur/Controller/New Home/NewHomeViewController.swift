//
//  NewHomeViewController.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class NewHomeViewController: UIViewController {
	
	@IBOutlet weak var donateButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var profileButtonOutlet: UIBarButtonItem!
	
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
	
	var selectedIndexPath:IndexPath?
	var toDetail:Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Set what needs to display within your view
		
		self.tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
		
		self.navigationController?.hidesBarsOnSwipe = true
		
		setupView()
		UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		UserDefaults.standard.synchronize()
		
		self.profileButtonOutlet.image = UIImage.init(named: "profilBtn")!
		self.profileButtonOutlet.title = ""
		self.profileButtonOutlet.tintColor = .black
		
		
		repeatedLoginAttempt.eventHandler = {
			if let userProfile = UserService.currentUserProfile {
				
				
				let uid = userProfile.uid
				self.observePost(id: uid)
				DispatchQueue.main.async {
					//self.tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
					// Update your data source here
					//self.tableView.reloadData()
					
//					self.profileButtonOutlet.image = UIImage.init(named: "profilBtn")!
//					self.profileButtonOutlet.title = ""
//					self.profileButtonOutlet.tintColor = .black
					
					UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
						//self.tableView.reloadData()
						self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
						
					}, completion: nil)
					
				}
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
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
		
		//observePosts()
		self.tableView.reloadData()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	
	func setupView(){
		// Register all required cell that have to display in UITableView
		tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
		tableView.register(UINib(nibName: "SectionTwoHomeCell", bundle: nil), forCellReuseIdentifier: "newActivityCellID")
		tableView.register(UINib(nibName: "SectionThreeHomeCell", bundle: nil), forCellReuseIdentifier: "partnerCellID")
		
		// Set the donate button corner radius to comply design requirement
		donateButton.layer.cornerRadius = donateButton.frame.height / 8
		donateButton.layer.masksToBounds = true
	}
	
	
	
	@IBAction func toProfile(_ sender: UIBarButtonItem) {
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
		return 44
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.white
		//headerView.isUserInteractionEnabled = true
		let label = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 44))
		label.textColor = .black
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .title3)
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
			return 160
		case 1:
			return 352
		case 2:
			return 96
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
			
			cell.contentName.text = activityList[indexPath.row].namaitem
			cell.contentStatus.text = updateDonationStatus(donationStage: activityList[indexPath.row].status)
			cell.contentExpiredDate.text = activityList[indexPath.row].deskripsi
			cell.contentActivityTime.text = timeFormat.string(from: Date(timeIntervalSince1970: activityList[indexPath.row].waktuambil))
			cell.contentImage.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: activityList[indexPath.row].postphotourl) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
			
			if activityList[indexPath.row].status == 2 || activityList[indexPath.row].status == 3 || activityList[indexPath.row].status == 4{
				
				cell.contentOrganisationName.text = activityList[indexPath.row].namakomunitas
				cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
				ImageService.getImage(withURL: activityList[indexPath.row].logokomunitas) { image, url, fromCache in
					if fromCache {
						cell.contentOrganisationIcon.image = image
					} else {
						self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
					}
				}
				
			}else {
				cell.contentOrganisationName.text = ""
				cell.contentOrganisationIcon.image = nil
			}
			
			//cell.set(post: posts[indexPath.row])
			
			return cell
		case 1:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "newActivityCellID", for: indexPath) as? SectionTwoHomeCell)!

			
			cell.contentImage.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: programList[indexPath.row].programImage) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
			
			cell.contentActivityDate.text = programList[indexPath.row].programDate
			cell.contentTitle.text = programList[indexPath.row].programName
			cell.contentDesc.text = programList[indexPath.row].programInformation
			
			cell.contentOrganisationName.text = programList[indexPath.row].orgName
			
			cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
			
			DispatchQueue.main.async {
				self.organizationList.forEach { (orgProfile) in
					if orgProfile.id == self.programList[indexPath.row].orgId {
						
						ImageService.getImage(withURL: orgProfile.logo ) { image, url, fromCache in
							if fromCache {
								cell.contentOrganisationIcon.image = image
							} else {
								self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
							}
							return
						}
					}
				}
			}
			
			
			
			
			return cell
		case 2:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "partnerCellID", for: indexPath) as? SectionThreeHomeCell)!
			
			cell.contentName.text = organizationList[indexPath.row].name
			cell.contentAddress.text = organizationList[indexPath.row].locationName
			cell.contentImage.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: organizationList[indexPath.row].logo) { image, url, fromCache in
				if fromCache {
					cell.contentImage.image = image
				} else {
					self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
				}
			}
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
	
	
	func fadeInNewImage(previousImageView: UIImageView, newImage: UIImage?) {
		let nextImage = newImage
		
		if previousImageView.image == nil{
			//previousImageView.image = UIImage.init()
			previousImageView.image = newImage
		}else{
			let tmpImageView = UIImageView(image: nextImage)
			tmpImageView.contentMode = previousImageView.contentMode
			tmpImageView.frame = previousImageView.bounds
			tmpImageView.alpha = 0.0
			previousImageView.addSubview(tmpImageView)
			
			UIView.animate(withDuration: 1, animations: {
				tmpImageView.alpha = 1.0
			}, completion: {
				finished in
				previousImageView.image = nextImage
				tmpImageView.image = nil
				tmpImageView.removeFromSuperview()
				tmpImageView.removeFromSuperview()
				
			})
		}
	}
	
	func loadImage(link:URL, object: UIImageView){
		DispatchQueue.global(qos: .userInitiated).async {
			ImageService.getImage(withURL: link) { image, url, fromCache in
				guard let imageFile = image else {return}
				DispatchQueue.main.async {
					self.fadeInNewImage(previousImageView: object, newImage: imageFile)
					
				}
				
				
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
		
		let postsRef = Database.database().reference().child("Post/")
		
		print(id)
		postsRef.observe(.value, with: { snapshot in
			
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
					self.activityList = post
				})
				
				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
					self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
				}, completion: nil)
				
			}
			
		})
	}
	
	func observeOrganisasi() {
		
		//        guard let userProfile = UserService.currentUserProfile else { return }
		//        let uid = userProfile.uid
		
		let orgRef = Database.database().reference().child("users/komunitas")
		
		
		orgRef.observe(.value, with: { snapshot in
			
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
				self.organizationList = tempOrganisasi
				//self.tableView.reloadData()
				
				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
					self.tableView.reloadSections(IndexSet.init(integer: 2), with: .automatic)
				}, completion: nil)
				
			}
			
			
		})
		
	}
    
    func observeKegiatan() {
        
        let postsRef = Database.database().reference().child("Kegiatan/")
        
        print("mama")
        
        
        postsRef.observe(.value, with: { snapshot in
            
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
                    let timestamp = dict["timestamp"] as? Double
                    
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
				self.programList = tempKegiatan
				//self.kegiatans = tempKegiatan
				self.tableView.reloadData()
				
				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
					self.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
				}, completion: nil)
				
			}
            
        })
    }
	
}

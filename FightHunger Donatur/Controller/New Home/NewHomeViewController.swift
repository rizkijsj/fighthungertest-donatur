//
//  NewHomeViewController.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase
class NewHomeViewController: UIViewController {
	
	@IBOutlet weak var donateButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
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
		UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
		setupView()
        
        print(posts)
        
	}

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
        observePosts()
        self.tableView.reloadData()
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
				organizationVC.organisasiID = organizationList[nextIndexPath.row].uid
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
		label.font = UIFont.preferredFont(forTextStyle: .title3)
		headerView.addSubview(label)
		
		//let seeMore = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
		let seeMore = UILabel(frame: CGRect(x: -16, y: 0, width: self.view.frame.width, height: 44))
		seeMore.textColor = .red
		seeMore.textAlignment = .right
		seeMore.text = "Lihat Semua"
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
		}else if indexPath.section == 1 {
			selectedIndexPath = indexPath
			print("Somewhere in Program with \(programList[indexPath.row].name)")
		}else if indexPath.section == 2 {
			selectedIndexPath = indexPath
			print("Somewhere in Organization with \(organizationList[indexPath.row].username)")
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
		return 8
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
			
			
			
			loadImage(link: activityList[indexPath.row].postphotourl, object: cell.contentImage)
			
			cell.contentName.text = activityList[indexPath.row].namaitem
			cell.contentStatus.text = updateDonationStatus(donationStage: activityList[indexPath.row].status)
			cell.contentExpiredDate.text = activityList[indexPath.row].deskripsi
			
			
			cell.contentActivityTime.text = timeFormat.string(from: Date(timeIntervalSince1970: activityList[indexPath.row].waktuambil))
			
			if activityList[indexPath.row].status != "1" {
				if let orgObject = activityList[indexPath.row].organisasi{
					
					loadImage(link: orgObject.email, object: cell.contentOrganisationIcon)
					cell.contentOrganisationName.text = orgObject.username
				}
			}else {
				cell.contentOrganisationName.text = ""
				cell.contentOrganisationIcon.image = nil
			}
			
			return cell
		case 1:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "newActivityCellID", for: indexPath) as? SectionTwoHomeCell)!
			
			loadImage(link: programList[indexPath.row].imagesLink, object: cell.contentImage)
			
			if let orgObject = connector().organizationDetail(organizationID: programList[indexPath.row].organizationID){
				loadImage(link: orgObject.email, object: cell.contentOrganisationIcon)
				cell.contentOrganisationName.text = orgObject.username
			}
			
			cell.contentActivityDate.text = programList[indexPath.row].time
			cell.contentTitle.text = programList[indexPath.row].name
			cell.contentDesc.text = programList[indexPath.row].description
			
			
			return cell
		case 2:
			let cell = (tableView.dequeueReusableCell(withIdentifier: "partnerCellID", for: indexPath) as? SectionThreeHomeCell)!
			
			loadImage(link: organizationList[indexPath.row].email, object: cell.contentImage)
			
			cell.contentName.text = organizationList[indexPath.row].username
			cell.contentAddress.text = organizationList[indexPath.row].email
			
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
	
	func fadeInNewImage(previousImageView: UIImageView, newImage: UIImage) {
		let nextImage = newImage
		
		if previousImageView.image == nil{
			previousImageView.image = UIImage.init()
			//previousImageView.image = newImage
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
	
	func loadImage(link:String, object: UIImageView){
		DispatchQueue.global(qos: .background).async {
			guard let imageFile = UIImage.init(url: URL.init(string: link)) else {return}
			
			DispatchQueue.main.async {
				self.fadeInNewImage(previousImageView: object, newImage: imageFile)
				//object.image = imageFile
			}
			
		}
	}
	func updateDonationStatus(donationStage:String) -> String{
		
		switch donationStage {
		case "1":
			return "Menunggu Claim"
		case "2":
			return "Menunggu Kurir"
		case "3":
			return "Di Jemput"
		case "4":
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

extension NewHomeViewController{
    
    func observePosts() {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        let uid = userProfile.uid
        
        let postsRef = Database.database().reference().child("Post/\(uid)")
        
        /*
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
                    let postphotourl = dict["postphotourl"] as? String,
                    let posturl = URL(string: postphotourl),
                    let address = dict["namalokasi"] as? String,
                    let keteranganlokasi = dict["keteranganlokasi"] as? String,
                    let namaitem = dict["namabarang"] as? String,
                    let jumlah = dict["jumlahbarang"] as? String,
                    let deskripsi = dict["deskripsibarang"] as? String,
                    let pickdate = dict["waktuambil"] as? String,
                    let latitude = dict["latitude"] as? String,
                    let longitude = dict["longitude"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let status = dict["status"] as? String{
                    let userProfile = UserProfile(uid: uid, email: email, phonenumber: phnumber, username: name)
                    
                    let post = Post(id: childSnapshot.key, author: userProfile, namaitem: namaitem, alamat: address, keteranganlokasi: keteranganlokasi, deskripsi: deskripsi, postphotourl: posturl, waktuambil: pickdate, jumlahbarang: jumlah, timestamp: timestamp, status: status, latitude: latitude, longitude: longitude)
                    
                    
                    if userProfile.uid == Auth.auth().currentUser?.uid
                    {
                        tempPosts.append(post)
                        
                    }
                }
            }
            self.posts = tempPosts
            self.tableView.reloadData()
            
        })
*/
    }
    
}

//
//  ShimmerHome.swift
//  FightHunger Donatur
//
//  Created by Julianti cahyadi on 22/02/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ShimmerHome: UIViewController {
	
	@IBOutlet weak var shimmerArea: UIView!
	@IBOutlet weak var shimmerImage1: UIImageView!
	@IBOutlet weak var shimmerImage2: UIImageView!
	@IBOutlet weak var profileButton: UIButton!
	
	var activityList:[Post] = []
	var organizationList:[OrganisasiProfile] = []
	var programList:[Kegiatan] = []
	
	var hasLoadedActivity = false
	var hasLoadedOrganization = false
	var hasLoadedProgram = false
	
	var attemptsToConnect = 0
	
	let repeatedLoginAttempt = RepeatingTimer(timeInterval: 0.5)
	let repeatedDataRetrival = RepeatingTimer(timeInterval: 1)
	
	let shimmerTextLabel: UILabel = {
		let label = UILabel()
		label.text = "FightHunger"
		label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
		label.textColor = UIColor(white: 1, alpha: 0.9)
		label.textAlignment = .center
		return label
	}()
	
	let textLabel: UILabel = {
		let label = UILabel()
		label.text = "FightHunger"
		label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
		label.textColor = UIColor(white: 1, alpha: 0.1)
		label.textAlignment = .center
		return label
	}()
	/*
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	*/
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ImageCache.default.cleanExpiredDiskCache()
		ImageCache.default.cleanExpiredMemoryCache()
		profileButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
		profileButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
		profileButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
		
		
		repeatedLoginAttempt.eventHandler = {
			if let userProfile = UserService.currentUserProfile {
				
				
				let uid = userProfile.uid
				self.observePost(id: uid)
				
				
				self.repeatedLoginAttempt.suspend()
			} else {
				print("Keep trying")
				
				
				if self.attemptsToConnect >= 5{
					self.hasLoadedActivity = true
				}
				
				self.attemptsToConnect += 1
			}
		}
		
		repeatedDataRetrival.eventHandler = {
			if self.hasLoadedActivity && self.hasLoadedProgram && self.hasLoadedOrganization{
				DispatchQueue.main.async {
					self.moveToNext()
				}
				
			}
		}
		
		repeatedDataRetrival.resume()
		repeatedLoginAttempt.resume()
		
		DispatchQueue.main.async {
			print("Observing Organisasi")
			self.observeOrganisasi()
			
			print("Observing Kegiatan")
			self.observeKegiatan()
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.toShimmer()
		}
		
		
	}
	
	func toShimmer(){
		DispatchQueue.main.async {
			self.setupShimmeringImage()
		}
	}
	
	func moveToNext(){
		performSegue(withIdentifier: "toHome", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let navBar = segue.destination as! UINavigationController
		let vc = navBar.topViewController as! NewHomeViewController
		
		vc.activityList = activityList
		vc.programList = programList
		vc.organizationList = organizationList
		
		vc.skipLoadActivity = true
		vc.skipLoadProgramList = true
		vc.skipLoadOrganization = true
		repeatedDataRetrival.suspend()
		repeatedLoginAttempt.suspend()
	}
	
	fileprivate func setupShimmeringImage() {
		shimmerImage1.image = UIImage.init(named: "without navbar 1")
		shimmerImage1.contentMode = .scaleToFill
		//bgImageView.clipsToBounds = true
		//bgImageView.frame = shimmerArea.frame
		
		shimmerImage2.image = UIImage.init(named: "without navbar 3")
		shimmerImage2.contentMode = .scaleToFill
		//shimmerImageView.clipsToBounds = true
		//shimmerImageView.frame = shimmerArea.frame
		
		//shimmerArea.addSubview(shimmerImageView)
		//shimmerArea.addSubview(bgImageView)
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [
			UIColor.clear.cgColor, UIColor.clear.cgColor,
			UIColor.black.cgColor, UIColor.black.cgColor,
			UIColor.clear.cgColor, UIColor.clear.cgColor
		]
		
		gradientLayer.locations = [0, 0.2, 0.4, 0.6, 0.8, 1]
		
		let angle = -60 * CGFloat.pi / 180
		let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
		gradientLayer.transform = rotationTransform
		shimmerImage2.layer.addSublayer(gradientLayer)
		gradientLayer.frame = shimmerImage2.frame
		
		shimmerImage1.layer.mask = gradientLayer
		
		gradientLayer.transform = CATransform3DConcat(gradientLayer.transform, CATransform3DMakeScale(3, 3, 0))
		
		let animation = CABasicAnimation(keyPath: "transform.translation.x")
		animation.duration = 2
		animation.repeatCount = Float.infinity
		animation.autoreverses = false
		animation.fromValue = -3.0 * shimmerImage2.frame.width
		animation.toValue = 3.0 * shimmerImage2.frame.width
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards
		gradientLayer.add(animation, forKey: "shimmerKey")
	}
	
	fileprivate func setupShimmeringText() {
		shimmerArea.backgroundColor = UIColor(white: 1, alpha: 0.1)
		
		shimmerArea.addSubview(textLabel)
		shimmerArea.addSubview(shimmerTextLabel)
		textLabel.frame = CGRect(x: 0, y: 0, width: shimmerArea.frame.width, height: shimmerArea.frame.height)
		shimmerTextLabel.frame = CGRect(x: 0, y: 0, width: shimmerArea.frame.width, height: shimmerArea.frame.height)
		
		let gradient = CAGradientLayer()
		
		gradient.frame = textLabel.bounds
		gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
		gradient.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
		let angle = -60 * CGFloat.pi / 180
		gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
		
		shimmerTextLabel.layer.mask = gradient
		
		let animation = CABasicAnimation(keyPath: "transform.translation.x")
		animation.duration = 2
		animation.repeatCount = Float.infinity
		animation.autoreverses = false
		animation.fromValue = -shimmerArea.frame.width
		animation.toValue = shimmerArea.frame.width
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards
		
		gradient.add(animation, forKey: "shimmerKey")
	}
	

}



extension ShimmerHome{
	
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
	
	
	func observePost(id: String) {
		
		let postsRef = Database.database().reference().child("UsersPost/\(id)/")
		
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
					self.hasLoadedActivity = true
				})
				
				
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
				self.hasLoadedOrganization = true
				
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
				self.programList = tempKegiatan
				self.hasLoadedProgram = true
				
			}
			
		})
	}
	
}

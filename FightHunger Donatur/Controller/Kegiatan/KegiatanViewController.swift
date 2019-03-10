//
//  KegiatanViewController.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import Kingfisher

class KegiatanViewController: UITableViewController {
	@IBOutlet weak var fotoDonasi: UIImageView!
	
	@IBOutlet weak var stasus1: UIImageView!
	@IBOutlet weak var status2: UIImageView!
	@IBOutlet weak var status3: UIImageView!
	@IBOutlet weak var status4: UIImageView!
	
	@IBOutlet weak var btnKonfirmasi: UIButton!
	@IBOutlet weak var keteranganBtnKonfirmasi: UILabel!
	
	@IBOutlet weak var namaOrganisasi: UILabel!
	@IBOutlet weak var nomorTelponOrganisasi: UILabel!
	@IBOutlet weak var btnCallOrganisasi: UIButton!
	
	@IBOutlet weak var namaKurir: UILabel!
	@IBOutlet weak var deskripsiKurir: UITextView!
	
	@IBOutlet weak var namaDonasi: UILabel!
	@IBOutlet weak var deskripsiDonasi: UITextView!
	@IBOutlet weak var jumlahDonasi: UILabel!
	@IBOutlet weak var alamatPengambilan: UILabel!
	@IBOutlet weak var waktuPengambilan: UILabel!
	
	@IBOutlet weak var btnBatal: UIButton!
	
	
	@IBOutlet weak var organizationDetail: UITableViewCell!
	
	
	@IBOutlet weak var status1Lbl: UILabel!
	@IBOutlet weak var status2Lbl: UILabel!
	@IBOutlet weak var status3Lbl: UILabel!
	@IBOutlet weak var status4Lbl: UILabel!
	
	
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
		
        
    }
	
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
    }
    
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	var passingObject:Post?
	var passingOrgObject = [OrganisasiProfile]()
	var transactionID:String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = .white
		
        keteranganBtnKonfirmasi.font = UIFont.boldSystemFont(ofSize: 14.0)
		
		status1Lbl.text = "Mencari\nKurir"
		status2Lbl.text = "Sedang\nDijemput"
		status3Lbl.text = "Sedang\nDiantar"
		status4Lbl.text = "Sampai\nOrganisasi"
		
		let toOrganisasiTap = UITapGestureRecognizer(target: self, action: #selector(openOrganisation))
		organizationDetail.gestureRecognizers = [toOrganisasiTap]
		
		/*
		let buttonSize = CGFloat(16.0)
		if #available(iOS 11.0, *){
			bacBtnOutlet.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
			bacBtnOutlet.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
		}else{
			var frame = bacBtnOutlet.frame
			frame.size.width = buttonSize
			frame.size.height = buttonSize
			bacBtnOutlet.frame = frame
		}
		*/
		
		//let tap = UITapGestureRecognizer.init(target: self, action: #selector(openOrganisation))
		
		//organizationDetail.gestureRecognizers = [tap]
		
		//        statusDonasi()
		reloadObject()
		
		if let _ = passingObject {
			print("Here")
			guard let postID = transactionID, let userProfile = UserService.currentUserProfile else { return }
			print("Now Dis")
			let uid = userProfile.uid
			observePost(userID: uid, transID: postID)
            observeDeadPost(transID: postID)
		}
		
		//updateDonationDetails()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toOrganization" {
			let organizationVC = segue.destination as! Organisasi
			guard let postData = passingObject else {return}
			
			passingOrgObject.forEach { (orgProf) in
				if orgProf.id == postData.idkomunitas{
					organizationVC.organisasiObject = orgProf
					return
				}
			}
			
		}
	}
	
	
	
	@IBAction func konfirmasiAct(_ sender: Any) {
		konfirmasiPickup { (result) in
			if result{
				print("sukses di konfirmasi")
				self.reloadObject()
			}else{
				print("gagal di konfirmasi")
			}
		}
	}
	
	@IBAction func confirmCancel(_ segue: UIStoryboardSegue){
		
        let vc = segue.source as! PembatalanController
        print("\n\n\n\n")
        print(vc.reasonCancelling)
        print("\n\n\n\n")
        batalkanDonasi(reason: vc.reasonCancelling)
        
      
//        createAlert()
		
	}
	
	
	
	
	
	@objc  func openOrganisation() {
		if let postData = passingObject {
			if postData.status > 1 && postData.status < 6{
				performSegue(withIdentifier: "toOrganization", sender: self)
			}
		}
	}
	
	func reloadObject(){
		if let _ = passingObject, passingOrgObject.count > 0 {
			updateDonationDetails()
		}else{
			dismiss(animated: true, completion: nil)
			self.navigationController?.popViewController(animated: true)
		}
		
		
	}
	
	@IBAction func clickBtnBatalkan(_ sender: UIButton) {
		//batalkanDonasi()
		/*
		cancelPickup { (result) in
			if result{
				print("sukses di Batalkan")
				self.reloadObject()
			}else{
				print("gagal di Batalkan")
			}
		}
		*/
        
			createAlert()
		
	}
	
	
	
    
    func createAlert()
    {
        let alert = UIAlertController(title: "Konfirmasi batalkan", message: "Apakah anda yakin untuk membatalkan donasi anda?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertAction.Style.default, handler: { (action) in

			self.performSegue(withIdentifier: "toPopUp", sender: self)
			
			
			//batalkanDonasi()

        }))
        
        alert.addAction(UIAlertAction(title: "Tidak", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
	
	@IBAction func callButton(_ sender: Any) {
		guard let orgObject = passingObject else {return}
		
		        let urlPhone: NSURL = URL(string: "tel://\(orgObject.phonekomunitas)")! as NSURL
		UIApplication.shared.open(urlPhone as URL, options: [:], completionHandler: nil)
		
	}
	
	func updateDonationDetails(){
		
		if let statusObject = passingObject{
			print("lala")
			print(statusObject.status)
			transactionID = statusObject.id
			
			fotoDonasi.kf.indicatorType = .activity
			fotoDonasi.kf.setImage(
				with: statusObject.postphotourl,
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
			
			
			
			
			namaOrganisasi.text = statusObject.namakomunitas
			nomorTelponOrganisasi.text = statusObject.phonekomunitas
			alamatPengambilan.text = statusObject.alamat
			
			
			
			namaKurir.text = statusObject.namakurir
			deskripsiKurir.text = statusObject.deskripsikurir
			
			namaDonasi.text = statusObject.namaitem
			print(statusObject.namaitem)
			
			let descriptions = statusObject.deskripsi.split(separator: "|")
			
			deskripsiDonasi.text = "\(descriptions[0]) | \(descriptions[1].dropLast())\(descriptions[2])"
			jumlahDonasi.text = statusObject.jumlahbarang
			
			let dateFormat = DateFormatter()
			let timeFormat = DateFormatter()
			dateFormat.locale = Locale.init(identifier: "Id")
			timeFormat.locale = Locale.init(identifier: "Id")
			dateFormat.dateFormat = "MMMM dd yyyy"
			timeFormat.dateFormat = "HH:mm"
			
			
			if statusObject.status != 5{
			waktuPengambilan.text = "\(dateFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil))), \(timeFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil)))"
			}else {
				waktuPengambilan.text = "\(dateFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil))), \(timeFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil))) - \(timeFormat.string(from: Date(timeIntervalSince1970: statusObject.waktusampai)))"
			}
			
			
			statusInteractionUpdate(Status: statusObject.status)
			updateDonationStatus(donationStage: statusObject.status)
		}else{
			print("Failed to load details")
		}
	}
	
	func statusInteractionUpdate(Status:Int){
		btnBatal.isEnabled = false
		btnCallOrganisasi.isEnabled = false
		btnKonfirmasi.isEnabled = false
		btnBatal.setImage(UIImage.init(named: "Tombol abu"), for: .disabled)
		if Status == 1 {
			btnBatal.isEnabled = true
			print("Menunggu konfirmasi")
		}else if Status == 2{
			btnBatal.isEnabled = true
			btnCallOrganisasi.isEnabled = true
			print("organisasi mencari Kurir")
		}else if Status == 3{
			btnKonfirmasi.isEnabled = true
			btnCallOrganisasi.isEnabled = true
			if btnKonfirmasi.isTouchInside {
				//                push notif ke organisasi
			}
			print("sedang di jemput")
		}else if Status == 4{
			btnCallOrganisasi.isEnabled = true
			print("sedang di antar")
		}else{
			print("hmmmm")
			btnKonfirmasi.isEnabled = false
			btnCallOrganisasi.isEnabled = false
			btnBatal.isEnabled = false
		}
	}
	
	func batalkanDonasi(reason:String){
		//        push donasi
		guard let _ = Auth.auth().currentUser?.uid else { return }
		
		guard let idtransaksi = passingObject?.idtransaksi else{return}
		guard let postData = passingObject else {return}
		
		connector().donationCancel(transactionID: idtransaksi, Reason: reason, data: postData) { (successCancel) in
			if successCancel{
				self.navigationController?.popViewController(animated: true)
			}else {
				print("Gagal Membatalkan")
			}
		}
	}
	@IBAction func backBtn(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func konfirmasiPickup(completion: @escaping (Bool) -> Void){
		guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let kegiatanObject = passingObject else {return}
		guard let idtransaksi = passingObject?.idtransaksi else {return}
		
		//        guard let alasanBatal = alasanBatalTextField.text else{return}
		let databaseRef = Database.database().reference().child("PublicPost/\(idtransaksi)/transaksi")
        let userRef = Database.database().reference().child("UsersPost/\(uid)/\(idtransaksi)/transaksi")
		
		let userObject = ["status": 4] as [String:Any]
		
		databaseRef.updateChildValues(userObject) { error, ref in
			if error == nil{
				print("sukses")
                
                userRef.updateChildValues(userObject, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("sukses")
                        connector().retrieveUserToken(id: kegiatanObject.idkomunitas, completion: { (token, result) in
                            if result{
                                print("masuk send notif")
                                let sender = PushNotificationSender()
                                sender.sendPushNotification(to: token, title: "Donasi diambil kurir", body: "Barang donasi sudah diambil oleh kurir")
                                completion(true)
                            }else{
                                completion(false)
                            }
                        })
                    }else{
                        completion(false)
                    }
                })
			}else{
				completion(false)
			}
		}
		
		
		/// Attempted To update transaction's status, but replace all inside,please check Andre
		/*
		let userStatus = ["transaksi":["status": 4]] as [String:[String:Any]]
		
		
		databaseRef.updateChildValues(userStatus) { error, ref in
			if error == nil{
				print("sukses")
				
				userRef.updateChildValues(userStatus, withCompletionBlock: { (error, ref) in
					if error == nil {
						print("sukses")
					}else{
						completion(false)
					}
				})
			}else{
				completion(false)
			}
		}
*/
	}
	
	func callOrganisasi(){
		if btnCallOrganisasi.isTouchInside {
			nomorTelponOrganisasi.resignFirstResponder()
			
			if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
				UIApplication.shared.open(phoneURL as URL)
			}
		}
	}
	
	func updateDonationStatus(donationStage:Int){
		
		stasus1.image = UIImage.init(named: "pin1b")
		status2.image = UIImage.init(named: "pin2b")
		status3.image = UIImage.init(named: "pin3b")
		status4.image = UIImage.init(named: "pin4b")
		
		if donationStage == 0 {
			print("Di Batalkan donatur")
			namaOrganisasi.text = ""
			nomorTelponOrganisasi.text = ""
        	keteranganBtnKonfirmasi.text = "Donasi telah dibatalkan"
			namaKurir.text = ""
			deskripsiKurir.text = ""
		}else if donationStage == 1 {
			print("Menunggu untuk di claim")
			btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
			keteranganBtnKonfirmasi.text = "Menunggu untuk di klaim organisasi"
			namaOrganisasi.text = "Belum Ada"
			nomorTelponOrganisasi.text = "Belum Ada"
			namaKurir.text = "Belum Ada"
			deskripsiKurir.text = "Belum Ada"
			
		}else if donationStage == 2 {
			print("Menunggu Data Kurir")
			stasus1.image = UIImage.init(named: "pin1a")
			btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
			btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
			organizationDetail.accessoryType = .disclosureIndicator
            keteranganBtnKonfirmasi.text = "Menunggu data Kurir"
//            namaOrganisasi.text = "\(organizationDetail.name)"
//            nomorTelponOrganisasi.text = "Belom Ada"
			namaKurir.text = "Belum Ada"
			deskripsiKurir.text = "Belum Ada"
		}else if donationStage == 3 {
			print("Mengirim Kurir")
			stasus1.image = UIImage.init(named: "pin1a")
			status2.image = UIImage.init(named: "pin2a")
			btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
			btnKonfirmasi.setImage(UIImage(named: "konfirmasi aktif"), for: .normal)
            keteranganBtnKonfirmasi.text = "Organisasi mengirim kurir ke lokasi pengambilan"
		} else if donationStage == 4 {
			print("Sedang diantar")
			stasus1.image = UIImage.init(named: "pin1a")
			status2.image = UIImage.init(named: "pin2a")
			status3.image = UIImage.init(named: "pin3a")
			btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
            keteranganBtnKonfirmasi.text = "Kurir sedang mengantar donasi ke organisasi"
		} else if donationStage == 5 {
			print("Sudah sampai organisasi")
			stasus1.image = UIImage.init(named: "pin1a")
			status2.image = UIImage.init(named: "pin2a")
			status3.image = UIImage.init(named: "pin3a")
			status4.image = UIImage.init(named: "pin4a")
            keteranganBtnKonfirmasi.text = "Donasi sudah sampai di organisasi"
			
		}else if donationStage == 6 {
			print("Di Batalkan Organisasi")
			namaOrganisasi.text = ""
			nomorTelponOrganisasi.text = ""
			keteranganBtnKonfirmasi.text = "Organisasi membatalkan donasi"
			namaKurir.text = ""
			deskripsiKurir.text = ""
		}
		
	}
	
}

extension KegiatanViewController{
	
	
	
	func observePost(userID: String, transID:String) {
		
		let postsRef = Database.database().reference().child("UsersPost/\(userID)/")
		
		print(userID)
		print(transID)
		postsRef.observe(.value, with: { snapshot in
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
					
					
					if post.idtransaksi == transID{
						print("Ketemu untuk Active")
						self.passingObject = post
						DispatchQueue.main.async {
							
							UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
								
								
								self.reloadObject()
								
								
								
							}, completion: nil)
							
						}
						
					} else {
						print("Gagal mencari di sini, Maka mari cari di Dead yang ini")
						
					}
				
				}else {
					print("Error?.... Post Ga ketemu")
					
				}
			}
			
			
			
			
			
		})
	}
    
    func observeDeadPost(transID:String) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        let uid = userProfile.uid
        let postsRef = Database.database().reference().child("Riwayat/User/\(uid)")
        
        postsRef.observe(.value, with: { snapshot in
            
            //var tempPost:Post?
            //var tempIdProfile = String
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let email = author["email"] as? String,
                    let name = author["username"] as? String,
                    let phnumber = author["phonenumber"] as? String,
                    
                    //                    let organisasi = dict["komunitas"] as? [String:Any],
                    //                    let orgID = organisasi["id"] as? String,
                    //                    let orgName = organisasi["name"] as? String,
                    //                    let orgDesc = organisasi["description"] as? String,
                    //                    let orgLink = organisasi["link"] as? String,
                    //                    let orgLogo = organisasi["logo"] as? String,
                    //                    let orgEmail = organisasi["email"] as? String,
                    //                    let orgPhone = organisasi["phone"] as? String,
                    //                    let orgLocName = organisasi["locationname"] as? String,
                    //                    let orgLocCoor = organisasi["locationcoor"] as? [String:Any],
                    //                    let orgLati = orgLocCoor["latitude"] as? String,
                    //                    let orgLong = orgLocCoor["longitude"] as? String,
                    
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
					
                    
                    print("kukikakuke")
                    
                    let post = Post(id: childSnapshot.key, author: userProfile, idkomunitas: id, logokomunitas: logourl, namakomunitas: namakomunitas, phonekomunitas: phonenumber, postphotourl: photourl, namaitem: namaitem, deskripsi: deskripsi, jumlahbarang: jumlah, alamat: address, keteranganlokasi: keteranganlokasi, latitude: latitude, longitude: longitude, waktuambil: waktuambil, waktusampai: waktusampai, namakurir: namaKurir, deskripsikurir: descKurir, timestamp: timestamp, status: status, alasanbatal: alasanbatal,idtransaction: transactionid)
                    
					
					print("\n\n\n\n")
					print(post.idtransaksi == transID)
					print(post.idtransaksi)
					print(transID)
                    if post.idtransaksi == transID{
                        //tempPost = post
						DispatchQueue.main.async {
							print("Ketemu untuk passive")
							self.passingObject = post
							self.transactionID = post.idtransaksi

							UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
								self.reloadObject()
							}, completion: nil)
							
						}
                    }
                    
				} else {print("Something is up Here") }
            }
			
            
        })
    }
    
}


//
//  RiwayatViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase
import DeepDiff

class RiwayatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var dataPost = [Post]()
	var selectedIndex = IndexPath()
	var passingOrgObject = [OrganisasiProfile]()
	
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.view.layoutIfNeeded()
                //print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.view.layoutIfNeeded()
                //print("Unhide")
            }, completion: nil)
        }
    }
    /*
    let fotoDonasi: [UIImage] = [UIImage(named: "foto")!, UIImage(named: "foto")!]
    let namaDonasi = ["Stroberi","Siomay"]
    let keteranganDonasi = ["Stoberi masih segar","Siomay baru dimasak tadi pagi dan tidak habis, terlalu banyak"]
    let fotoOrganisasi : [UIImage] = [UIImage(named: "foi")!, UIImage(named: "foi")!]
    let namaOrganisasi = ["Foodbank of Indonesia", "The Hunger Bank"]
    let keteranganWkt = ["23 Jan,08:24","24 Mei,18:34"]
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataPost.count
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 160
	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as! SectionOneHomeCell
		
		cell.contentStatus.isHidden = true
		
		cell.contentImage.kf.indicatorType = .activity
		cell.contentImage.kf.setImage(
			with: dataPost[indexPath.row].postphotourl,
			placeholder: UIImage.init(color: .white),
			options: [
				.transition(.fade(1))
			])
		{
			result in
			switch result {
			case .success(let value):
				print("Task done for: \(value.source.url?.absoluteString ?? "")")
			case .failure(let error):
				print("Job failed: \(error.localizedDescription)")
			}
		}
		
		/*
		ImageService.getImage(withURL: dataPost[indexPath.row].postphotourl) { image, url, fromCache  in
			cell.contentImage.image = UIImage.init(color: .lightGray)
			if fromCache {
				cell.contentImage.image = image
			}else {
            	self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
			}
        }
		*/
        
        //cell.fotoDonasi.image = dataPost[indexPath.row].
        cell.contentName.text = dataPost[indexPath.row].namaitem
		cell.contentExpiredDate.text = dataPost[indexPath.row].deskripsi
		
		cell.contentOrganisationName.text = ""
		//cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
		if dataPost[indexPath.row].status == 5{
			/*
			cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: dataPost[indexPath.row].logokomunitas) { image, url, fromCache in
				cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
				if fromCache {
					cell.contentOrganisationIcon.image = image
				}else {
					self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
				}
			}
			*/
			
			cell.contentOrganisationIcon.kf.indicatorType = .activity
			cell.contentOrganisationIcon.kf.setImage(
				with: dataPost[indexPath.row].logokomunitas,
				placeholder: UIImage.init(color: .white),
				options: [
					.transition(.fade(1))
				])
			{
				result in
				switch result {
				case .success(let value):
					print("Task done for: \(value.source.url?.absoluteString ?? "")")
				case .failure(let error):
					print("Job failed: \(error.localizedDescription)")
				}
			}

			//cell.fotoOrgn.image = fotoOrganisasi[indexPath.row]
			let descriptions = dataPost[indexPath.row].deskripsi.split(separator: "|")
			
			cell.contentExpiredDate.text = "\(descriptions[2].dropFirst(1))"
			cell.contentOrganisationName.text = dataPost[indexPath.row].namakomunitas
		}else {
			cell.contentOrganisationName.text = ""
		}
		let dateFormat = DateFormatter()
		dateFormat.locale = Locale.init(identifier: "Id")
		dateFormat.dateFormat = "MMMM dd yyyy, HH:mm"
		
		cell.contentStatus.text = updateDonationStatus(donationStage: dataPost[indexPath.row].status)
		cell.contentActivityTime.text = ""
		if dataPost[indexPath.row].status == 5 {
			cell.contentExpiredDate.text = "Sampai pada tanggal dan waktu:\n\(dateFormat.string(from: Date(timeIntervalSince1970: dataPost[indexPath.row].waktusampai)))"
		}else {
			cell.contentExpiredDate.text = "Donasi di batalkan"
		}
        return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedIndex = indexPath
		performSegue(withIdentifier: "toPastActivity", sender: self)
	}
	
    
    //Function DELETE
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == UITableViewCell.EditingStyle.delete
//        {
//            dataPost.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toPastActivity"{
			let vc = segue.destination as! KegiatanViewController
			vc.passingObject = dataPost[selectedIndex.row]
			vc.transactionID = dataPost[selectedIndex.row].idtransaksi
			vc.passingOrgObject = passingOrgObject
		}
	}
    

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
		self.dataPost.reverse()
		
        tableView.delegate = self
        tableView.dataSource = self
        observePost()
		
		if passingOrgObject.count < 1{
			observeOrganisasi()
		}
      
    }
    
    func accessibility()
    {
        backButton.isAccessibilityElement = true
        
        backButton.accessibilityTraits = UIAccessibilityTraits.button
        backButton.accessibilityLabel = "Back"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
	
	func updateDonationStatus(donationStage:Int) -> String{
		
		switch donationStage {
		case 0:
			return "Dibatalkan"
		case 5:
			return "Telah sampai"
		case 6:
			return "Dibatalkan"
		default:
			return ""
		}
		
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
				self.passingOrgObject = tempOrganisasi
				//self.tableView.reloadData()
				
			}
			
			
		})
		
	}

    func observePost() {
        
        guard let userProfile = UserService.currentUserProfile else { return }

        let uid = userProfile.uid
        let postsRef = Database.database().reference().child("Riwayat/User/\(uid)")
        
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
                    print(namaitem)
                    
                    let post = Post(id: childSnapshot.key, author: userProfile, idkomunitas: id, logokomunitas: logourl, namakomunitas: namakomunitas, phonekomunitas: phonenumber, postphotourl: photourl, namaitem: namaitem, deskripsi: deskripsi, jumlahbarang: jumlah, alamat: address, keteranganlokasi: keteranganlokasi, latitude: latitude, longitude: longitude, waktuambil: waktuambil, waktusampai: waktusampai, namakurir: namaKurir, deskripsikurir: descKurir, timestamp: timestamp, status: status, alasanbatal: alasanbatal,idtransaction: transactionid)
                    
                    
                    
                    
                        tempPosts.append(post)
                        
                    
                }
            }
            print("berhasil ambil data post")
            
            
            DispatchQueue.main.async {
				
				let changes = diff(old: self.dataPost, new: tempPosts)
				//self.programList = tempKegiatan
				
				self.tableView.reload(changes: changes, section: 0, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
					self.dataPost = tempPosts
				}, completion: nil)
                //self.dataPost = tempPosts
				//self.dataPost.reverse()
                //self.tableView.reloadData()
			
            }
            
        })
    }
    

	
	
}

//
//  RiwayatViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class RiwayatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var dataPost = [Post]()
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    let fotoDonasi: [UIImage] = [UIImage(named: "foto")!, UIImage(named: "foto")!]
    let namaDonasi = ["Stroberi","Siomay"]
    let keteranganDonasi = ["Stoberi masih segar","Siomay baru dimasak tadi pagi dan tidak habis, terlalu banyak"]
    let fotoOrganisasi : [UIImage] = [UIImage(named: "foi")!, UIImage(named: "foi")!]
    let namaOrganisasi = ["Foodbank of Indonesia", "The Hunger Bank"]
    let keteranganWkt = ["23 Jan,08:24","24 Mei,18:34"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataPost.count
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 160
	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as! SectionOneHomeCell
		
		cell.contentStatus.isHidden = true
		cell.contentImage.image = UIImage.init(color: .lightGray)
		
		ImageService.getImage(withURL: dataPost[indexPath.row].postphotourl) { image, url, fromCache  in
			if fromCache {
				cell.contentImage.image = image
			}else {
            	self.fadeInNewImage(previousImageView: cell.contentImage, newImage: image)
			}
        }
        
        //cell.fotoDonasi.image = dataPost[indexPath.row].
        cell.contentName.text = dataPost[indexPath.row].namaitem
		cell.contentExpiredDate.text = dataPost[indexPath.row].deskripsi
		
		cell.contentOrganisationName.text = ""
		if dataPost[indexPath.row].status == 5 || dataPost[indexPath.row].status == 6 {
			cell.contentOrganisationIcon.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: dataPost[indexPath.row].logokomunitas) { image, url, fromCache in
				
				if fromCache {
					cell.contentOrganisationIcon.image = image
				}else {
					self.fadeInNewImage(previousImageView: cell.contentOrganisationIcon, newImage: image)
				}
			}

			//cell.fotoOrgn.image = fotoOrganisasi[indexPath.row]
			
			cell.contentOrganisationName.text = dataPost[indexPath.row].namakomunitas
		}else {
			cell.contentOrganisationName.text = ""
		}
		let dateFormat = DateFormatter()
		dateFormat.locale = Locale.init(identifier: "Id")
		dateFormat.dateFormat = "MMMM dd yyyy, HH:mm"
		
		if dataPost[indexPath.row].status == 5 {
        cell.contentActivityTime.text = dateFormat.string(from: Date(timeIntervalSince1970: dataPost[indexPath.row].waktuambil))
		} else {
			cell.contentActivityTime.text = "Dibatalkan"
		}
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
		self.dataPost.reverse()
		
        tableView.delegate = self
        tableView.dataSource = self
        observePost()
      
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
   

    func observePost() {
        
        guard let userProfile = UserService.currentUserProfile else { return }

        let uid = userProfile.uid
        let postsRef = Database.database().reference().child("DeadPost/\(uid)")
        
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
                
                self.dataPost = tempPosts
				self.dataPost.reverse()
                //self.tableView.reloadData()
                
                UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                }, completion: nil)
                
            }
            
        })
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
}

//
//  KegiatanTerbaruController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class KegiatanTerbaruController: UITableViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var isiKegiatan: UILabel!
    @IBOutlet weak var titleKegiatan: UILabel!
    @IBOutlet weak var imgOrganisasi: UIImageView!
	@IBOutlet weak var imageProgram: UIImageView!
	@IBOutlet weak var namaLokasiProgram: UILabel!
	@IBOutlet weak var waktuProgram: UILabel!
	
    @IBOutlet weak var btnDonasi: UIButton!
	
	var passingObject: Kegiatan?
	var organisationObject: OrganisasiProfile?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
      
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        btnDonasi.layer.cornerRadius = btnDonasi.frame.height / 8
		
		reloadObject()
		observeOrganisasi()
		
		let tapBtnDonate = UITapGestureRecognizer(target: self, action: #selector(toDonationPage))
		btnDonasi.addGestureRecognizer(tapBtnDonate)
    }
	
	@objc func toDonationPage(){
		performSegue(withIdentifier: "toDonate", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		//print("\n\n\n\nPreparing\n\n\n")
		if segue.identifier == "toDonate" {
			//print("I ma go here")
			let navbar = segue.destination as! UINavigationController
			let vc = navbar.topViewController as! DonatingController
            sendOrgDataToDonate()
			//guard let orgObj = organisationObject else {return}
			//print("there")
			//vc.selectedOrganization = orgObj
			//print("Done")
		}
	}
	
	func reloadObject(){
		if let _ = passingObject {
			loadProgramDetails()
		}else {
			self.navigationController?.popViewController(animated: true)
		}
	}
    
    
	
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func loadProgramDetails(){
		guard let progObject = passingObject else {return}
		
		imageProgram.image = UIImage.init(color: .lightGray)
		ImageService.getImage(withURL: progObject.programImage) { (image, url, fromCache) in
			if fromCache {
				self.imageProgram.image = image
			}else {
				self.fadeInNewImage(previousImageView: self.imageProgram, newImage: image)
			}
		}
		
			titleKegiatan.text = progObject.programName
			isiKegiatan.text = progObject.programInformation
			namaLokasiProgram.text = progObject.programLocation
			waktuProgram.text = progObject.programDate
		
		if let orgObject = organisationObject {
		
			imgOrganisasi.image = UIImage.init(color: .lightGray)
			ImageService.getImage(withURL: orgObject.logo ) { image, url, fromCache in
				if fromCache {
					self.imgOrganisasi.image = image
				} else {
					self.fadeInNewImage(previousImageView: self.imgOrganisasi, newImage: image)
				}
			}
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
    
    func sendOrgDataToDonate(){
        guard let orgObject = organisationObject else {return}
        let orgDataKegiatan = orgObject.id
        defaults.set(orgDataKegiatan, forKey: "idOrgKegiatan")
    }
    
    

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
	}
	
	
	func observeOrganisasi() {
		
		//        guard let userProfile = UserService.currentUserProfile else { return }
		//        let uid = userProfile.uid
		guard let progObject = passingObject else {return}
		
		let orgRef = Database.database().reference().child("users/komunitas")
		var tempOrganisasi:OrganisasiProfile?
		
		orgRef.observe(.value, with: { snapshot in
			
			
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
					
					
					
					if organisasi.id == progObject.orgId {
						tempOrganisasi = organisasi
					}
					//                    if userProfile.uid == Auth.auth().currentUser?.uid
					//                    {
					//                        tempOrganisasi.append(post)
					//
					//                    }
				}else {print("Error?")}
			}
			
			DispatchQueue.main.async {
				guard let tempOrg = tempOrganisasi else {return}
				print("berhasil ambil data organisasi")
				self.organisationObject = tempOrg
				//self.tableView.reloadData()
				
				UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
					self.reloadObject()
				}, completion: nil)
				
			}
			
			
		})
		
	}
	

}

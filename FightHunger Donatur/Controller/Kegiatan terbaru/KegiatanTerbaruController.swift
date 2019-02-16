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
 

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.btnDonasi.layer.cornerRadius = 8.0
        self.imgOrganisasi.layer.cornerRadius = 8.0
        self.imgOrganisasi.layer.shadowColor = UIColor.gray.cgColor
        self.imgOrganisasi.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.imgOrganisasi.layer.shadowRadius = 2.0
        self.imgOrganisasi.layer.shadowOpacity = 0.4
        self.imgOrganisasi.layer.masksToBounds = false
        imgOrganisasi.layer.shadowPath = UIBezierPath(rect: imgOrganisasi.bounds).cgPath
       
		reloadObject()
		observeOrganisasi()
        //Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        imgOrganisasi.isUserInteractionEnabled = true
        imgOrganisasi.addGestureRecognizer(tapGesture)
        
        //Tap Gesture Program
        let tapProgram = UITapGestureRecognizer(target: self, action: #selector(self.onTapProgram))
        imageProgram.isUserInteractionEnabled = true
        imageProgram.addGestureRecognizer(tapProgram)
    }
	
	func reloadObject(){
		if let _ = passingObject {
			loadProgramDetails()
		}else {
			self.navigationController?.popViewController(animated: true)
		}
        
       
	}
    
    @objc func onTapProgram()
    {
       guard let progObject = passingObject else {return}
        ImageService.getImage(withURL: progObject.programImage) { (image, url, fromCache) in
            if fromCache {
                self.imageProgram.image = image
            }else {
                self.fadeInNewImage(previousImageView: self.imageProgram, newImage: image)
            }
        }
        
        let passingimg = imageProgram.image
        
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "Next") as! PopUpVC
        nextVC.imageimg = passingimg!
      
        self.present(nextVC, animated: true, completion: nil)
        print("testk")
    }
    
    @objc func onTap()
    {
       
        func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
                let organizationVC = segue.destination as! Organisasi
                organizationVC.organisasiObject = organisationObject
                self.performSegue(withIdentifier: "ToOrganization", sender: self)
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

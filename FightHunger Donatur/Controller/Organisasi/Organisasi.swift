//
//  Organisasi.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class Organisasi: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	
	 let defaults = UserDefaults.standard
	@IBOutlet weak var donateButton: UIButton!
	
    //Initial organisasi object
    //let orgObject = OrganisasiProfile.init(orgId: "FOI", orgPhone: "+6287776007230", orgEmail: "atn010g@gmail.com", orgName: "Antonius", orgDesc: "Dalam kesempatan yang baik ini kami akan melakukan presentasi tugas akhir atau skripsi kami yang berjudul Diskusia : Aplikasi diskusi kolaboratif menggunakan papan tulis virtual berbasis web. ", orgLogo: URL.init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Tunnel_of_ducks.jpg/440px-Tunnel_of_ducks.jpg")!, orgLocName: "Jalan SingPasa", latitude: 106, longitude: -5, orgLink: URL.init(string: "www.google.com")!)
    
    @IBAction func clickWeb(_ sender: Any) {
		guard let orgObject = organisasiObject else {return}
        let url = orgObject.link
		UIApplication.shared.open(url, options: [:])
    }
    
    @IBAction func chatButton(_ sender: Any) {
		
		guard let orgObject = organisasiObject else {return}
        //let phoneNumber =  "6281808082838"
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(orgObject.phone.dropFirst())")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
          print("lala")
        }
    }
    
   
    
    @IBAction func callButton(_ sender: Any) {
		guard let orgObject = organisasiObject else {return}
        let urlPhone: NSURL = URL(string: "tel://\(orgObject.phone)")! as NSURL
        UIApplication.shared.open(urlPhone as URL, options: [:], completionHandler: nil)
        
    }

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var logoOrganisasi: UIImageView!
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var alamatOrganisasi: UILabel!
    @IBOutlet weak var callOrganisasi: UIButton!
    @IBOutlet weak var chatOrganisasi: UIButton!
    @IBOutlet weak var lokasiOrganisasi: UIButton!
    @IBOutlet weak var linkOrganisasi: UIButton!
    @IBOutlet weak var keteranganOrganisasi: UILabel!
    
    var organisasiObject : OrganisasiProfile?
  //  var organisasiProgramObject: [programObject] = []
    //var organisasiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = .white
		
		donateButton.layer.cornerRadius = donateButton.frame.height / 6
		donateButton.layer.masksToBounds = true
		
        //make image organization rounded
        self.logoOrganisasi.layer.cornerRadius = 10.0
        self.logoOrganisasi.layer.shadowColor = UIColor.gray.cgColor
        self.logoOrganisasi.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.logoOrganisasi.layer.shadowRadius = 2.0
        self.logoOrganisasi.layer.shadowOpacity = 0.4
        self.logoOrganisasi.layer.masksToBounds = false
        logoOrganisasi.layer.shadowPath = UIBezierPath(rect: logoOrganisasi.bounds).cgPath
        
        if let organisasi = organisasiObject{
                namaOrganisasi.text = organisasi.name
                alamatOrganisasi.text = organisasi.locationName
                btnAction()
                keteranganOrganisasi.text = organisasi.description
               
                //organisasiProgramObject = connector().getOrganizationProgramList(organizationID: organisasi.id, limit: 3)
			
			logoOrganisasi.kf.indicatorType = .activity
			logoOrganisasi.kf.setImage(
				with: organisasi.logo,
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
			
            
                self.tableView.reloadData()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		//print("\n\n\n\nPreparing\n\n\n")
		if segue.identifier == "toDonate" {
			//print("I ma go here")
			let navbar = segue.destination as! UINavigationController
			let vc = navbar.topViewController as! DonatingController
			sendOrgDataToDonate()
			guard let orgObj = organisasiObject else {return}
			//print("there")
			vc.selectedOrganization = orgObj
			//print("Done")
		}
		
		
	}
	
	func sendOrgDataToDonate(){
		guard let orgObject = organisasiObject else {return}
		let orgDataKegiatan = orgObject.id
		defaults.set(orgDataKegiatan, forKey: "idOrgKegiatan")
	}
	
	@IBAction func clickOnDonate(_ sender: UIButton) {
		performSegue(withIdentifier: "toDonate", sender: self)
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
    
    func loadImage(link:URL){
        DispatchQueue.global(qos: .userInitiated).async {
            let image = UIImage.init(url: link)
			
			guard let imageFile = image else {return}
            DispatchQueue.main.async {
                self.logoOrganisasi.image = imageFile
            }
        }
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
    
   
    
    @IBAction func clickedOnLocation(_ sender: UIButton) {
         print("Open Map")
		guard let orgObject = organisasiObject else {return}
        
            let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2D.init(latitude: orgObject.latitude, longitude: orgObject.longitude)

            //organisasiObject?.email
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = organisasiObject?.name
            mapItem.openInMaps(launchOptions: options)
        
    }
	@IBAction func clickedReturn(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
    func btnAction(){
        //let orgObject = OrganisasiProfile.init(orgId: "FOI", orgPhone: "+62808082838", orgEmail: "atn010g@gmail.com", orgName: "Antonius", orgDesc: "Dalam kesempatan yang baik ini kami akan melakukan presentasi tugas akhir atau skripsi kami yang berjudul Diskusia : Aplikasi diskusi kolaboratif menggunakan papan tulis virtual berbasis web. ", orgLogo: URL.init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Tunnel_of_ducks.jpg/440px-Tunnel_of_ducks.jpg")!, orgLocName: "Jalan SingPasa", latitude: 106, longitude: -5, orgLink: URL.init(string: "www.google.com")!)
        
        if callOrganisasi.isTouchInside{
            
            if let phoneURL = NSURL(string: "tel//:\(String(describing: organisasiObject?.phone))"){
                    UIApplication.shared.open(phoneURL as URL)
                        }
      
                    }
        
        if chatOrganisasi.isTouchInside{
            guard let tempPhonenumber = organisasiObject?.phone else {return}
            let whatsapp = "whatsapp://send?phone=\(tempPhonenumber)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(whatsapp ?? "")
            if let whatsappURL = whatsapp, let url = URL(string: whatsappURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            print("chat WA")
        }
        
        if linkOrganisasi.isTouchInside{
            if let url = URL(string: "\(String(describing: organisasiObject?.link))") {
                    UIApplication.shared.open(url, options: [:])
                        }
            }
        
        if lokasiOrganisasi.isTouchInside{
			
			guard let orgObject = organisasiObject else {return}
		
			let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2D.init(latitude: orgObject.latitude, longitude: orgObject.longitude)
			
			//organisasiObject?.email
			let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
			let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = organisasiObject?.name
            mapItem.openInMaps(launchOptions: options)
            
        }
        
    }
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
	
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
            
        
        return 0
    }
	
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    */
}

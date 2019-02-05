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

class Organisasi: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var logoOrganisasi: UIImageView!
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var alamatOrganisasi: UILabel!
    @IBOutlet weak var callOrganisasi: UIButton!
    @IBOutlet weak var chatOrganisasi: UIButton!
    @IBOutlet weak var lokasiOrganisasi: UIButton!
    @IBOutlet weak var linkOrganisasi: UIButton!
    @IBOutlet weak var keteranganOrganisasi: UILabel!
    
    var organisasiObject : OrganisasiProfile?
    var organisasiProgramObject: [programObject] = []
    //var organisasiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let organisasi = organisasiObject
             {
                loadImage(link: organisasi.logo)
                namaOrganisasi.text = organisasi.name
                alamatOrganisasi.text = organisasi.email
                //btnAction()
                keteranganOrganisasi.text = organisasi.description
               
                organisasiProgramObject = connector().getOrganizationProgramList(organizationID: organisasi.id, limit: 3)
            
                self.tableView.reloadData()
        }else {
            self.navigationController?.popViewController(animated: false)
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
    
    @IBAction func clickedOnLocation(_ sender: UIButton) {
         print("Open Map")
    }
    
    func btnAction(){
        if callOrganisasi.isTouchInside{
            
            if let phoneURL = NSURL(string: "tel://\(String(describing: organisasiObject?.phone))"){
                    UIApplication.shared.open(phoneURL as URL)
                        }
                    }
        
        if chatOrganisasi.isTouchInside{
            guard let tempPhonenumber = organisasiObject?.phone else {return}
            let whatsapp = "whatsapp://send?phone=\(tempPhonenumber)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(whatsapp)
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
			guard let latiDeg = Double(orgObject.latitude), let longDeg = Double(orgObject.longitude) else {return}
			
			let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2D.init(latitude: latiDeg, longitude: longDeg)
			
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            if organisasiProgramObject.count > 0 {
                return organisasiProgramObject.count + 1
            }else {
                return 0
            }
            
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

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
    
    var organisasiObject : UserProfile?
    var organisasiProgramObject: [programObject] = []
    var organisasiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        organisasiID = "O07"
        
        if let orgID = organisasiID, let organisasi = connector().organizationDetail(organizationID: orgID)
             {
                organisasiID = organisasi.uid
                loadImage(link: organisasi.email)
                namaOrganisasi.text = organisasi.username
                alamatOrganisasi.text = organisasi.email
                //btnAction()
                keteranganOrganisasi.text = organisasi.username
               
                organisasiProgramObject = connector().getOrganizationProgramList(organizationID: orgID, limit: 3)
            
                self.tableView.reloadData()
        }else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func loadImage(link:String){
        DispatchQueue.global(qos: .userInitiated).async {
            let imageFile = UIImage.init(url: URL.init(string: link))
            
            DispatchQueue.main.async {
                self.logoOrganisasi.image = imageFile!
            }
        }
    }
    
    @IBAction func clickedOnLocation(_ sender: UIButton) {
         print("Open Map")
    }
    
    func btnAction(){
        if callOrganisasi.isTouchInside{
            
            if let phoneURL = NSURL(string: "tel://\(String(describing: organisasiObject?.phonenumber))"){
                    UIApplication.shared.open(phoneURL as URL)
                        }
                    }
        
        if chatOrganisasi.isTouchInside{
//            info plistnya itu masih ada yang kurang
//            let urlWhats = "whatsapp://send?phone=+\(String(describing: organisasiObject?.phone))"
//            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
//                if let whatsappURL = URL(string: urlString) {
//                    if UIApplication.shared.canOpenURL(whatsappURL) {
//                        UIApplication.shared.openURL(whatsappURL)
//                    } else {
//                        print("Install Whatsapp")
//                    }
//                }
//            }
//
//            print("chat WA")
        }
        
        if linkOrganisasi.isTouchInside{
            if let url = URL(string: "\(String(describing: organisasiObject?.email))") {
                    UIApplication.shared.open(url, options: [:])
                        }
            }
        
        if lokasiOrganisasi.isTouchInside{
            let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2D.init(latitude: -6, longitude: 106)
			
			//organisasiObject?.email
			let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
			let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = organisasiObject?.username
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

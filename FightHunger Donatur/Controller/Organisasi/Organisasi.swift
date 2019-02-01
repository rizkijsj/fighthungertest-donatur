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
    
    var organisasiObject : organizationObject?
    var organisasiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let organisasiObject = connector().organizationDetail(organizationID: organisasiID!){
            organisasiID = organisasiObject.id
//            loadImage(link: logoOrganisasi!.image)
            namaOrganisasi.text = organisasiObject.name
            alamatOrganisasi.text = organisasiObject.locationName
            btnAction()
            keteranganOrganisasi.text = organisasiObject.description
            
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
    
    func btnAction(){
        if callOrganisasi.isTouchInside{
            
            if let phoneURL = NSURL(string: "tel://\(String(describing: organisasiObject?.phone))"){
                    UIApplication.shared.open(phoneURL as URL)
                        }
                    }
        
        if chatOrganisasi.isTouchInside{
//            chat dengan api WA
        }
        
        if linkOrganisasi.isTouchInside{
            if let url = URL(string: "\(String(describing: organisasiObject?.link))") {
                    UIApplication.shared.open(url, options: [:])
                        }
            }
        
        if lokasiOrganisasi.isTouchInside{
            let regionDistance:CLLocationDistance = 1000
            let coordinates = organisasiObject?.locationCoor
            let regionSpan = MKCoordinateRegion(center: coordinates!, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = organisasiObject?.locationName
            mapItem.openInMaps(launchOptions: options)
        }
        
    }
    
}

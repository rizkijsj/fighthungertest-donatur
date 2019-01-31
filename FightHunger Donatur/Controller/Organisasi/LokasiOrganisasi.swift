//
//  LokasiOrganisasi.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LokasiOrganisasi: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var peta: MKMapView!
    @IBOutlet weak var alamat: UILabel!
    
    var namaOrganisasi = ""
    var alamatLengkap = ""
    var kordinatAsli = [Double]()
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lokasiUser = CLLocationCoordinate2DMake(-6.8694, 109.1402)
        let region = MKCoordinateRegion(center: lokasiUser, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.peta.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
//        annotation.coordinate =
        annotation.title = namaOrganisasi
        
        
        self.peta.addAnnotation(annotation)
        self.peta.delegate = self
        peta.mapType = .standard
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last! as CLLocation
//        let center = CLLocationCoordinate2D(latitude: ko.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.peta.setRegion(region, animated: true)
//        guard let trueData:CLLocationCoordinate2D = manager.location?.coordinate else {return}
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = trueData
//        annotation.title = namaOrganisasi
////        annotation.subtitle = " "
//        peta.addAnnotation(annotation)
//    }
}

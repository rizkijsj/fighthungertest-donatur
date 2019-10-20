//
//  LokasiPengambilan.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 27/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LokasiPengambilan: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var peta: MKMapView!
    @IBOutlet weak var alamat: UILabel!
    @IBOutlet weak var titikAwal: UIButton!
    @IBOutlet weak var pinPoint: UIImageView!
    
    @IBOutlet weak var setLokasi: UIButton!
    @IBOutlet weak var searchOutlet: UIBarButtonItem!
    
    @IBOutlet weak var bacBtnOutlet: UIButton!
    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        selectedLocation = nil
        alamatLengkap = ""
    }
    //    unwindsegue dan pasing data
    var alamatLengkap = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "balikKeDonasi"{
            let destVC = segue.destination as! DonatingController
            destVC.dataAlamat = "\(alamatLengkap)"
            destVC.kordinatPeta = kordinatAsli
        }
    }
    
    
    @IBAction func unwindToLokasi(_ sender: UIStoryboardSegue) {
        let vc = sender.source as! LokasiList
        guard let region = vc.selectedRegion else {return}
        
        peta.setRegion(region, animated: true)
        
    }
    
    
    
    var lokasiSebelumnya: CLLocation?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var selectedLocation:CLPlacemark?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        peta.delegate = self
        peta.addSubview(pinPoint)
        peta.addSubview(titikAwal)
        //peta.addSubview(setLokasi)
        
        
        let center = getCenterLocation(for: peta)
        let geoCoder = CLGeocoder()
        
        guard let lokasiawal = self.lokasiSebelumnya else {return}
        
        center.distance(from: lokasiawal)
        
        self.lokasiSebelumnya = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self](placemarks, error) in
            
            
            guard let self = self  else {return}
            
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            self.selectedLocation = placemark
            
            let namaTempat = placemark.name ?? ""
            let kelurahan = placemark.subLocality ?? ""
            let kecamatan = placemark.locality ?? ""
            let kota = placemark.subAdministrativeArea ?? ""
            let kodePost = placemark.postalCode ?? ""
            let provinsi = placemark.administrativeArea ?? ""
            let negara = placemark.country ?? ""
            
            print("\(String(describing: placemarks))")
            
            DispatchQueue.main.async {
                
                self.alamat.text = "\(namaTempat)" + "," + "\(kelurahan)" + "," + "\(kecamatan)" + "," + "\(kota)" + " " + "\(kodePost)" + " " + "\(provinsi)" + " " + "\(negara)"

                self.alamatLengkap = self.alamat.text!
            }
            
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            peta.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUser()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func startTrackingUser(){
        peta.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        lokasiSebelumnya = getCenterLocation(for: peta)
    }
    
    //    passing data kordinat ke unwind segue
    var kordinatAsli = [Double]()
    func getCenterLocation(for peta: MKMapView) -> CLLocation {
        let latitude = peta.centerCoordinate.latitude
        let longitude = peta.centerCoordinate.longitude
        
        print("ini kordinat: \((latitude,longitude))")
        kordinatAsli = [latitude,longitude]
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func btnTitikAwal(_ sender: UIButton) {
        centerViewOnUserLocation()
        print("test")
    }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        performSegue(withIdentifier: "kelist", sender: self)
        
    }
    
}

extension LokasiPengambilan: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension LokasiPengambilan: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: peta)
        let geoCoder = CLGeocoder()
        
        guard let lokasiawal = self.lokasiSebelumnya else {return}
        
        guard center.distance(from: lokasiawal) > 10 else {return}
        
        self.lokasiSebelumnya = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self](placemarks, error) in
            
            
            guard let self = self  else {return}
            
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            self.selectedLocation = placemark
            
            let namaTempat = placemark.name ?? ""
            let kelurahan = placemark.subLocality ?? ""
            let kecamatan = placemark.locality ?? ""
            let kota = placemark.subAdministrativeArea ?? ""
            let kodePost = placemark.postalCode ?? ""
            let provinsi = placemark.administrativeArea ?? ""
            let negara = placemark.country ?? ""
            
            print("ini alamat lengkap : \(String(describing: placemarks))")
            
            DispatchQueue.main.async {
                
                self.alamat.text = "\(namaTempat)" + "," + "\(kelurahan)" + "," + "\(kecamatan)" + "," + "\(kota)" + " " + "\(kodePost)" + " " + "\(provinsi)" + " " + "\(negara)"
                
                self.alamatLengkap = self.alamat.text!
            }
            
        }
        
    }
}


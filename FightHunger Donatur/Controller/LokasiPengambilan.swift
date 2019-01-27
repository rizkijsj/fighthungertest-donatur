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

class LokasiPengambilan: UIViewController {

    @IBOutlet weak var peta: MKMapView!
    @IBOutlet weak var alamat: UILabel!
    
 
    var lokasiSebelumnya: CLLocation?
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 0.0005
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        peta.delegate = self as! MKMapViewDelegate
    }
    
    func setupLocationManager() {
        locationManager.delegate = self as! CLLocationManagerDelegate
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
    
    func getCenterLocation(for peta: MKMapView) -> CLLocation {
        let latitude = peta.centerCoordinate.latitude
        let longitude = peta.centerCoordinate.longitude
        
        print(latitude,longitude)
        
        return CLLocation(latitude: latitude, longitude: longitude)
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
        
        guard center.distance(from: lokasiSebelumnya!) > 50 else {return}
        
        self.lokasiSebelumnya = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self](placemarks, error) in


            guard let self = self  else {return}

            if let _ = error {
                return
            }

            guard let placemark = placemarks?.first else {
                return
            }

            let noJalan = placemark.subThoroughfare ?? ""
            let jalan = placemark.thoroughfare ?? ""
            let kelurahan = placemark.subLocality ?? ""
            let kecamatan = placemark.locality ?? ""
            let kota = placemark.subAdministrativeArea ?? ""
            let kodePost = placemark.postalCode ?? ""
            let provinsi = placemark.administrativeArea ?? ""
            let negara = placemark.country ?? ""

            print(placemarks)

            DispatchQueue.main.async {
                self.alamat.text = "Lokasi anda: \n\(jalan)" + " " + "\(noJalan)" + " " + "\(kelurahan)" + " " + "\(kecamatan)" + " " + "\(kota)" + " " + "\(kodePost)" + " " + "\(provinsi)" + " " + "\(negara)"
            }

        }
        
    }
}


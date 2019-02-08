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
import GoogleMaps

class LokasiPengambilan: UIViewController, UISearchBarDelegate{
	
	@IBOutlet weak var peta: MKMapView!
	@IBOutlet weak var alamat: UILabel!
	@IBOutlet weak var titikAwal: UIButton!
	@IBOutlet weak var pinPoint: UIImageView!
	
	@IBOutlet weak var setLokasi: UIButton!
	@IBOutlet weak var searchOutlet: UIBarButtonItem!
	
	@IBOutlet weak var bacBtnOutlet: UIButton!
	@IBAction func backBtn(_ sender: Any) {
		//self.navigationController?.popToRootViewController(animated: true)
		self.dismiss(animated: true, completion: nil)
	}
	//    unwindsegue dan pasing data
	var alamatLengkap = ""
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destVC = segue.destination as! DonatingController
		destVC.dataAlamat = "\(alamatLengkap)"
		destVC.kordinatPeta = kordinatAsli
	}
	
	var lokasiSebelumnya: CLLocation?
	let locationManager = CLLocationManager()
	let regionInMeters: Double = 1000
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkLocationServices()
		peta.delegate = self
		peta.addSubview(pinPoint)
		peta.addSubview(titikAwal)
		peta.addSubview(setLokasi)
		
//        let buttonSize = CGFloat(16.0)
//        if #available(iOS 11.0, *){
//            bacBtnOutlet.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//            bacBtnOutlet.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        }else{
//            var frame = bacBtnOutlet.frame
//            frame.size.width = buttonSize
//            frame.size.height = buttonSize
//            bacBtnOutlet.frame = frame
//        }
		
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
			
			let noJalan = placemark.subThoroughfare ?? ""
			let jalan = placemark.thoroughfare ?? ""
			let kelurahan = placemark.subLocality ?? ""
			let kecamatan = placemark.locality ?? ""
			let kota = placemark.subAdministrativeArea ?? ""
			let kodePost = placemark.postalCode ?? ""
			let provinsi = placemark.administrativeArea ?? ""
			let negara = placemark.country ?? ""
			
			print("\(String(describing: placemarks))")
			
			DispatchQueue.main.async {
				self.alamat.text = "Lokasi anda:\(jalan)" + " " + "\(noJalan)" + " " + "\(kelurahan)" + " " + "\(kecamatan)" + " " + "\(kota)" + " " + "\(kodePost)" + " " + "\(provinsi)" + " " + "\(negara)"
				
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
		
		print("ini kordinat: \(latitude,longitude)")
		kordinatAsli = [latitude,longitude]
		
		
		return CLLocation(latitude: latitude, longitude: longitude)
	}
	
	@IBAction func btnTitikAwal(_ sender: UIButton) {
		centerViewOnUserLocation()
		print("test")
	}
	
	
	@IBAction func searchBtn(_ sender: Any) {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
		
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		//       ignoring user
		UIApplication.shared.beginIgnoringInteractionEvents()
		
		//            activity indicator
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.style = UIActivityIndicatorView.Style.gray
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.startAnimating()
		
		self.view.addSubview(activityIndicator)
		
		//        hide search bar
		searchBar.resignFirstResponder()
		dismiss(animated: true, completion: nil)
		
		
		//        create the seacrh request
		let searchRequest = MKLocalSearch.Request()
		searchRequest.naturalLanguageQuery = searchBar.text
		
		let activeSearch = MKLocalSearch(request: searchRequest)
		
		activeSearch.start { (response, error) in
			
			activityIndicator.stopAnimating()
			UIApplication.shared.endIgnoringInteractionEvents()
			
			if response == nil{
				print("ERROR")
			}
			else{
				/*
				//                remove annotation
				let annotations = self.peta.annotations
				self.peta.removeAnnotations(annotations)
				*/
				//                getting data
				let latitude = response?.boundingRegion.center.latitude
				let longitude = response?.boundingRegion.center.longitude
				/*
				//                create annotaion
				let annotation = MKPointAnnotation()
				annotation.title = searchBar.text
				annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
				self.peta.addAnnotation(annotation)
				*/
				//                zooming in on annotation
				let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
				let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
				let region = MKCoordinateRegion.init(center: coordinate, span: span)
				self.peta.setRegion(region, animated: true)
				
				
			}
		}
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
			
            let namaTempat = placemark.name ?? ""
			let noJalan = placemark.subThoroughfare ?? ""
			let jalan = placemark.thoroughfare ?? ""
			let kelurahan = placemark.subLocality ?? ""
			let kecamatan = placemark.locality ?? ""
			let kota = placemark.subAdministrativeArea ?? ""
			let kodePost = placemark.postalCode ?? ""
			let provinsi = placemark.administrativeArea ?? ""
			let negara = placemark.country ?? ""
			
			print("ini alamat lengkap : \(String(describing: placemarks))")
			
			DispatchQueue.main.async {
				self.alamat.text = "\(namaTempat)" + " " + "\(jalan)" + " " + "\(noJalan)" + " " + "\(kelurahan)" + " " + "\(kecamatan)" + " " + "\(kota)" + " " + "\(kodePost)" + " " + "\(provinsi)" + " " + "\(negara)"
				
				self.alamatLengkap = self.alamat.text!
			}
			
		}
		
	}
}


//
//  KegiatanViewController.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation

class KegiatanViewController: UITableViewController {
    
    @IBOutlet weak var fotoDonasi: UIImageView!
    
    @IBOutlet weak var stasus1: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var status4: UIImageView!
    
    @IBOutlet weak var btnKonfirmasi: UIButton!
    @IBOutlet weak var keteranganBtnKonfirmasi: UILabel!
    
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var nomorTelponOrganisasi: UILabel!
    @IBOutlet weak var btnCallOrganisasi: UIButton!
    
    @IBOutlet weak var namaKurir: UILabel!
    @IBOutlet weak var deskripsiKurir: UILabel!
    
    @IBOutlet weak var namaDonasi: UILabel!
    @IBOutlet weak var deskripsiDonasi: UILabel!
    @IBOutlet weak var jumlahDonasi: UILabel!
    @IBOutlet weak var alamatPengambilan: UILabel!
    @IBOutlet weak var waktuPengambilan: UILabel!
    
    @IBOutlet weak var btnBatal: UIButton!
    
    
    @IBOutlet weak var organizationDetail: UITableViewCell!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    var passingObject:transactionObject?
    var transactionID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(openOrganisation))
        
        organizationDetail.gestureRecognizers = [tap]
        
        //        statusDonasi()
        reloadObject()
    }
    
 @objc  func openOrganisation() {
        performSegue(withIdentifier: "toOrganization", sender: self)
    }
    
    func reloadObject(){
        passingObject = connector().transactionDetail(transactionID: transactionID!)
        updateDonationDetails()
    }
    
    func updateDonationDetails(){
        
        if let statusObject = passingObject{
             let organizationObject = connector().organizationDetail(organizationID: statusObject.organizationId)
            
            transactionID = statusObject.id
            statusInteractionUpdate(Status: statusObject.status)
            
            loadImage(link: statusObject.image)
            updateDonationStatus(donationStage: statusObject.status)
            
            namaOrganisasi.text = organizationObject!.name
            nomorTelponOrganisasi.text = organizationObject!.phone
            
            namaKurir.text = statusObject.courierName
            deskripsiKurir.text = statusObject.courierDescription
            
            namaDonasi.text = statusObject.name
            deskripsiDonasi.text = statusObject.description
            jumlahDonasi.text = "\(statusObject.quantity) Item"

            let dateFormat = DateFormatter()
            let timeFormat = DateFormatter()
            dateFormat.locale = Locale.init(identifier: "Id")
            timeFormat.locale = Locale.init(identifier: "Id")
            dateFormat.dateFormat = "MMMM dd yyyy"
            timeFormat.dateFormat = "HH:mm"
            
            waktuPengambilan.text = "\(dateFormat.string(from: statusObject.pickUpTime)),\(timeFormat.string(from:statusObject.pickUpTime)),\(timeFormat.string(from: statusObject.arrivalTime!))"
            
            viewDidLayoutSubviews()
            
        }else{
            print("Failed to load details")
        }
    }
    
    func statusInteractionUpdate(Status:Int){
        
        switch Status {
        case 1:
            btnBatal.isEnabled = true
            batalkanDonasi()
            print("Menunggu konfirmasi")
        case 2:
            btnBatal.isEnabled = true
            batalkanDonasi()
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            print("organisasi mencari Kurir")
        case 3:
            btnKonfirmasi.isEnabled = true
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            if btnKonfirmasi.isTouchInside {
//                push notif ke organisasi
            }
            print("sedang di jemput")
        case 4:
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            print("sedang di antar")
        default:
            print("hmmmm")
            btnKonfirmasi.isEnabled = false
            btnCallOrganisasi.isEnabled = false
            btnBatal.isEnabled = false
        }
    }
    
    func batalkanDonasi(){
//        push donasi
    }
    
    func callOrganisasi(){
        if btnCallOrganisasi.isTouchInside {
            nomorTelponOrganisasi.resignFirstResponder()
            
            if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
                UIApplication.shared.open(phoneURL as URL)
            }
        }
    }
    
    func loadImage(link:String){
        DispatchQueue.global(qos: .userInitiated).async {
            let imageFile = UIImage.init(url: URL.init(string: link))
            
            DispatchQueue.main.async {
                self.fotoDonasi.image = imageFile!
            }
            
        }
    }
    
    func updateDonationStatus(donationStage:Int){
        
        if donationStage == 0 {
            print("baru push dari donatur")
        }else if donationStage == 1 {
        print("Menunggu untuk di claim")
            btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
        }else if donationStage == 2 {
            print("Menunggu Menunggu Data Kurir")
            stasus1.image = UIImage.init(named: "pin1a")
            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
            btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
        }else if donationStage == 3 {
            print("Mengirim Kurir")
            stasus1.image = UIImage.init(named: "pin1a")
            status2.image = UIImage.init(named: "pin2a")
            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
            btnKonfirmasi.setImage(UIImage(named: "konfirmasi aktif"), for: .normal)
        } else if donationStage == 4 {
            print("Sedang diantar")
            stasus1.image = UIImage.init(named: "pin1a")
            status2.image = UIImage.init(named: "pin2a")
            status3.image = UIImage.init(named: "pin2a")
            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
        } else if donationStage == 5 {
            print("Sudah sampai organisasi")
            stasus1.image = UIImage.init(named: "pin1a")
            status2.image = UIImage.init(named: "pin2a")
            status3.image = UIImage.init(named: "pin3a")
            status4.image = UIImage.init(named: "pin4a")
            
        }
        
    }
    
}


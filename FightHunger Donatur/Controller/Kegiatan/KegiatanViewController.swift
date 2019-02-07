//
//  KegiatanViewController.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class KegiatanViewController: UITableViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
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
        
        if section == 0 {
            return 3
        }else if section ==  1 {
            return 3
        }else if section == 2{
            return 3
        }else if section == 3 {
            return 6
        }else if section == 4 {
            return 1
        }
        
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    /*
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    */
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    var passingObject:Post?
    var transactionID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(openOrganisation))
        
        organizationDetail.gestureRecognizers = [tap]
        
        //        statusDonasi()
        //reloadObject()
        updateDonationDetails()
    }
    
    
    
    @IBAction func konfirmasiAct(_ sender: Any) {
        konfirmasiPickup { (result) in
            if result{
                print("sukses di konfirmasi")
                self.reloadObject()
            }else{
                print("gagal di konfirmasi")
            }
        }
    }
    
    
    
    
    
 @objc  func openOrganisation() {
        performSegue(withIdentifier: "toOrganization", sender: self)
    }
    
    func reloadObject(){
        transactionID = "T1"
        if let transID = transactionID {
        passingObject = connector().transactionDetail(transactionID: transID)
            passingObject?.status = 1
            updateDonationDetails()
        }else{
          dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
    func updateDonationDetails(){
        
        if let statusObject = passingObject{
			print("lala")
            print(statusObject.status)
            transactionID = statusObject.id
            statusInteractionUpdate(Status: statusObject.status)
            
            //loadImage(link: statusObject.postphotourl)
            ImageService.getImage(withURL: statusObject.postphotourl) { image, url in
                self.fotoDonasi.image = image
                
            }
            updateDonationStatus(donationStage: statusObject.status)
			
			

            namaOrganisasi.text = statusObject.namakomunitas
            nomorTelponOrganisasi.text = statusObject.idkomunitas
				
			
            
            
            namaKurir.text = statusObject.namakurir
            deskripsiKurir.text = statusObject.deskripsikurir
        
            namaDonasi.text = statusObject.namaitem
            print(statusObject.namaitem)
            deskripsiDonasi.text = statusObject.deskripsi
            jumlahDonasi.text = "\(statusObject.jumlahbarang) Item"

            let dateFormat = DateFormatter()
            let timeFormat = DateFormatter()
            dateFormat.locale = Locale.init(identifier: "Id")
            timeFormat.locale = Locale.init(identifier: "Id")
            dateFormat.dateFormat = "MMMM dd yyyy"
            timeFormat.dateFormat = "HH:mm"
            
            
            
            waktuPengambilan.text = "\(dateFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil))), \(timeFormat.string(from: Date(timeIntervalSince1970: statusObject.waktuambil)))"
        
        
        
        }else{
            print("Failed to load details")
        }
    }
    
    func statusInteractionUpdate(Status:Int){
        
		if Status == 1 {
            btnBatal.isEnabled = true
            batalkanDonasi()
            print("Menunggu konfirmasi")
		}else if Status == 2{
            btnBatal.isEnabled = true
            batalkanDonasi()
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            print("organisasi mencari Kurir")
        }else if Status == 3{
            btnKonfirmasi.isEnabled = true
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            if btnKonfirmasi.isTouchInside {
//                push notif ke organisasi
            }
            print("sedang di jemput")
        }else if Status == 4{
            btnCallOrganisasi.isEnabled = true
            callOrganisasi()
            print("sedang di antar")
        }else{
            print("hmmmm")
            btnKonfirmasi.isEnabled = false
            btnCallOrganisasi.isEnabled = false
            btnBatal.isEnabled = false
        }
    }
    
    func batalkanDonasi(){
//        push donasi
        guard let uid = Auth.auth().currentUser?.uid else { return }

        guard let idtransaksi = passingObject?.idtransaksi else{return}

//        guard let alasanBatal = alasanBatalTextField.text else{return}
        
//        let databaseRef = Database.database().reference().child("Post/\(uid)/\(idtransaksi)/transaksi")
//
//        let userObject = [
//            "alasanbatal": alasanbatal,"status": status] as [String:Any]
//
//        databaseRef.updateChildValues(userObject) { error, ref in
//            if error == nil{
//                print("sukses")
//               // completion(true)
//            }else{
//
//            }
//        }
    }
    
    func konfirmasiPickup(completion: @escaping (Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let idtransaksi = passingObject?.idtransaksi else {return}
        
        //        guard let alasanBatal = alasanBatalTextField.text else{return}
        
                let databaseRef = Database.database().reference().child("Post/\(uid)/\(idtransaksi)/transaksi")
        
                let userObject = ["status": 4] as [String:Any]
        
                databaseRef.updateChildValues(userObject) { error, ref in
                    if error == nil{
                        print("sukses")
                       completion(true)
                    }else{
                        completion(false)
                    }
                }
    }
    
    func callOrganisasi(){
        if btnCallOrganisasi.isTouchInside {
            nomorTelponOrganisasi.resignFirstResponder()
            
            if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
                UIApplication.shared.open(phoneURL as URL)
            }
        }
    }
    
    func loadImage(link:URL){
        DispatchQueue.global(qos: .userInitiated).async {
            let image = UIImage.init(url: link)
			
			guard let imageFile = image else {return}
            DispatchQueue.main.async {
                self.fotoDonasi.image = imageFile
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


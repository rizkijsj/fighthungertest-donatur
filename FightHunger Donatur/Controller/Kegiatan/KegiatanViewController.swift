//
//  KegiatanViewController.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class KegiatanViewController: UITableViewController {
    
    @IBOutlet weak var fotoDonasi: UIImageView!
    
    @IBOutlet weak var stasus1: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var status4: UIImageView!
    
    @IBOutlet weak var labaelStatus1: UILabel!
    @IBOutlet weak var labelStatus2: UILabel!
    @IBOutlet weak var labelStatus3: UILabel!
    @IBOutlet weak var labelStatus4: UILabel!
    @IBOutlet weak var btnKonfirmasi: UIButton!
    
    
//    @IBAction func konfirmasi(_ sender: UIButton) {
////        status3.image = ""
//
//    }
    
    @IBOutlet weak var keteranganBtnKonfirmasi: UILabel!
    
    
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var nomorTelponOrganisasi: UILabel!
    @IBAction func telponOrganisasi(_ sender: UIButton) {
        
        nomorTelponOrganisasi.resignFirstResponder()
        
        if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
            UIApplication.shared.open(phoneURL as URL)
            
        }
    }
    
    @IBOutlet weak var namaKurir: UILabel!
    @IBOutlet weak var deskripsiKurir: UILabel!
    
    @IBOutlet weak var namaDonasi: UILabel!
    @IBOutlet weak var deskripsiDonasi: UILabel!
    @IBOutlet weak var jumlahDonasi: UILabel!
    @IBOutlet weak var alamatPengambilan: UILabel!
    @IBOutlet weak var waktuPengambilan: UILabel!
    
    @IBAction func batalkan(_ sender: UIButton) {
        
    }
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    var tempNamaOrganisasi = ""
    var tempNotelpOrganisasi = ""
    
    var tempNamaKurir = ""
    var tempDeskripsiKurir = ""
    
    var tempNamaDonasi = ""
    var tempDeskripsiDonasi = ""
    var tempJumlahDonasi = ""
    
    var tempLokasiDonatur = ""
    var tempKordinatDonatur = [Double]()
    
    var tempWaktuPengambilan = ""
    
    /*
     ini penmapung buat ke push notif apa?
    var notifDariOrganisasi = true
     */
    
    func statusDonasi(){
        /*
        if notifDariOrganisasi == 1 {
            btnKonfirmasi.inenable == false
            stasus1.image = "status1.jpg"
            namaOrganisasi.text = "-"
            nomorTelponOrganisasi.text = "-"
            namaKurir.text = "-"
            deskripsiKurir.text = "-"
            print("mencarikan kurir")
        }
         else if notifDariOrganisasi == 2 {
            btnKonfirmasi.inenable == false
            stasus2.image = "status2.jpg"
            namaOrganisasi.text = self.tempNamaOrganisasi.text!
            nomorTelponOrganisasi.text = self.tempNotelpOrganisasi.text!
            namaKurir.text = self.tempNamaKurir.text!
            deskripsiKurir.text = self.tempDeskripsiKurir.text!
            print("sedang dijemput")
         }
         else if notifDariOrganisasi == 3 {
         
            namaOrganisasi.text = self.tempNamaOrganisasi.text!
            nomorTelponOrganisasi.text = self.tempNotelpOrganisasi.text!
            namaKurir.text = self.tempNamaKurir.text!
            deskripsiKurir.text = self.tempDeskripsiKurir.text!
         
            btnKonfirmasi.inenable == true
            if btnKonfirmasi.addAction( .touch) {
                stasus3.image = "status3.jpg"
                push data ke organisasi
         }
            print("sedang diantar")
         }
         else if notifDariOrganisasi == 4 {
         
            namaOrganisasi.text = self.tempNamaOrganisasi.text!
            nomorTelponOrganisasi.text = self.tempNotelpOrganisasi.text!
            namaKurir.text = self.tempNamaKurir.text!
            deskripsiKurir.text = self.tempDeskripsiKurir.text!
         
            btnKonfirmasi.inenable == false
            btnKonfirmasi.backgroundimage = "Selesai"
            stasus4.image = "status4.jpg"
            print("Sampai Organisasi")
         }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tempNamaOrganisasi = namaOrganisasi.text!
//        self.tempNotelpOrganisasi = nomorTelponOrganisasi.text!
        
        

        
    }
    

  
}

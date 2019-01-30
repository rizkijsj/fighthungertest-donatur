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
    
//    @IBOutlet weak var labaelStatus1: UILabel!
//    @IBOutlet weak var labelStatus2: UILabel!
//    @IBOutlet weak var labelStatus3: UILabel!
//    @IBOutlet weak var labelStatus4: UILabel!
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
//    penampung
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
     Tolong dibbantu ya .....
     
     ini penampung buat ke push notif apa?
    var notifDariOrganisasi = ????
     */
    
    // FIXME: Replace with something
    /*
    func statusDonasi(){
        if notifDariOrganisasi == 0 {
            btnBatal.isEnabled = true
            btnKonfirmasi.isEnabled = false
            btnKonfirmasi.setImage(UIImage(named: "konfirmasi"), for: .normal)
            stasus1.image = UIImage(named: "pin1b")
            namaOrganisasi.text = "-"
            nomorTelponOrganisasi.text = "-"
            namaKurir.text = "-"
            deskripsiKurir.text = "-"
            btnCallOrganisasi.isEnabled = false
            btnBatal.isEnabled = true
            if btnBatal.isTouchInside == true {
//                push ke organisasi
            }
            
            print("nunggu konfirmasi")
        }
        
        else if notifDariOrganisasi == 1 {
            btnKonfirmasi.isEnabled = false
            btnKonfirmasi.setImage(UIImage(named: "konfirmasi"), for: .normal)
            stasus1.image = UIImage(named: "pin1a")
            namaOrganisasi.text = " "
            nomorTelponOrganisasi.text = " "
            namaKurir.text = " "
            deskripsiKurir.text = " "
            btnCallOrganisasi.isEnabled = false
            btnBatal.isEnabled = false
            print("mencarikan kurir")
        }
         else if notifDariOrganisasi == 2 {
            btnKonfirmasi.isEnabled = false
            btnKonfirmasi.setImage(UIImage(named: "konfirmasi aktif"), for: .normal)
            status2.image = UIImage(named: "pin2a")
            namaOrganisasi.text = tempNamaOrganisasi
            nomorTelponOrganisasi.text = tempNotelpOrganisasi
            namaKurir.text = tempNamaKurir
            deskripsiKurir.text = tempDeskripsiKurir
            btnCallOrganisasi.isEnabled = true
            if btnCallOrganisasi.isTouchInside == true{
                nomorTelponOrganisasi.resignFirstResponder()
                
                if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
                    UIApplication.shared.open(phoneURL as URL)
                    
                }
            }
            btnCallOrganisasi.setBackgroundImage(UIImage(named: "Logo call"), for: .normal)
            print("sedang dijemput")
         }
         else if notifDariOrganisasi == 3 {
         
            namaOrganisasi.text = tempNamaOrganisasi
            nomorTelponOrganisasi.text = tempNotelpOrganisasi
            namaKurir.text = tempNamaKurir
            deskripsiKurir.text = tempDeskripsiKurir
            btnCallOrganisasi.isEnabled = true
            btnCallOrganisasi.setBackgroundImage(UIImage(named: "Logo call"), for: .normal)
         
            btnKonfirmasi.isEnabled = true
            btnKonfirmasi.setImage(UIImage(named: "konfirmasi aktif"), for: .normal)
            if btnKonfirmasi.isTouchInside == true {
                status3.image = UIImage(named: "pin3a")
                btnKonfirmasi.setImage(UIImage(named: "dikonfirmasi"), for: .normal)
//                push data ke organisasi
         }
            
            btnBatal.isEnabled = false
            print("sedang diantar")
         }
         else if notifDariOrganisasi == 4 {
         
            namaOrganisasi.text = tempNamaOrganisasi
            nomorTelponOrganisasi.text = tempNotelpOrganisasi
            namaKurir.text = tempNamaKurir
            deskripsiKurir.text = tempDeskripsiKurir
            btnCallOrganisasi.isEnabled = true
            btnCallOrganisasi.setBackgroundImage(UIImage(named: "Logo call"), for: .normal)
            btnKonfirmasi.isEnabled = false
            btnKonfirmasi.setImage(UIImage(named: "selesai"), for: .normal)
            status4.image = UIImage(named: "pin4a")
            btnBatal.isEnabled = false
            print("Sampai Organisasi")
         }
 
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        statusDonasi()
        
    }
    
}

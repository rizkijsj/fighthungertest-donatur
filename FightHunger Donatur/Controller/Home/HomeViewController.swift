//
//  HomeViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 28/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var donasiBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        //MAKE ROUNDED BUTTON
        donasiBtn.layer.cornerRadius = 6.0
        
         combined = NSMutableArray(array: [fotoKegiatan,labelJudulKegiatan,isiKegiatan,fotoOrganisasi,namaOrganisasi,wktOrganisasi,fotoMitra,labelOrganisasi,alamatorganisasi,ketKota,jarak,fotoOrg,fotoDonasi,statusLabel,namaOrg,namaDonasi,kadaluarsa,ketWaktu])
    }
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
     var combined : NSMutableArray!
    
    let titleSection = ["Aktivitas","Kegiatan Terbaru","Mitra Kami"]
    
    //section kegiatan
    let fotoKegiatan: [UIImage] = [UIImage(named: "foto")!,UIImage(named: "foto")!]
    
    let labelJudulKegiatan = ["Dana Bantuan Pangan untuk Anak-anak Korban Tsunami Pandeglang","test"]
    
    let isiKegiatan = ["The Hunger Bank membuka bantuan sumbangan dari para donatur","test sajalah"]
    
    let fotoOrganisasi: [UIImage] = [UIImage(named: "foto")! ,UIImage(named: "foto")!]
    
    let namaOrganisasi = ["The Hunger Bank" , "Foodbank of Indonesia"]
    
    let wktOrganisasi = ["5 Jam yang lalu", "3 Jam yang lalu"]
    
    //section mitra kami
    let fotoMitra: [UIImage] = [UIImage(named: "foi")! ,UIImage(named: "foi")!,UIImage(named: "foto")!]
    let labelOrganisasi = ["Foodbank of Indonesia","Foodbank of Indonesia","haha"]
    let alamatorganisasi = ["Jalan Makmur Jaya Raya nomor 14 , Jakarta","Jalan Makmur Jaya Raya nomor 14 , Jakarta","yyaa"]
    let ketKota = ["Tangerang", "Jakarta Timur","hihi"]
    let jarak = ["Jarak 700 m" , "Jarak 1500 m","hihu"]
    
   //section aktivitas
    let fotoOrg: [UIImage] = [UIImage(named: "foi")!, UIImage(named: "foi")!]
    let statusLabel = ["Mencarikan status","Sedang dijemput"]
    let kadaluarsa = ["Kadaluarsa masih 2 bulan lagi","Kadaluarsa masih 4 bulan lagi"]
    let fotoDonasi: [UIImage] = [UIImage(named: "foto")! , UIImage(named: "foto")!]
    let namaOrg = ["Foodbank of Indonesia","The Hunger Bank Indonesia"]
    let ketWaktu = ["5 menit yang lalu","1 hari yang lalu"]
    let namaDonasi = ["Susu UHT Steril","Pizza"]
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
               
                //print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
              
                //print("Unhide")
            }, completion: nil)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let viewSection = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectioncell", for: indexPath) as! SectionCollectionReusableView
        
       viewSection.sectionLabel.text = titleSection[indexPath.section]
        
        return viewSection
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return titleSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return (combined.object(at: section)as! NSArray).count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "aktivitascell", for: indexPath) as! aktivitasCollectionViewCell
            
            cell.fotoDonasi.image = fotoDonasi[indexPath.row]
            cell.statusDonasi.text = statusLabel[indexPath.row]
            cell.namaDonasi.text = namaDonasi[indexPath.row]
            cell.kadaluarsaLabel.text = kadaluarsa[indexPath.row]
            cell.fotoOrganisasi.image = fotoOrg[indexPath.row]
            cell.namaOrganisasi.text = namaOrg[indexPath.row]
            cell.keteranganWaktu.text = ketWaktu[indexPath.row]
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        }
        else if indexPath.section ==  1
        {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "kegiatancell", for: indexPath) as! HomeCollectionViewCell
            
            cell.fotoKegiatan.image = fotoKegiatan[indexPath.row]
            cell.judulKegiatan.text = labelJudulKegiatan[indexPath.row]
            cell.isiKegiatan.text = isiKegiatan[indexPath.row]
            cell.fotoOrganisasi.image = fotoOrganisasi[indexPath.row]
            cell.namaOrganisasi.text = namaOrganisasi[indexPath.row]
            cell.waktuKegiatan.text = wktOrganisasi[indexPath.row]
            
            return cell
        }
        else
        {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "mitracell", for: indexPath) as! MitraCollectionViewCell
            
            cell.fotoMitra.image = fotoMitra[indexPath.row]
            cell.labelOrganisasi.text = labelOrganisasi[indexPath.row]
            cell.alamatOrganisasi.text = alamatorganisasi[indexPath.row]
            cell.keteranganKota.text = ketKota[indexPath.row]
            cell.keteranganJarak.text = jarak[indexPath.row]
            
			
            
            //add border
            cell.layer.borderWidth = 10.0
            cell.layer.borderColor = UIColor.gray.cgColor
			return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0
        {
           
             return CGSize(width: 343, height: 116)
        }
        else if indexPath.section == 1
        {
            return CGSize(width: 343, height: 332)
        }
        else
        {
            return CGSize(width: 343, height: 160)
        }
        
    }
}

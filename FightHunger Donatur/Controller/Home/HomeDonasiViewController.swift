//
//  HomeDonasiViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class HomeDonasiViewController: UIViewController , UITableViewDataSource,UITableViewDelegate {
    
    let fotoDonasi:[UIImage] = [UIImage(named: "foto")!,UIImage(named: "foto")!]
    let statusDonasi = ["Mencarikan kurir", "Sedang dijemput"]
    let namaDonasi = ["Susu UHT steril", "Mie instant"]
    let kadaluarsa = ["Kadaluarsa masih 2 bulan lagi","Kadaluarsa masih 4 bulan lagi"]
    let fotoOrgn:[UIImage] = [UIImage(named: "foi")!,UIImage(named: "foi")!]
    let namaOrgn = ["Foodbnak of Indonesia","The Hunger Bank"]
    let wktPost = ["5 menit yang lalu","1 menit yang lalu"]
    
    let namaSection = ["Aktivitas","Kegiatan Terbaru","Mitra kami"]
    
    let judulKegiatan = ["ada apa dengan tsunami di pandeglang?","ada apa dengan tsunami di pandeglang?"]
    let isiKegitan = ["The Hunger Bank membuka bantuan sumbangan dari para donatur", "The Hunger Bank membuka bantuan sumbangan dari para donatur"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fotoOrgn.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section < namaSection.count
        {
            return namaSection[section]
        }
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return namaSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = myTableview.dequeueReusableCell(withIdentifier: "cellaktivitas", for: indexPath) as! aktivitasTableViewCell
            
            cell.fotoDonasi.image = fotoDonasi[indexPath.row]
            cell.statusDonasi.text = statusDonasi[indexPath.row]
            cell.namaDonasi.text = namaDonasi[indexPath.row]
            cell.kadaluarsaDonasi.text = kadaluarsa[indexPath.row]
            cell.fotoOrg.image = fotoOrgn[indexPath.row]
            cell.namaOrg.text = namaOrgn[indexPath.row]
            cell.wktPost.text = wktPost[indexPath.row]
            
            return cell
		}else{
			return UITableViewCell.init()
		}
        
    }
    
    @IBOutlet weak var myTableview: UITableView!
    
    @IBOutlet weak var donasiBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make rounded
         donasiBtn.layer.cornerRadius = 6.0
         myTableview.delegate = self
         myTableview.dataSource = self
        
         combined = NSMutableArray(array: [fotoDonasi,fotoOrgn,namaOrgn,namaDonasi,statusDonasi,judulKegiatan,isiKegitan,kadaluarsa])
    }
	
	
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		/*
        if indexPath.row == 0 {
			
			if let cell = cell as? {
				cell
			}
			
            if let cell = cell as? {
				
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.isScrollEnabled = false
            }
        }
*/
    }
    
    var combined : NSMutableArray!
    
    //will hide navbar when acrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            
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

extension HomeDonasiViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let viewSection = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellsection", for: indexPath) as! CollectionReusableView
        
       viewSection.labelSection.text = namaSection[indexPath.section]
        
        return viewSection
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return namaSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return (combined.object(at: section)as! NSArray).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kegiatancell", for: indexPath) as! kegiatanCollectionViewCell
            
            cell.fotoKegiatan.image = fotoOrgn[indexPath.row]
            cell.judulKegiatan.text = judulKegiatan[indexPath.row]
            cell.isiKegiatan.text = isiKegitan[indexPath.row]
            cell.fotoOrg.image = fotoOrgn[indexPath.row]
            cell.namaOrg.text = namaOrgn[indexPath.row]
            cell.wktPost.text = wktPost[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
   
    
}

//
//  RiwayatViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class RiwayatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
 
    @IBOutlet weak var tableView: UITableView!
    
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
    
    let fotoDonasi: [UIImage] = [UIImage(named: "foto")!, UIImage(named: "foto")!]
    let namaDonasi = ["Stroberi","Siomay"]
    let keteranganDonasi = ["Stoberi masih segar","Siomay baru dimasak tadi pagi dan tidak habis, terlalu banyak"]
    let fotoOrganisasi : [UIImage] = [UIImage(named: "foi")!, UIImage(named: "foi")!]
    let namaOrganisasi = ["Foodbank of Indonesia", "The Hunger Bank"]
    let keteranganWkt = ["23 Jan,08:24","24 Mei,18:34"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fotoDonasi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "riwayatcell", for: indexPath) as! RiwayatTableViewCell
        
        cell.fotoDonasi.image = fotoDonasi[indexPath.row]
        cell.namaDonasi.text = namaDonasi[indexPath.row]
        cell.fotoOrgn.image = fotoOrganisasi[indexPath.row]
        cell.keteranganDonasi.text = keteranganDonasi[indexPath.row]
        cell.namaOrgn.text = namaOrganisasi[indexPath.row]
        cell.keteranganWkt.text = keteranganWkt[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    

   

}

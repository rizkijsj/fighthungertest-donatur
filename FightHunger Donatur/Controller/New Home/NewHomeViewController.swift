//
//  NewHomeViewController.swift
//  FightHunger Donatur
//
//  Created by zein rezky chandra on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class NewHomeViewController: UIViewController {

    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    // activity data should always referred to your data source, which it will be real time updated data
    var activityData = [1]
    var temporaryArrayData = ["asd", "bsdn", "kausrg", "asjdfyr"]
    // new activity data should always referred to your data source, which it will be real time updated data
    var newActivityData = [1,3]
    // partner data should always referred to your data source, which it will be real time updated data
    var partnerData = [1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set what needs to display within your view
        setupView()
    }
    
    func setupView(){
        // Register all required cell that have to display in UITableView
        tableView.register(UINib(nibName: "SectionOneHomeCell", bundle: nil), forCellReuseIdentifier: "activityCellID")
        tableView.register(UINib(nibName: "SectionTwoHomeCell", bundle: nil), forCellReuseIdentifier: "newActivityCellID")
        tableView.register(UINib(nibName: "SectionThreeHomeCell", bundle: nil), forCellReuseIdentifier: "partnerCellID")
        
        // Set the donate button corner radius to comply design requirement
        donateButton.layer.cornerRadius = 6.0
        donateButton.layer.masksToBounds = true
    }

}

extension NewHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Consider to use section to separate the content based on design objective, "Activity" section, "New Activity" Section, "Partner" Section
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return temporaryArrayData.count
        case 1:
            return newActivityData.count
        case 2:
            return partnerData.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
        label.textColor = .black
        headerView.addSubview(label)

        switch section {
        case 0:
            label.text = "Aktivitas"
        case 1:
            label.text = "Kegiatan Terbaru"
        case 2:
            label.text = "Mitra Kami"
        default:
            label.text = ""
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1
        {
            if  indexPath.row == 0
            {
                print("test")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return 324
        case 2:
            return 88
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as? SectionOneHomeCell)!
            
            cell.contentName.text = temporaryArrayData[indexPath.row]
            
            return cell
        case 1:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "newActivityCellID", for: indexPath) as? SectionTwoHomeCell)!
            
            return cell
        case 2:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "partnerCellID", for: indexPath) as? SectionThreeHomeCell)!
            
            return cell
        default:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "activityCellID", for: indexPath) as? SectionOneHomeCell)!
            
            return cell
        }
        
        
    }
    
    
    //hide navbar when scrolling
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

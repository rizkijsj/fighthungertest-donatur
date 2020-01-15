//
//  KegiatanTerbaruController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class KegiatanTerbaruController: UITableViewController {
    
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var isiKegiatan: UILabel!
    @IBOutlet weak var titleKegiatan: UILabel!
    @IBOutlet weak var imgOrganisasi: UIImageView!
    @IBOutlet weak var imageProgram: UIImageView!
    @IBOutlet weak var namaLokasiProgram: UILabel!
    @IBOutlet weak var waktuProgram: UILabel!
    
    @IBOutlet weak var btnDonasi: UIButton!
    
    var passingObject: Kegiatan?
    var organisationObject: OrganisasiProfile?
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        btnDonasi.layer.cornerRadius = btnDonasi.frame.height / 8
        
        reloadObject()
        observeOrganisasi()
        
        let tapBtnDonate = UITapGestureRecognizer(target: self, action: #selector(toDonationPage))
        btnDonasi.addGestureRecognizer(tapBtnDonate)
        
        
        makeRounded()
        
        //Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        imgOrganisasi.isUserInteractionEnabled = true
        imgOrganisasi.addGestureRecognizer(tapGesture)
        
        //Tap Gesture Program
        let tapProgram = UITapGestureRecognizer(target: self, action: #selector(self.onTapProgram))
        imageProgram.isUserInteractionEnabled = true
        imageProgram.addGestureRecognizer(tapProgram)
    }
    
    func makeRounded()
    {
        self.imgOrganisasi.layer.cornerRadius = 8.0
        self.imgOrganisasi.clipsToBounds = true
        self.imgOrganisasi.layer.shadowColor = UIColor.gray.cgColor
        self.imgOrganisasi.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.imgOrganisasi.layer.shadowRadius = 2.0
        self.imgOrganisasi.layer.shadowOpacity = 0.4
        self.imgOrganisasi.layer.masksToBounds = false
        imgOrganisasi.layer.shadowPath = UIBezierPath(rect: imgOrganisasi.bounds).cgPath
        
    }
    //to donating
    @objc func toDonationPage(){
        performSegue(withIdentifier: "toDonate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //print("\n\n\n\nPreparing\n\n\n")
        if segue.identifier == "toDonate" {
            //print("I ma go here")
            let navbar = segue.destination as! UINavigationController
            let vc = navbar.topViewController as! DonatingController
            sendOrgDataToDonate()
            guard let orgObj = organisationObject else {return}
            //print("there")
            vc.selectedOrganization = orgObj
            //print("Done")
        }else if segue.identifier == "ToOrganization" {
            let vc = segue.destination as! Organisasi
            vc.organisasiObject = organisationObject
        }
        
        
    }
    
    func reloadObject(){
        if let _ = passingObject {
            loadProgramDetails()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @objc func onTapProgram()
    {
        guard let progObject = passingObject else {return}
        
        imageProgram.kf.indicatorType = .activity
        imageProgram.kf.setImage(
            with:  progObject.programImage,
            placeholder: UIImage.init(color: .white),
            options: [
                .transition(.fade(1))
            ])
        {
            result in
            switch result {
            case .success( _):
                print("Yey")
            case .failure( _):
                print("Nay")
            }
        }
        
        
        let passingimg = imageProgram.image
        
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "Next") as! PopUpVC
        nextVC.imageimg = passingimg!
        
        self.present(nextVC, animated: true, completion: nil)
        print("testk")
    }
    
    @objc func onTap()
    {
        
        
        self.performSegue(withIdentifier: "ToOrganization", sender: self)
        print("tap")
        
    }
    
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func loadProgramDetails(){
        guard let progObject = passingObject else {return}
        
        
        imageProgram.kf.indicatorType = .activity
        imageProgram.kf.setImage(
            with: progObject.programImage,
            placeholder: UIImage.init(color: .white),
            options: [
                .transition(.fade(1))
            ])
        {
            result in
            switch result {
            case .success( _):
                print("Yey")
            case .failure( _):
                print("Nay")
            }
        }
        
        titleKegiatan.text = progObject.programName
        isiKegiatan.text = progObject.programInformation
        namaLokasiProgram.text = progObject.programLocation
        waktuProgram.text = progObject.programDate
        
        if let orgObject = organisationObject {
            
            imgOrganisasi.kf.indicatorType = .activity
            imgOrganisasi.kf.setImage(
                with: orgObject.logo,
                placeholder: UIImage.init(color: .white),
                options: [])
            {
                result in
                switch result {
                case .success( _):
                    print("Yey")
                case .failure( _):
                    print("Nay")
                }
            }
            
        }
        
    }
    
    
    func sendOrgDataToDonate(){
        guard let orgObject = organisationObject else {return}
        let orgDataKegiatan = orgObject.id
        defaults.set(orgDataKegiatan, forKey: "idOrgKegiatan")
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 193/255, green: 27/255, blue: 42/255, alpha: 1)]
    }
    
    
    func observeOrganisasi() {
        
        //        guard let userProfile = UserService.currentUserProfile else { return }
        //        let uid = userProfile.uid
        guard let progObject = passingObject else {return}
        
        let orgRef = Database.database().reference().child("users/komunitas")
        var tempOrganisasi:OrganisasiProfile?
        
        orgRef.observe(.value, with: { snapshot in
            
            
            //var tempIdProfile = String
            //print("Check12")
            for child in snapshot.children {
                print(child)
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    
                    let locationcoor = dict["locationcoor"] as? [String:Any],
                    let latitude = locationcoor["latitude"] as? Double,
                    let longitude = locationcoor["longitude"] as? Double,
                    let address = dict["locationname"] as? String,
                    //                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitude] as NSString).doubleValue), longitude: Double(([latitude] as NSString).doubleValue)),
                    let logo = dict["logo"] as? String,
                    let logourl = URL(string: logo),
                    
                    let link = dict["link"] as? String,
                    let linkwebsite = URL(string: link),
                    
                    let name = dict["name"] as? String,
                    let phonenumber = dict["phone"] as? String,
                    let deskripsi = dict["description"] as? String,
                    let email = dict["email"] as? String,
                    let id = dict["id"] as? String{
                    print("nelis ndud ndud")
                    let organisasi = OrganisasiProfile(orgId: id, orgPhone: phonenumber, orgEmail: email, orgName: name, orgDesc: deskripsi, orgLogo: logourl, orgLocName: address, latitude: latitude, longitude: longitude, orgLink: linkwebsite)
                    
                    
                    
                    if organisasi.id == progObject.orgId {
                        tempOrganisasi = organisasi
                    }
                    //                    if userProfile.uid == Auth.auth().currentUser?.uid
                    //                    {
                    //                        tempOrganisasi.append(post)
                    //
                    //                    }
                }else {print("Error?")}
            }
            
            DispatchQueue.main.async {
                guard let tempOrg = tempOrganisasi else {return}
                print("berhasil ambil data organisasi")
                self.organisationObject = tempOrg
                //self.tableView.reloadData()
                
                UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.reloadObject()
                }, completion: nil)
                
            }
            
            
        })
        
    }
    
    
}

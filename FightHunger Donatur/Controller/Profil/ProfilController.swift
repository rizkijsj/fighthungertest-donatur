//
//  ProfilController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class ProfilController: UITableViewController {

    @IBOutlet weak var namaLbl: UILabel!
    @IBOutlet weak var noHpLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
	
	var passingOrgObject = [OrganisasiProfile]()
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
       // print("hei")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfileData()
        tableView.delegate = self
        tableView.dataSource = self
 
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toRIwayat" {
			let vc = segue.destination as! RiwayatViewController
			vc.passingOrgObject = passingOrgObject
		}
	}
  
    @objc func dismissProfile(){
        
    }

    @IBAction func clickedOnArrowBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if section == 0
       {
            return 2
        }else
       {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            if indexPath.row == 1
            {
                performSegue(withIdentifier: "toUbahProfile", sender: self)
            }
        }
        
        if indexPath.section == 2
        {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "GoToHome", sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }

    func loadUserProfileData(){
        guard let userProfile = UserService.currentUserProfile else { print("error lagi bro");return }
        emailLbl.text = userProfile.email
        namaLbl.text =  userProfile.username
        noHpLbl.text = userProfile.phonenumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

//
//  Organisasi.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class Organisasi: UITableViewController {

    @IBOutlet weak var logoOrganisasi: UIImageView!
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var alamatOrganisasi: UILabel!
    
//    telpon organisasi
    var nomortelponOrganisasi = ""
    @IBAction func btnCallOrganisasi(_ sender: UIButton) {
        
//        nomortelponOrganisasi.resignFirstResponder()

        if let phoneURL = NSURL(string: "tel://\(nomortelponOrganisasi)"){
            UIApplication.shared.open(phoneURL as URL)
        }
        
//        guard let numberString = sender.titleLabel?.text, let url = URL(string: "telprompt://\(numberString)") else {
//            return
//        }
//        UIApplication.shared.open(url)
    }
    
//    chat lewat api wa
    @IBAction func btnChatDonasi(_ sender: UIButton) {
//        chat lewat WA
    }
    
//    lokasi organisasi
    var alamat = ""
    var kordinat = [Double]()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.source as! LokasiOrganisasi
        self.alamat = alamatOrganisasi.text!
        alamatOrganisasi.text = vc.alamatLengkap
        self.kordinat = vc.kordinatAsli
    }
    
//    buka link organisasi
    var addressWebsite = ""
    @IBAction func linkOrganisasi(_ sender: UIButton) {
        if let url = URL(string: "\(addressWebsite)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
//    penjelasan singkat tentnag organisasi
    var deskripsiOrganisasi = ""
    @IBOutlet weak var tentangOrganisasi: UILabel!
    
//    program dan juga request organisasi
    @IBOutlet weak var namaProgram1: UILabel!
    @IBOutlet weak var deskripsiProgram1: UILabel!
    
    @IBOutlet weak var namaProgram2: UILabel!
    
    @IBOutlet weak var deskripsiProgram2: UILabel!
    
    @IBOutlet weak var namaProgram3: UILabel!
    @IBOutlet weak var deskripsiProgram3: UILabel!
    
    var namaProgramOrganisasi = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.deskripsiOrganisasi = self.tentangOrganisasi.text!
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section != 3{
            return 1
        }else{
          return 3
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


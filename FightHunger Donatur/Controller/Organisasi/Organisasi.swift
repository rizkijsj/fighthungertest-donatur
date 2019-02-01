//
//  Organisasi.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation

class Organisasi: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
//        let date = Date()
//        let msg = " "
//        let urlWhats = "whatsapp://send?text=\(msg)"
//
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
//            if let whatsappURL = NSURL(string: urlString) {
//                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
//                    UIApplication.shared.openURL(whatsappURL as URL)
//                } else {
//                    print("please install watsapp")
//                }
//            }
//        }
        
        
        
        
        
//        ini refrensi
//        let url  = NSURL(string: "whatsapp://send?text=Hello%20Friends%2C%20Sharing%20some%20data%20here...%20!")
//
//        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
//
//        if UIApplication.shared.canOpenURL(url! as URL) {
//            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
//                if success {
//                    print("WhatsApp accessed successfully")
//                } else {
//                    print("Error accessing WhatsApp")
//                }
//            }
//        }
        
        
    }
    
//    lokasi organisasi
    var alamat = ""
    var kordinat = [Double]()
    @IBAction func btnMap(_ sender: UIButton) {
        let latitude: CLLocationDegrees = kordinat[0]
        let longitude: CLLocationDegrees = kordinat[1]
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//        ]
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "Place Name"
//        mapItem.openInMaps(launchOptions: options)
    }
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.source as! LokasiOrganisasi
//        self.alamat = alamatOrganisasi.text!
//        alamatOrganisasi.text = vc.alamatLengkap
//        self.kordinat = vc.kordinatAsli
//    }
    
    
    
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
        self.nomortelponOrganisasi = ""
        
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


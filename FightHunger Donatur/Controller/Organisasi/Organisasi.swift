//
//  Organisasi.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 31/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MapKit

class Organisasi: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var logoOrganisasi: UIImageView!
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var alamatOrganisasi: UILabel!
    @IBOutlet weak var callOrganisasi: UIButton!
    @IBOutlet weak var chatOrganisasi: UIButton!
    @IBOutlet weak var lokasiOrganisasi: UIButton!
    @IBOutlet weak var linkOrganisasi: UIButton!
    @IBOutlet weak var keteranganOrganisasi: UILabel!
    
    
    var organisasiObject : organizationObject?
    var organisasiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        self.deskripsiOrganisasi = self.tentangOrganisasi.text!
//        self.nomortelponOrganisasi = ""
        
//        reloadObject()
    }
    
//    func reloadObject(){
//        organisasiObject = connector().organizationDetail(organizationID: organisasiID!)
//        upDetails()
//    }
//
//    func updateDonationDetails(){
//
//        if let statusObject = passingObject{
//            let organizationObject = connector().organizationDetail(organizationID: statusObject.organizationId)
//
//            transactionID = statusObject.id
//            statusInteractionUpdate(Status: statusObject.status)
//
//            loadImage(link: statusObject.image)
//            updateDonationStatus(donationStage: statusObject.status)
//
//            namaOrganisasi.text = organizationObject!.name
//            nomorTelponOrganisasi.text = organizationObject!.phone
//
//            namaKurir.text = statusObject.courierName
//            deskripsiKurir.text = statusObject.courierDescription
//
//            namaDonasi.text = statusObject.name
//            deskripsiDonasi.text = statusObject.description
//            jumlahDonasi.text = "\(statusObject.quantity) Item"
//
//            let dateFormat = DateFormatter()
//            let timeFormat = DateFormatter()
//            dateFormat.locale = Locale.init(identifier: "Id")
//            timeFormat.locale = Locale.init(identifier: "Id")
//            dateFormat.dateFormat = "MMMM dd yyyy"
//            timeFormat.dateFormat = "HH:mm"
//
//            waktuPengambilan.text = "\(dateFormat.string(from: statusObject.pickUpTime)),\(timeFormat.string(from:statusObject.pickUpTime)),\(timeFormat.string(from: statusObject.arrivalTime!))"
//
//            viewDidLayoutSubviews()
//
//        }else{
//            print("Failed to load details")
//        }
//    }
//
//    func statusInteractionUpdate(Status:Int){
//
//        switch Status {
//        case 1:
//            btnBatal.isEnabled = true
//            batalkanDonasi()
//            print("Menunggu konfirmasi")
//        case 2:
//            btnBatal.isEnabled = true
//            batalkanDonasi()
//            btnCallOrganisasi.isEnabled = true
//            callOrganisasi()
//            print("organisasi mencari Kurir")
//        case 3:
//            btnKonfirmasi.isEnabled = true
//            btnCallOrganisasi.isEnabled = true
//            callOrganisasi()
//            if btnKonfirmasi.isTouchInside {
//                //                push notif ke organisasi
//            }
//            print("sedang di jemput")
//        case 4:
//            btnCallOrganisasi.isEnabled = true
//            callOrganisasi()
//            print("sedang di antar")
//        default:
//            print("hmmmm")
//            btnKonfirmasi.isEnabled = false
//            btnCallOrganisasi.isEnabled = false
//            btnBatal.isEnabled = false
//        }
//    }
//
//    func batalkanDonasi(){
//        //        push donasi
//    }
//
//    func callOrganisasi(){
//        if btnCallOrganisasi.isTouchInside {
//            nomorTelponOrganisasi.resignFirstResponder()
//
//            if let phoneURL = NSURL(string: "tel://\(nomorTelponOrganisasi.text!)"){
//                UIApplication.shared.open(phoneURL as URL)
//            }
//        }
//    }
//
//    func loadImage(link:String){
//        DispatchQueue.global(qos: .userInitiated).async {
//            let imageFile = UIImage.init(url: URL.init(string: link))
//
//            DispatchQueue.main.async {
//                self.fotoDonasi.image = imageFile!
//            }
//
//        }
//    }
//
//    func updateDonationStatus(donationStage:Int){
//
//        if donationStage == 0 {
//            print("baru push dari donatur")
//        }else if donationStage == 1 {
//            print("Menunggu untuk di claim")
//            btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
//        }else if donationStage == 2 {
//            print("Menunggu Menunggu Data Kurir")
//            stasus1.image = UIImage.init(named: "pin1a")
//            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
//            btnBatal.setImage(UIImage(named: "Batalkan"), for: .normal)
//        }else if donationStage == 3 {
//            print("Mengirim Kurir")
//            stasus1.image = UIImage.init(named: "pin1a")
//            status2.image = UIImage.init(named: "pin2a")
//            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
//            btnKonfirmasi.setImage(UIImage(named: "konfirmasi aktif"), for: .normal)
//        } else if donationStage == 4 {
//            print("Sedang diantar")
//            stasus1.image = UIImage.init(named: "pin1a")
//            status2.image = UIImage.init(named: "pin2a")
//            status3.image = UIImage.init(named: "pin2a")
//            btnCallOrganisasi.setImage(UIImage(named: "Logo call"), for: .normal)
//        } else if donationStage == 5 {
//            print("Sudah sampai organisasi")
//            stasus1.image = UIImage.init(named: "pin1a")
//            status2.image = UIImage.init(named: "pin2a")
//            status3.image = UIImage.init(named: "pin3a")
//            status4.image = UIImage.init(named: "pin4a")
//
//        }
//
//    }
    
}


    
    
    
    
//    telpon organisasi
//    var nomortelponOrganisasi = ""
//
//    @IBAction func btnCallOrganisasi(_ sender: UIButton) {
//
////        nomortelponOrganisasi.resignFirstResponder()
//
//        if let phoneURL = NSURL(string: "tel://\(nomortelponOrganisasi)"){
//            UIApplication.shared.open(phoneURL as URL)
//        }
//
////        guard let numberString = sender.titleLabel?.text, let url = URL(string: "telprompt://\(numberString)") else {
////            return
////        }
////        UIApplication.shared.open(url)
//    }
//
////    chat lewat api wa
//
//    @IBAction func btnChatDonasi(_ sender: UIButton) {
////        chat lewat WA
////        let date = Date()
////        let msg = " "
////        let urlWhats = "whatsapp://send?text=\(msg)"
////
////        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
////            if let whatsappURL = NSURL(string: urlString) {
////                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
////                    UIApplication.shared.openURL(whatsappURL as URL)
////                } else {
////                    print("please install watsapp")
////                }
////            }
////        }
//
//
//
//
//
////        ini refrensi
////        let url  = NSURL(string: "whatsapp://send?text=Hello%20Friends%2C%20Sharing%20some%20data%20here...%20!")
////
////        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
////
////        if UIApplication.shared.canOpenURL(url! as URL) {
////            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
////                if success {
////                    print("WhatsApp accessed successfully")
////                } else {
////                    print("Error accessing WhatsApp")
////                }
////            }
////        }
//
//
//    }
//
////    lokasi organisasi
//    var alamat = ""
//    var kordinat = [Double]()
//    @IBAction func btnMap(_ sender: UIButton) {
//        let latitude: CLLocationDegrees = kordinat[0]
//        let longitude: CLLocationDegrees = kordinat[1]
//
////        let regionDistance:CLLocationDistance = 10000
////        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
////        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
////        let options = [
////            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
////            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
////        ]
////        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
////        let mapItem = MKMapItem(placemark: placemark)
////        mapItem.name = "Place Name"
////        mapItem.openInMaps(launchOptions: options)
//    }
//
//
//
//    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let vc = segue.source as! LokasiOrganisasi
////        self.alamat = alamatOrganisasi.text!
////        alamatOrganisasi.text = vc.alamatLengkap
////        self.kordinat = vc.kordinatAsli
////    }
//
//
//
////    buka link organisasi
//    var addressWebsite = ""
//    @IBAction func linkOrganisasi(_ sender: UIButton) {
//        if let url = URL(string: "\(addressWebsite)") {
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
//
////    penjelasan singkat tentnag organisasi
//    var deskripsiOrganisasi = ""
//    @IBOutlet weak var tentangOrganisasi: UILabel!
//
////    program dan juga request organisasi
//    @IBOutlet weak var namaProgram1: UILabel!
//    @IBOutlet weak var deskripsiProgram1: UILabel!
//
//    @IBOutlet weak var namaProgram2: UILabel!
//
//    @IBOutlet weak var deskripsiProgram2: UILabel!
//
//    @IBOutlet weak var namaProgram3: UILabel!
//    @IBOutlet weak var deskripsiProgram3: UILabel!
//
//    var namaProgramOrganisasi = ""
//
//
//
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 4
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//
//        if section != 3{
//            return 1
//        }else{
//          return 3
//        }
//    }
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//}
//

//
//  DonasiPush.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 28/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class DonasiPush: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

   
    @IBOutlet weak var waktuAmbilTxt: UITextField!
    @IBOutlet weak var keteranganLokasiTxt: UITextField!
    @IBOutlet weak var lokasiTxt: UITextField!
    @IBOutlet weak var kuantitasTxt: UITextField!
    @IBOutlet weak var deskripsiTxt: UITextField!
    @IBOutlet weak var namaDonasiTxt: UITextField!
  
    @IBOutlet weak var fotoDonasi: UIImageView!
    
//    buat passing data ke map
    @IBOutlet weak var alamat: UITextField!
    var dataAlamat = "Lokasi"
    var kordinatPeta = [Double]()
    @IBAction func unwindToPushDonasi(_ sender: UIStoryboardSegue){
        let vc = sender.source as! LokasiPengambilan
        alamat.text = vc.alamatLengkap
        print(vc.alamatLengkap)
        print(vc.kordinatAsli)
    }
   
    
    
    @IBAction func keMap(_ sender: UIButton) {
        performSegue(withIdentifier: "keMap", sender: self)
    }
    
   

	
	
	@IBAction func btnGallery(_ sender: Any) {
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		
		
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController,animated: true,completion: nil)
		
		
	}
			
	
	
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		
		
		let passingImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		
		fotoDonasi.image = passingImage
		
		picker.dismiss(animated: true, completion: nil)
		
		
	}
    

    @IBAction func btnKamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
            
        } else
            
            //using camera in MAC IS NOT AVAILABLE
        {
            print("Camera not available")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        alamat.text = dataAlamat
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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

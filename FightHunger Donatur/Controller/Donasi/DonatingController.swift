//
//  DonatingController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class DonatingController: UITableViewController,UITextFieldDelegate{

    //    buat passing data ke map
    @IBOutlet weak var alamat: UILabel!
    @IBOutlet weak var namaBarang: CustomTextField!
    @IBOutlet weak var deskripsiBarang: CustomTextField!
    @IBOutlet weak var kuantitasBarang: CustomTextField!
    @IBOutlet weak var keteranganTambahanLokasi: CustomTextField!
    @IBOutlet weak var waktuPengambilan: UINavigationItem!
    
    @IBOutlet weak var imgDonasi: UIImageView!
    
    var tempTampungKirim = [String]()
    var dataAlamat = "Lokasi"
    var kordinatPeta = [Double]()
    
    var takenPhoto:UIImage?
    var imagePicker:UIImagePickerController!
    
    @IBAction func unwindToPushDonasi(_ sender: UIStoryboardSegue){
        let vc = sender.source as! LokasiPengambilan
        alamat.text = vc.alamatLengkap
        print(vc.alamatLengkap)
        print(vc.kordinatAsli)
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        connector().verifyUserLoginState { (state) in
            if state{
                self.performSegue(withIdentifier: "DonasiToHome", sender: nil)
            }else{
                sendDataToNextVC()
                self.performSegue(withIdentifier: "DonasiToLogin", sender: nil)
            }
        }
        //validasi untuk ke halaman selanjutnya
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! LoginViewController
        info.tempTampungTerima = tempTampungKirim
        tempTampungKirim = []
    }
    
    func sendDataToNextVC(){
//        tempTampungKirim.append(emailTxtField.text!)
//        tempTampungKirim.append(namaTxtField.text!)
//        tempTampungKirim.append(telpTxtField.text!)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //guard let userProfile = UserService.currentUserProfile else { return }
        if let availableImage = takenPhoto {
            imgDonasi.image = availableImage
            //bgPhoto.image = nil
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
//        print(userProfile.username)
//        print(userProfile.email)
//        print(userProfile.phonenumber)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imgDonasi.isUserInteractionEnabled = true
        imgDonasi.addGestureRecognizer(imageTap)
        //        foto_Donasi.layer.cornerRadius = logoKomunitas.bounds.height / 2
        //imgDonasi.clipsToBounds = true
        //tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
       tableView.delegate = self
       tableView.dataSource = self
    }

    @IBAction func btnLibraryFoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController,animated: true,completion: nil)
        
    }
    @IBAction func btnKamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
            
        } else
            
            //using camera in MAC IS NOT AVAILABLE
        {
            print("Camera not available")
        }
    }
    
    
    

    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		if section == 0{
			return 1
		}else {
			return 6
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

    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
//    @objc func handlePosting() {
//
//        guard let namaBarang = namaDonasi.text else { return }
//        guard let namaLokasi = namaLokasi.text else { return }
//        guard let pickUpTime = pickupTime.text else { return }
//        guard let fotobarang = fotoDonasi.image else { return }
//        guard let deskripsi = deskripsiDonasi.text else { return }
//
//        guard let userProfile = UserService.currentUserProfile else { return }
//
//        let uid = userProfile.uid
//        // 1. Upload the profile image to Firebase Storage
//
//        self.uploadPostImage(fotobarang) { url in
//
//            if url != nil {
//                print("url ga kosong")
//                guard let userProfile = UserService.currentUserProfile else { return }
//                let postRef = Database.database().reference().child("Post/\(uid)").childByAutoId()
//                let postObject = [
//                    "author": [
//                        "uid": userProfile.uid,
//                        "email": userProfile.email,
//                        "phonenumber":userProfile.phonenumber,
//                        "photoURL": userProfile.photoURL.absoluteString,
//                        "username": userProfile.username
//                    ],"namabarang": namaBarang,"namalokasi": namaLokasi,"pickupTime":pickUpTime,"deskripsiBarang":deskripsi,"postphotourl": url?.absoluteString,"timestamp": [".sv":"timestamp"],"status": "active"
//                    ] as [String:Any]
//
//                postRef.setValue(postObject, withCompletionBlock: { error, ref in
//                    if error == nil {
//                        print("sukses")
//                        let alert = UIAlertController(title: "Sukses Post Item", message:"Mohon menunggu komunitas menerima post donasi anda", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
//
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                    } else {
//                        // Handle the error
//                        print("error")
//                        //  self.resetForm()
//                    }})
//            } else {
//                //                self.resetForm()
//                print("Error unable to upload profile image URL is nil")
//            }
//        }
//    }
//
//
//    func uploadPostImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
//        let uid = ref.child("Post/FOI").childByAutoId().key
//        let storageRef = Storage.storage().reference().child("Post/FOI/\(uid)")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75)else { return }
//
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//
//        storageRef.putData(imageData, metadata: metaData) { metaData, error in
//            if error == nil, metaData != nil {
//
//                storageRef.downloadURL { url, error in
//                    completion(url)
//                }
//            } else {
//                print(error)
//                print(metaData)
//                // failed
//                print("failed")
//                completion(nil)
//            }
//        }
//    }
    
    override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        
    }
}

extension DonatingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.imgDonasi.image = selectedImage
        //self.bgPhoto.image = nil
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // punya juli
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//
//        let passingImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//
//        imgDonasi.image = passingImage
//
//        picker.dismiss(animated: true, completion: nil)
//
//
//    }
    
    
}

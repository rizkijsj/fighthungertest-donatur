//
//  DonatingController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class DonatingController: UITableViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var namaTxt: CustomTextField!
    @IBOutlet weak var deskripsiTxt: CustomTextField!
    
    @IBOutlet weak var keteranganTxt: CustomTextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        namaTxt.resignFirstResponder()
        deskripsiTxt.resignFirstResponder()
        keteranganTxt.resignFirstResponder()
       
        return true
    }
    
    
    //show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveKeyboard(textField: deskripsiTxt, moveDistance: -250, up: true)
    }
    @IBAction func toMap(_ sender: Any) {
        performSegue(withIdentifier: "DonasiToMap", sender: nil)
    }
    
    //hide keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        moveKeyboard(textField: deskripsiTxt, moveDistance: -250, up: false)
    }
    
    
    func moveKeyboard(textField : CustomTextField , moveDistance: Float, up:Bool)
    {
        let MoveDuration = 0.3
        let movement = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("moveTextfield", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(MoveDuration)
        // self.contentView.frame = CGRectOffse
        UIView.commitAnimations()
    }
    
    
    //    buat passing data ke map
   
    
    @IBOutlet weak var imgDonasi: UIImageView!
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    @IBOutlet weak var gbrTemplate: UIButton!
    
    var dataPostTampungDonasiVC = [String:Any]()
    let defaults = UserDefaults.standard

    var dataAlamat = "Lokasi"
    var kordinatPeta = [Double]()
    
    var activityView:UIActivityIndicatorView!
    
    var takenPhoto:UIImage?
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var alamat: CustomTextField!
    @IBAction func unwindToPushDonasi(_ sender: UIStoryboardSegue){
        let vc = sender.source as! LokasiPengambilan
        alamat.text = vc.alamatLengkap
        print(vc.alamatLengkap)
        print(vc.kordinatAsli)
    }
    
    
    
    @IBAction func submitBtn(_ sender: Any) {
        setContinueButton(enabled: false)
        connector().verifyUserLoginState { (state) in
            if state{
                self.handlePosting()
            }else{
				
                self.sendDataToNextVC()
                self.performSegue(withIdentifier: "DonasiToLogin", sender: nil)
                
               
            }
        }
        
    }
    
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
      self.dismiss(animated: true, completion: nil)
        print("hei")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //guard let userProfile = UserService.currentUserProfile else { return }
        if let availableImage = takenPhoto {
            imgDonasi.image = availableImage
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //disable login button dan bikin activity progress yg muter-muter
        setContinueButton(enabled: false)
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = view.center
        view.addSubview(activityView)
//        print(userProfile.username)
//        print(userProfile.email)
//        print(userProfile.phonenumber)
        
        //delegate textfield
        namaBarang.delegate = self as? UITextFieldDelegate
        //alamat.delegate = self as? UILabel
        deskripsiBarang.delegate = self as? UITextFieldDelegate
        kuantitasBarang.delegate = self as? UITextFieldDelegate
        keteranganTambahanLokasi.delegate = self as? UITextFieldDelegate
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        namaBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        deskripsiBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        kuantitasBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        keteranganTambahanLokasi.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imgDonasi.isUserInteractionEnabled = true
        imgDonasi.addGestureRecognizer(imageTap)
        
        
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        submitButton.isEnabled = false
        namaTxt.delegate = self
        deskripsiTxt.delegate = self
        keteranganTxt.delegate = self
        alamat.delegate = self
        
        
         namaTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        deskripsiTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        keteranganTxt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func textFieldChanged(_ target:UITextField)
    {
        let nama = namaTxt.text
        let deskripsi = deskripsiTxt.text
        let keteranganLokasi = keteranganTxt.text
        let textFieldLength = deskripsiTxt.text!.characters.count
        
        let formFilled = nama != nil && nama != "" && deskripsi != nil && deskripsi != "" && keteranganLokasi != "" && keteranganLokasi != nil
        
        if formFilled
        {
           
            submitButton.isEnabled = true

        }else if nama == nil || nama == ""
        {
            submitButton.isEnabled = false
            
        }else if deskripsi == nil || deskripsi == "" 
        {
            submitButton.isEnabled = false
        }else if textFieldLength > 120
        {
            submitButton.isEnabled = false
        }
        else if keteranganLokasi == nil || keteranganLokasi == ""
        {
            submitButton.isEnabled = false
        }
        
        
        continueButton.isEnabled = false
        deskripsiBarang.delegate = self
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPostData()
    }
    
    func loadPostData(){
        
        guard let tempPostData = defaults.object(forKey: "tempPostData") as? [String] else{return}
        if  tempPostData != nil{
            print(tempPostData)
            let imgTemp = loadImageFromDiskWith(fileName: "tempPostImage")
            print(imgTemp)
            if imgTemp != nil {
                print("sonto")
            
                gbrTemplate.isHidden = true
                namaBarang.text = tempPostData[0]
                keteranganTambahanLokasi.text = tempPostData[1]
                deskripsiBarang.text = tempPostData[2]
                imgDonasi.image = imgTemp
                                }
            }else{
                print("Foto tidak ditemukan")
            }
        
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
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		if section == 0 || section == 1{
			return 1
        } 
        else {
			return 6
		}

    }

    
    
    @objc func handlePosting() {

        guard let namaBarang = namaBarang.text else { return }
        guard let namaLokasi = alamat.text else { return }
        //guard let pickUpTime = waktuPengambilan.text else { return }
        guard let fotobarang = imgDonasi.image else { return }
        guard let deskripsi = deskripsiBarang.text else { return }


        
        connector().postDonate(namaBarang: namaBarang, lokasiBarang: namaLokasi, fotodonasi: fotobarang, deskripsiBarang: deskripsi) { (result) in
            if result{
                self.performSegue(withIdentifier: "DonasiToHome", sender: nil)
            }else{
                self.resetForm()
            }
        }
    }



    
    
    @objc func textFieldChanged(_ target:UITextField) {
        let nama = namaBarang.text
        let deskripsi = deskripsiBarang.text
        let jumlah = kuantitasBarang.text
        let keteranganTambahan = keteranganTambahanLokasi.text
        
        
        //syaratnya
        let formFilled = nama != nil && nama != "" && deskripsi != nil && deskripsi != "" && jumlah != nil && jumlah != "" && keteranganTambahan != nil && keteranganTambahan != ""
        
        //testing
        //print(phonenumber.count)
        print(formFilled)
        if formFilled
        {
            setContinueButton(enabled: true)
            
        }
        
        
    }
    

    
    func sendDataToNextVC(){
        guard let namaBarang = namaBarang.text else { return }
        guard let namaLokasi = alamat.text else { return }
        //guard let pickUpTime = waktuPengambilan.text else { return }
        
        guard let deskripsi = deskripsiBarang.text else { return }
        
        guard let fotobarang = imgDonasi.image else { return }
        
        let tempPostData = [namaBarang,namaLokasi,deskripsi]
        
        defaults.set(tempPostData, forKey: "tempPostData")
        defaults.set(true, forKey: "ngepostDonasi")
        saveImageLocally(imageName: "tempPostImage", image: fotobarang)
        
        
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        namaBarang.resignFirstResponder()
        deskripsiBarang.resignFirstResponder()
        keteranganTambahanLokasi.resignFirstResponder()
        return true
    }
    
    
    //show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveKeyboard(textField: deskripsiBarang, moveDistance: -250, up: true)
    }
    
    //hide keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        moveKeyboard(textField: deskripsiBarang, moveDistance: -250, up: false)
    }
    
    
    func moveKeyboard(textField : CustomTextField , moveDistance: Float, up:Bool)
    {
        let MoveDuration = 0.3
        let movement = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("moveTextfield", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(MoveDuration)
        // self.contentView.frame = CGRectOffse
        UIView.commitAnimations()
    }
    
    
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.tintColor = .black
            continueButton.isEnabled = true
        } else {
            continueButton.tintColor = .black
            continueButton.isEnabled = false
        }
    }
    
    func resetForm() {
        
        //setContinueButton(enabled: true)
        activityView.stopAnimating()
        setContinueButton(enabled: true)
    }
    
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
 
//         The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
 
        gbrTemplate.isHidden = true
        // Set photoImageView to display the selected image.
        self.imgDonasi.image = selectedImage
 
         //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
 
    func saveImageLocally(imageName: String, image: UIImage) {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//        gbrTemplate.isHidden = true
//        let passingImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//
//        imgDonasi.image = passingImage
//
//        picker.dismiss(animated: true, completion: nil)
//
//
//    }

}
    


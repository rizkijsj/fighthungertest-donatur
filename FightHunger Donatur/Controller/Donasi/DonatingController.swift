//
//  DonatingController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 30/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import Firebase

class DonatingController: UITableViewController , UITextFieldDelegate{
    @IBOutlet weak var namaBarang: CustomTextField!
    @IBOutlet weak var deskripsiBarang: CustomTextField!
    
	@IBOutlet weak var kuantitasBarang: CustomTextField!
	@IBOutlet weak var keteranganBarang: CustomTextField!
    @IBOutlet weak var waktuPengambilan: CustomTextField!
	
    @IBOutlet weak var alamatStack: UIStackView!
    
	
    
    var latitude = ""
    var longitude = ""
	let picker = UIDatePicker()
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        namaBarang.resignFirstResponder()
        deskripsiBarang.resignFirstResponder()
        keteranganBarang.resignFirstResponder()
        
        if namaBarang.isFirstResponder
        {
            deskripsiBarang.becomeFirstResponder()
        }else if deskripsiBarang.isFirstResponder
        {
            keteranganBarang.becomeFirstResponder()
        }else
        {
            keteranganBarang.resignFirstResponder()
        }
        
        
       
        return true
    }
	
	func AddUITapGestureToImageView(){
		
		let tapImageVIew = UITapGestureRecognizer(target: self, action: #selector(onClick))
		self.imgDonasi.addGestureRecognizer(tapImageVIew)
		
		
		imgDonasi.isUserInteractionEnabled = true
	}
	
	@objc func onClick(){
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { _ in
			self.btnKamera(self)
		}))
		
		alert.addAction(UIAlertAction(title: "Library Foto", style: .default, handler: { _ in
			self.btnLibraryFoto(self)
		}))
		
		alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
    
    
    
    @IBOutlet weak var viewAlamat: UIView!
    func alamatView(){
        let warna = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = warna.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: alamatStack.bounds.size.height - width, width: alamatStack.bounds.size.width, height: alamatStack.bounds.size.height)
        alamatStack.layer.addSublayer(border)
        alamatStack.layer.masksToBounds = true
    }
    
    
    
    //show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveKeyboard(textField: deskripsiBarang, moveDistance: -250, up: true)
    }
    @IBAction func toMap(_ sender: Any) {
        performSegue(withIdentifier: "DonasiToMap", sender: nil)
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
	
	func createPicker()
	{
		
		picker.locale = Locale.init(identifier: "Id")
		picker.datePickerMode = .time
		
		var toolbar = UIToolbar()
		toolbar.sizeToFit()
		
		//add done button
		var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
		
		var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([flexibleSpace,doneBtn], animated: false)
		
		waktuPengambilan.inputAccessoryView = toolbar
		
		waktuPengambilan.inputView = picker
	}
	
	@objc func doneClicked(){
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = .none
		dateFormat.timeStyle = .short
		dateFormat.locale = Locale.init(identifier: "Id")
		
		waktuPengambilan.text = "\(dateFormat.string(from: picker.date))"
		waktuPengambilan.endEditing(true)
        textFieldChanged(waktuPengambilan)
	}
    
    
    //    buat passing data ke map
	
	
    
    @IBOutlet weak var imgDonasi: UIImageView!
    @IBOutlet weak var continueButton: UIBarButtonItem!
	
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
		latitude = "\(vc.kordinatAsli[0])"
		longitude = "\(vc.kordinatAsli[1])"
		
    }
	
	@IBAction func unwindFromOTPSuccess(_ sender:UIStoryboardSegue){
		let vc = sender.source as! OTPViewController
		
		if vc.successLogin {
			connector().verifyUserLoginState { (state) in
				if state{
					self.handlePosting()
				}else{
					
					self.sendDataToNextVC()
					self.performSegue(withIdentifier: "DonasiToLogin", sender: nil)
					
					
				}
			}
		}
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
    /*
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0{
			if imgDonasi.frame.height > 180 {
				return 240
			}else {
				return 320
			}
		}else{
			return 60
		}
	}
	*/
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	@IBAction func cancelBtn(_ sender: Any) {
        
      self.dismiss(animated: true, completion: nil)
        print("hei")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		  self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)]
		
		createPicker()
        alamatView()
        
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
        keteranganBarang.delegate = self as? UITextFieldDelegate
        alamat.delegate = self as? UITextFieldDelegate
        waktuPengambilan.delegate = self as? UITextFieldDelegate
        
        //setiap ada perubahan di textfield , dia bakal manggil fungsi textfieldchanged
        namaBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        deskripsiBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        kuantitasBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEndOnExit)
        keteranganBarang.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//        alamat.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        waktuPengambilan.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEndOnExit)
        /*
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imgDonasi.isUserInteractionEnabled = true
        imgDonasi.addGestureRecognizer(imageTap)
        */
		
		AddUITapGestureToImageView()
        
        imagePicker = UIImagePickerController()
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        continueButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadPostData()
      
    }
    
    @objc func textFieldChanged(_ target:UITextField)
    {
        print("kepanggil")
        let nama = namaBarang.text
        let deskripsi = deskripsiBarang.text
        let keteranganLokasi = keteranganBarang.text
        let textFieldLength = deskripsiBarang.text!.characters.count
        let alamatBarang = alamat.text
        let fotobarang = imgDonasi.image
        let waktuAmbil = waktuPengambilan.text
        
        let formFilled = nama != nil && nama != "" && deskripsi != nil && deskripsi != "" && textFieldLength >= 1 && textFieldLength <= 120 && alamatBarang != "" && alamatBarang != nil && waktuAmbil != "" && waktuAmbil != nil && fotobarang != nil
        
        print(formFilled)
        
        if formFilled
        {
            print("gas pak aji")
            setContinueButton(enabled: true)

        }else
        {
            setContinueButton(enabled: false)
        }
      
    }
    

    func loadPostData(){
        
        let tempPostData = defaults.object(forKey: "tempPostData") as? [String]
        if  tempPostData != nil{
            print(tempPostData)
            let imgTemp = loadImageFromDiskWith(fileName: "tempPostImage")
            if imgTemp != nil {
                print("sonto")
            
                //gbrTemplate.isHidden = true
                namaBarang.text = tempPostData?[0]
                alamat.text = tempPostData?[1]
                deskripsiBarang.text = tempPostData?[2]
                imgDonasi.image = imgTemp
                keteranganBarang.text = tempPostData?[3]
                kuantitasBarang.text = tempPostData?[4]
				
				print(tempPostData?[5])
				if let dateText = tempPostData?[5]{
					let dateFormat = DateFormatter()
					dateFormat.dateStyle = .none
					dateFormat.timeStyle = .short
					dateFormat.locale = Locale.init(identifier: "Id")
					
					picker.date = Date(timeIntervalSince1970: Double(dateText)!)
					waktuPengambilan.text = "\(dateFormat.string(from: picker.date))"
				}
                latitude = tempPostData![6]
                longitude = tempPostData![7]
                defaults.removeObject(forKey: "tempPostData")
                defaults.synchronize()
				
				
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
    
    
    @objc func handlePosting() {

        guard let namaBarang = namaBarang.text else { return }
        guard let namaLokasi = alamat.text else { return }
        let pickUpTime = picker.date.timeIntervalSince1970
        guard let fotobarang = imgDonasi.image else { return }
        guard let deskripsi = deskripsiBarang.text else { return }
		
        //guard let keteranganTambahanLokasi = keteranganBarang.text else {return}
        guard let jumlahBarang = kuantitasBarang.text else {return}
        
        guard let latitudeBarang = latitude as? String else {return}
        guard let longitudeBarang = longitude as? String else {return}
        
        activityView.startAnimating()
        connector().postDonate(namaBarang: namaBarang, lokasiBarang: namaLokasi,keteranganLokasi: keteranganBarang.text ?? "-" ,fotodonasi: fotobarang, deskripsiBarang: deskripsi,kuantitasBarang: jumlahBarang,waktuAmbil : pickUpTime,latitude: latitudeBarang, longitude : longitudeBarang) { (result) in
            if result{
                //self.performSegue(withIdentifier: "DonasiToHome", sender: nil)
				self.dismiss(animated: true, completion: nil)
            }else{
                self.resetForm()
            }
        }
    }
    
    func sendDataToNextVC(){
        guard let namaBarang = namaBarang.text else { return }
        guard let namaLokasi = alamat.text else { return }
        guard let pickUpTime = waktuPengambilan.text else { return }
        
        guard let deskripsi = deskripsiBarang.text else { return }
        
        guard let fotobarang = imgDonasi.image else { return }
        guard let keteranganTambahanLokasi = keteranganBarang.text else {return}
        
        guard let jumlahBarang = kuantitasBarang.text else {return}
        let waktuAmbil = "\(picker.date.timeIntervalSince1970)"
        print(waktuAmbil)
        let tempLatitude = "\(kordinatPeta[0])"
        let tempLongitude = "\(kordinatPeta[1])"
        
        let tempPostData = [namaBarang,namaLokasi,deskripsi,keteranganTambahanLokasi,jumlahBarang,waktuAmbil,tempLatitude,tempLongitude]
        
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

	
	
    
    
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.tintColor = UIColor(displayP3Red: 193/255, green: 27/255, blue: 42/255, alpha: 1.0)
            continueButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
            continueButton.isEnabled = true
        } else {
            //continueButton.tintColor = .red
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
 
        //gbrTemplate.isHidden = true
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
    


//
//  Connector.swift
//  FightHunger-DonaturVersion
//
//  Created by Antonius George on 14/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

/*
Reminder untuk status di Transaction:
0 - Batal User
1 - Pending
2 - Menunggu Kurir di assign
3 - Pickup
4 - Di Kirim (dari Donatur ke Organisasi)
5 - Sampai Di tujuan
6 - Batal Organisasi
*/

// error code
//case 0:
//return "Success"
//case 1:
//return "Phone number is already registered"
//case 2:
//return "Phone number is not registered"
//default:
//return "Unknown error"

class connector {
	// MARK: - Login Signup
    func verifyLogin(phoneNo:String,
                     completion: @escaping (Bool,String) -> Void){
		
        verifyUserExistanceInDataBase(phoneno: phoneNo){ result in
            if result {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { (verificationID, error) in
                    if error != nil{
                        let errorText = String(describing: error?.localizedDescription)
                        
                        completion(false,errorText)
                        print("error: \(String(describing: error?.localizedDescription))")
                    }else{
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                        let errorText = self.errorCode(code: 0)
                        
                        completion(true,errorText)
                        print("sukses verify dong")
                    }
                }
            }else{
                print("error")
                let errorText = self.errorCode(code: 2)
                
                completion(false,errorText)
            }
            
        }
        
    }
    
    func verifyRegister(
        phoneNo:String,
        completion: @escaping (Bool,String) -> Void){
       
        verifyUserExistanceInDataBase(phoneno: phoneNo) { (result) in
            if result {
                print("error")
                let errorText = self.errorCode(code: 1)
                
                completion(false,errorText)
            }else{
                print("ini no nya ",phoneNo)
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { (verificationID, error) in
                    if error != nil {
                        let errorText = String(describing: error?.localizedDescription)
                        
                        completion(false,errorText)
                        print("error: \(String(describing: error?.localizedDescription))")
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                        print(verificationID)
                        let errorText = self.errorCode(code: 0)
                        
                        completion(true,errorText)
                        print("sukses verify dong")
                    }
                }
            }
        }
    }
    
    func verifyUserExistanceInDataBase(phoneno:String,completion: @escaping (Bool) -> Void){
        let ref = Database.database().reference()
        //var result = false
        ref.child("users/phonenumber/\(phoneno)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                print("phone number exist")
                completion(true)
            }else{
                print("phone number not exist")
                completion(false)
            }
        })
    }
    
    func logIn(kodeotp:PhoneAuthCredential,completion: @escaping (Bool) -> Void){
        
        Auth.auth().signIn(with: kodeotp) { (user, error) in
            if error != nil && user != nil{
                print("error: \(String(describing: error?.localizedDescription))")
                //result = false
                completion(false)
            }else{
                print("sukses sign in")
                completion(true)
            }
        }
        
    }
	
    func signUp(email:String, nama:String, phonenumber:String,kodeotp:PhoneAuthCredential, completion: @escaping (Bool) -> Void){
		// TODO:
//        let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/fight-hunger.appspot.com/o/profiledefault.jpg?alt=media&token=8234e660-a04d-4e54-abe3-e615c74ff91f")
        //var result = false
        
        logIn(kodeotp: kodeotp) { (result) in
            if result{
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let databaseRef = Database.database().reference().child("users/donatur/profile/\(uid)")
                let phoneNumberDatabaseRef = Database.database().reference().child("users/phonenumber/\(phonenumber)")
                let userObject = [
                    "username":nama,"email": email,"phonenumber": phonenumber
                    ] as [String:Any]
                let phoneNumberObject = [
                    phonenumber:uid
                    ] as [String:Any]
                
                databaseRef.setValue(userObject) { error, ref in
                    //completion(error == nil)
                }
                phoneNumberDatabaseRef.setValue(phoneNumberObject) { error, ref in
                    //completion(error == nil)
                }
                completion(true)
                print("sukses sign up")
            }else{
                print("gagal sign up")
            }
        }
        
//                Auth.auth().signIn(with: kodeotp) { (user, error) in
//                    if error != nil && user != nil{
//                        print("error: \(String(describing: error?.localizedDescription))")
//                        //result = false
//                        completion(false)
//                    }else{
//
//
//                }
    
        
        
        
	}
    
	
	// MARK: - Post Donation
    func postDonate(namaBarang: String,lokasiBarang : String,keteranganLokasi: String,fotodonasi: UIImage,deskripsiBarang : String,kuantitasBarang: String,waktuAmbil : Double,latitude: String,longitude: String,completion: @escaping (Bool) -> Void) {
        print("masuk post donate")
//        let namaBarang = nama
//        let namaLokasi = lokasi
        //guard let pickUpTime = waktuPengambilan.text else { return }
//        let fotobarang = fotodonasi
        //guard let deskripsi = deskripsiBarang.text
                let urlKomunitas = URL(string:"https://firebasestorage.googleapis.com/v0/b/fight-hunger.appspot.com/o/placeholder%20logo%20komunitas.png?alt=media&token=1ad83629-5d24-4f9b-83a8-444fbf47866b")
        guard let userProfile = UserService.currentUserProfile else { return }
        guard let foto = fotodonasi as? UIImage else {return}
		guard let photo = foto.jpeg(.low) else {return}
		guard let gambardonasi = UIImage.init(data: photo) else {return}
        let uid = userProfile.uid
		print("lewat sini")
		print(latitude)
		print(longitude)
		guard let lati = Double(latitude) else {print("Error Konversi latitude")
			return}
		guard let long = Double(longitude) else {print("Error konversi longtitude")
			return}
		print("Berhasil dan siap")
        
        self.uploadPostImage(gambardonasi,id: uid) { url in
            print(url)
            if url != nil {
                print("url ga kosong")
                guard let userProfile = UserService.currentUserProfile else { return }
                
//                var postRef = ref.childByAutoId()
//                post1Ref.setValue(post1)
//
//                var postId = post1Ref.key
                
                let postRef = Database.database().reference().child("Post/").childByAutoId()
                let postObject = [
                    "author": [
                        "uid": userProfile.uid,
                        "email": userProfile.email,
                        "phonenumber":userProfile.phonenumber,
                        "username": userProfile.username
                    ],"komunitas": [
                        "id": "0",
                        "logo": urlKomunitas?.absoluteString,
                        "name":"Searching",
                        "phone": "0"
                    ],"alamat": [
                        "keteranganlokasi":keteranganLokasi,
                       "namalokasi": lokasiBarang,
                       "latitude":lati,
                       "longitude":long
                    ],"transaksi": [
                        "alasanbatal":"kosong",
                        "deskripsikurir": "kosong",
                        "namakurir":"kosong",
                        "status": 1,
                        "waktuambil": waktuAmbil,
                        "waktusampai": 0
                    ],"barang": [
                        "namabarang": namaBarang,
                        "deskripsibarang":deskripsiBarang,
                        "jumlahbarang":kuantitasBarang,
                        "postphotourl": url?.absoluteString,
                    ],"idtransaction" : "0","timestamp": [".sv":"timestamp"]
                    ] as [String:Any]
                
                postRef.setValue(postObject, withCompletionBlock: { error, ref in
                    if error == nil {
                        print("sukses post donasi")
                        guard let postId = postRef.key else {return}
                        print(postId)

                        
                        let databaseRef = Database.database().reference().child("Post/\(postId)")
                        
                        let idObject = [
                            "idtransaction": postId] as [String:Any]
                        
                        databaseRef.updateChildValues(idObject) { error, ref in
                            if error == nil {
                                print("sukses masukin transaction id")
                                completion(true)
                            }else{
                                print("error post transaction id donasi")
                                completion(false)
                            }
                        }
                        
//                        postRef.setValue(idObject, withCompletionBlock: { ellol, ref in
//                            if ellol == nil{
//                                print("sukses masukin transaction id")
//                                completion(true)
//                            }else{
//                                print("error post transaction id donasi")
//                                completion(false)
//                            }
//
//                        })
                        
                    } else {
                        // Handle the error
                        print("error post donasi")
                        completion(false)
                        //  self.resetForm()
                    }})
            } else {
                //                self.resetForm()
                print("Error unable to upload profile image URL is nil")
                completion(false)
            }
        }
    }

    func verifyUserLoginState(completion: @escaping (Bool) -> Void) {
        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                completion(true)
            } else {
               completion(false)
            }
        }
    }
    
    func uploadPostImage(_ image:UIImage,id:String, completion: @escaping ((_ url:URL?)->())) {
            var ref: DatabaseReference!
    
            ref = Database.database().reference()
            let uid = ref.child("Post/\(id)").childByAutoId().key
            let storageRef = Storage.storage().reference().child("Post/\(id)/\(uid)")
    
            guard let imageData = image.jpegData(compressionQuality: 0.75)else { return }
    
    
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
    
            storageRef.putData(imageData, metadata: metaData) { metaData, error in
                if error == nil, metaData != nil {
    
                    storageRef.downloadURL { url, error in
                        completion(url)
                    }
                } else {
                    print(error)
                    print(metaData)
                    // failed
                    print("failed")
                    completion(nil)
                }
            }
        }
    
    func saveProfile(username:String,email:String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let databaseRef = Database.database().reference().child("users/donatur/profile/\(uid)")
        
        let userObject = [
            "username": username,"email": email] as [String:Any]
        
        databaseRef.updateChildValues(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
	func SMSSucess(verificationCode:String) -> Bool{
		// TODO:
		return true
	}
	func SMSFail(verificationCode:String) -> Bool{
		// TODO:
		return false
	}
    
    // interpreter error
    func errorCode(code:Int) -> String{
       
        switch code {
        case 0:
            return "Success"
        case 1:
            return "Phone number is already registered"
        case 2:
            return "Phone number is not registered"
        default:
           return "Unknown error"
        }
    }
	
	// MARK: - Update donation Status
	func donationUpdateDeliverySuccess(transactionID:String) -> Bool{
		return true
	}
	func donationUpdateDeliveryFail(transactionID:String) -> Bool{
		return false
	}
	func donationCancel(transactionID:String,Reason:String,data: Post,completion: @escaping (Bool) -> Void){
		//guard let uid = Auth.auth().currentUser?.uid else { return }
		
		// guard let idtransaksi = idtransaksi else {return}
		
		
		let idtransaksi = data.idtransaksi
		let userid = data.author.uid
		//        guard let alasanBatal = alasanBatalTextField.text else{return}
		
		let databaseTransaksiRef = Database.database().reference().child("Post/\(idtransaksi)/transaksi")
		let databaseDeadPost = Database.database().reference().child("DeadPost/\(userid)/").childByAutoId()
		let databasePostRef = Database.database().reference().child("Post/\(idtransaksi)")
		let transaksiObject = ["status": 0] as [String:Any]
		
		let postObject = [
			"author": [
				"uid": data.author.uid,
				"email": data.author.email,
				"phonenumber":data.author.phonenumber,
				"username": data.author.username
			],"komunitas": [
				"id": "-",
				"logo": "-",
				"name":"-",
				"phone": "-"
			],"alamat": [
				"keteranganlokasi":data.keteranganlokasi,
				"namalokasi": data.keteranganlokasi,
				"latitude":data.latitude,
				"longitude":data.longitude
			],"transaksi": [
				"alasanbatal":Reason,
				"deskripsikurir": "-",
				"namakurir":"-",
				"status": 6,
				"waktuambil": data.waktuambil,
				"waktusampai": 0
			],"barang": [
				"namabarang": data.namaitem,
				"deskripsibarang":data.deskripsi,
				"jumlahbarang":data.jumlahbarang,
				"postphotourl": data.postphotourl.absoluteString,
			],"idtransaction" : data.idtransaksi,"timestamp": data.timestamp
			] as [String:Any]
		
		databaseTransaksiRef.updateChildValues(transaksiObject) { error, ref in
			if error == nil{
				databaseDeadPost.setValue(postObject, withCompletionBlock: { error, ref in
					if error == nil {
						print("sukses post deadpost")
						guard let postId = databaseDeadPost.key else {return}
						print(postId)
						
						
						let databaseRef = Database.database().reference().child("DeadPost/\(userid)/\(postId)")
						
						let idObject = [
							"idtransaction": postId] as [String:Any]
						
						databaseRef.updateChildValues(idObject) { error, ref in
							if error == nil {
								print("sukses masukin transaction id")
								databasePostRef.setValue(nil){ error, ref in
									if error == nil {
										print("sukses hapus data")
										completion(true)
									}else{
										print("gagal hapus data")
										completion(false)
									}
								}
							}else{
								print("error post transaction id donasi")
								completion(false)
							}
						}
						
					} else {
						// Handle the error
						print("error post dead post")
						completion(false)
						//  self.resetForm()
					}})
				
			}else{
				
			}
		}
		
	}
	
    // MARK: - Program Detail
    func programDetail(programID:String) -> programObject {
        
        let item:programObject = programObject.init(proId: programID, orgID: "!", proName: "1", proLocName: "1", proLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 1)!, longitude: CLLocationDegrees.init(exactly: 1)!), proTime:
            "NOW", proDesc: "1 adalah anga yang indah. ini adalah sesuatu yang PERTAMA! lebih awal lagi dari semua angka, mungkin 0. TAPI 0 itu tidak NYATA! KITA HARUS BILANG 1! Satu! SATU! jangan pernah memilih yang 0. Pililah yang pasti hanya SATU! atau pilih yang bisa berdua. 2 itu ada;ah angka indah. 2 bisa membawa diri dan pasangan satu lagi. mungkin 3 kalo di hitung yang sebelah. Bersiaplah memilih yang akan sukses", proImageLink: "https://upload.wikimedia.org/wikipedia/commons/0/09/Ayam_Pelung.jpg")
        
        
        
        return item
    }
    
    // MARK: - Organizarion Detail
    func organizationDetail(organizationID:String) -> OrganisasiProfile {
        
		let item = OrganisasiProfile.init(orgId: organizationID, orgPhone: "+62 81808082838", orgEmail: "organisasi@organization.com", orgName: "PT Lawan Lapar Bersama Solusindo", orgDesc: "Melawan Kelaparan di dunia  dan menuntaskan kelaparan yang akan muncul", orgLogo: URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Bass_logo.svg/199px-Bass_logo.svg.png")!, orgLocName: "Jl. Moh. Husni Thamrin Kota Tangerang Selatan Banten", latitude: "-6.2753768", longitude: "106.7216066", orgLink: URL(string:"google.com")!)
		
		//UserProfile.init(uid: organizationID, email: "organisasi@organization.com", phonenumber: "+62 818081828238", username: "organisasi")
        
        
        
        return item
    }
    
    // MARK: - Donator Detail
    func donatorDetail(donatorID:String) -> UserProfile {
        
        //let item:donatorObject = donatorObject.init(donId: donatorID, donPhone: "#", donEmail: "3@4.com", donName: "3", donPro: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg")
		
		let item = UserProfile.init(uid: donatorID, email: "donatur@donator.com", phonenumber: "+62 81808082838", username: "donasi")
        
        
        return item
    }
    
    // MARK: - Transaction (donation) Detail
    func transactionDetail(transactionID:String) -> Post{
        
        let item = Post.init(id: transactionID, author: connector().donatorDetail(donatorID: "D1"), idkomunitas: "K1", logokomunitas: URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Bass_logo.svg/199px-Bass_logo.svg.png")!, namakomunitas: "PT Kerja Sama Yuk ID", phonekomunitas: "+62 81808082838", postphotourl: URL(string:"https://upload.wikimedia.org/wikipedia/commons/c/cf/Dadiah2.jpg")!, namaitem: "Yogurt", deskripsi: "Segera di ambil, karena ini cepat basi", jumlahbarang: "1", alamat: "Jl. Batu Sari RW.2, Batu Ampar, Kramatjati, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13520", keteranganlokasi: "Rumah warna Pink agak keputihan", latitude: -6.2747551, longitude: 106.8602302, waktuambil: 1549299450, waktusampai: 1549359450, namakurir: "Socrates", deskripsikurir: "Pakai toga kemana mana", timestamp: 1549259450, status: 1, alasanbatal: "Sudah Basi", idtransaction: "lol")
			
			
			
			//Post.init(id: "T01", author: connector().donatorDetail(donatorID: "D1")!, organisasi: connector().organizationDetail(organizationID: "T1")!, postphotourl: URL(String:"https://upload.wikimedia.org/wikipedia/commons/c/cf/Dadiah2.jpg", namaitem: "Yogurt", deskripsi: "Segera di santap karena cepat basi", jumlahbarang: "5", alamat: "l. Batu Sari RW.2, Batu Ampar, Kramatjati, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13520", keteranganlokasi: "Rumah warna Pink agak keputihan", latitude: "-6.2747551", longitude: "106.8602302", waktuambil: 1549299450, waktusampai: 1549359450, namakurir: "Socrates", deskripsikurir: "Pakai toga kemana mana", timestamp: 1549259450, status: "1", alasanbatal: "Sudah Basi")
        
        return item
    }

	
	// MARK: - Program List
	func programList() -> [programObject] {
		var items:[programObject] = []
		
        items.append(programDetail(programID: "P0"))
        items.append(programDetail(programID: "P1"))
        items.append(programDetail(programID: "P5"))
		
		return items
		
	}
    
    func getOrganizationProgramList(organizationID:String, limit:Int) -> [programObject] {
        
        var items:[programObject] = []
        
        items.append(programDetail(programID: "P0"))
        items.append(programDetail(programID: "P1"))
        items.append(programDetail(programID: "P5"))
        
        return items
        
    }
	
	
	// MARK: - Organization List
	func organizationList() -> [OrganisasiProfile] {
		var items:[OrganisasiProfile] = []
		
        items.append(organizationDetail(organizationID: "O1"))
        items.append(organizationDetail(organizationID: "O2"))
        items.append(organizationDetail(organizationID: "O3"))
		
		return items
		
	}
	
	// MARK: - Transaction List List
	func transactionList() -> [Post] {
		var items:[Post] = []
		
        items.append(transactionDetail(transactionID: "T1"))
        items.append(transactionDetail(transactionID: "T2"))
        items.append(transactionDetail(transactionID: "T700"))
        items.append(transactionDetail(transactionID: "T5005"))
        items.append(transactionDetail(transactionID: "T2"))
        items.append(transactionDetail(transactionID: "T909"))
        items.append(transactionDetail(transactionID: "T189"))
		
		items[0].status = 0
		items[1].status = 1
		items[2].status = 2
		items[3].status = 3
		items[4].status = 4
		items[5].status = 5
		items[6].status = 6
		
		return items
		
	}
	
	
	
}



// MARK: - Sample Classes
// TODO: Remove the sample classes into proper class
/*
class transactionObject{
    
    /*
     Reminder untuk status di Transaction:
     0 - Batal User
     1 - Pending
     2 - Menunggu Kurir di assign
     3 - Pickup
     4 - Di Kirim (dari Donatur ke Organisasi)
     5 - Sampai Di tujuan
     6 - Batal Organisasi
     */
    
    var id:String
    var donatorId:String
    var organizationId:String?
    var name:String
    var image:String
    var quantity:Int
    var locationName:String
    var locationCoor:CLLocationCoordinate2D
    var locationNote:String
    var pickUpTime:Date
    var arrivalTime:Date?
    var description:String
    var courierName:String?
    var courierDescription:String?
    var status:Int
    var reason:String?
    
    init(tranID:String,tranDonId:String,tranOrgId:String?,tranName:String,tranImage:String,tranLocName:String,tranLocCoor:CLLocationCoordinate2D,tranPickUpTime:Date,tranDesc:String, tranCourierName:String?, tranCourierDesc:String?, tranStatus:Int, tranReason:String?, tranQuantity:Int, tranLocNote:String, transArrivalTime:Date?) {
        
        id = tranID
        donatorId = tranDonId
        organizationId = tranOrgId
        name = tranName
        image = tranImage
        locationName = tranLocName
        locationCoor = tranLocCoor
        locationNote = tranLocNote
        pickUpTime = tranPickUpTime
        arrivalTime = transArrivalTime
        description = tranDesc
        
        courierName = tranCourierName
        courierDescription = tranCourierDesc
        
        status = tranStatus
        reason = tranReason
        quantity = tranQuantity
    }
    
    
}

class donatorObject{
    var id:String
    var phone:String
    var email:String
    var name:String
    var profile:String
    
    init(donId:String,donPhone:String,donEmail:String,donName:String,donPro:String) {
        
        id = donId
        phone = donPhone
        email = donEmail
        name = donName
        profile = donPro
        
        
    }
}

class organizationObject{
    var id:String
    var phone:String
    var email:String
    var name:String
    var description:String
    var logo:String
    var locationName:String
    var locationCoor:CLLocationCoordinate2D
	var link:String
    
    init(orgId:String,orgPhone:String,orgEmail:String,orgName:String,orgDesc:String,orgLogo:String,orgLocName:String,orgLocCoor:CLLocationCoordinate2D,orgLink:String) {
        
        id = orgId
        phone = orgPhone
        email = orgEmail
        name = orgName
        description = orgDesc
        logo = orgLogo
        locationName = orgLocName
        locationCoor = orgLocCoor
        link = orgLink
        
    }
}
*/
class programObject{
    var id:String
    var organizationID:String
    var name:String
    var locationName:String
    var locationCoor:CLLocationCoordinate2D
    var time:String
    var description:String
    var imagesLink: String
    
    init(proId:String,orgID:String,proName:String,proLocName:String,proLocCoor:CLLocationCoordinate2D,proTime:String,proDesc:String,proImageLink:String) {
        id = proId
        organizationID = proId
        name = proName
        locationName = proLocName
        locationCoor = proLocCoor
        time = proTime
        description = proDesc
        imagesLink = proImageLink
    }
    
}

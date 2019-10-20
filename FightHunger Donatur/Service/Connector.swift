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
                        print(verificationID ?? "Not exist")
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
        logIn(kodeotp: kodeotp) { (result) in
            if result{
				guard let uid = Auth.auth().currentUser?.uid else { completion(false); return }
                
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
				UserService.observeUserProfile(uid, completion: { (UserProfile, exist) in
					if exist {
						 print("sukses sign up")
						completion(true)
					}else {
						print("ggl sign up")
						completion(false)
						
					}
				})
				
				print("\n\n\nForce sukses sign up\n\n")
                completion(true)
				
            }else{
				completion(result)
                print("gagal sign up")
            }
        }
        
        
        
	}
    
	
	// MARK: - Post Donation
    func postDonate(namaBarang: String,lokasiBarang : String,keteranganLokasi: String,fotodonasi: UIImage,deskripsiBarang : String,kuantitasBarang: String,waktuAmbil : Double,latitude: String,longitude: String,organ:OrganisasiProfile,completion: @escaping (Bool) -> Void) {
        print("masuk post donate")
//        let namaBarang = nama
//        let namaLokasi = lokasi
        //guard let pickUpTime = waktuPengambilan.text else { return }
//        let fotobarang = fotodonasi
        //guard let deskripsi = deskripsiBarang.text
		guard let userProfile = UserService.currentUserProfile else { completion(false); return }
		let foto = fotodonasi
		guard let photo = foto.jpeg(.low) else {completion(false); return}
		guard let gambardonasi = UIImage.init(data: photo) else {completion(false); return}
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
			print(url ?? "")
            if url != nil {
                print("url ga kosong")
                guard let userProfile = UserService.currentUserProfile else {completion(false); return }
                
                var status = 1
                
                if organ.id != "-" {
                    status = 2
                }

                
                let postRef = Database.database().reference().child("PublicPost/").childByAutoId()
                

                let postObject = [
                    "author": [
                        "uid": userProfile.uid,
                        "email": userProfile.email,
                        "phonenumber":userProfile.phonenumber,
                        "username": userProfile.username
                    ],"komunitas": [
                        "id": organ.id,
                        "logo": organ.logo.absoluteString,
                        "name": organ.name,
                        "phone": organ.phone
                    ],"alamat": [
                        "keteranganlokasi":keteranganLokasi,
                       "namalokasi": lokasiBarang,
                       "latitude":lati,
                       "longitude":long
                    ],"transaksi": [
                        "alasanbatal":"kosong",
                        "deskripsikurir": "kosong",
                        "namakurir":"kosong",
                        "status": status,
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
                        guard let postId = postRef.key else {completion(false); return}
                        print(postId)

                        
                        let databaseRef = Database.database().reference().child("PublicPost/\(postId)")
                        
                        let idObject = [
                            "idtransaction": postId] as [String:Any]
                        
                        databaseRef.updateChildValues(idObject) { error, ref in
                            if error == nil {
                                print("sukses masukin transaction id")
                                let postUserRef = Database.database().reference().child("UsersPost/\(uid)/\(postId)")
                                postUserRef.setValue(postObject, withCompletionBlock: { (error, ref) in
                                    if error == nil{
                                        print("sukses post donasi")
                                        
                                        let userRef = Database.database().reference().child("UsersPost/\(uid)/\(postId)/")
                                        
                                        let objectId = [
                                            "idtransaction": postId] as [String:Any]
                                        
                                        userRef.updateChildValues(objectId, withCompletionBlock: { (error, ref) in
                                            if error == nil {
                                                print("sukses masukin transaction id")
                                                completion(true)
                                            }else{
                                                completion(false)
                                            }
                                        })
                                        
                                    }else{
                                        completion(false)
                                    }
                                })
                            }else{
                                print("error post transaction id donasi")
                                completion(false)
                            }
                        }
                        
                        
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
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            print("yes")
            completion(true)
        } else {
            // No user is signed in.
            // ...
            print("no")
            completion(false)
        }
    }
    
    func uploadPostImage(_ image:UIImage,id:String, completion: @escaping ((_ url:URL?)->())) {
            var ref: DatabaseReference!
    
            ref = Database.database().reference()
            let uid = ref.child("PublicPost/\(id)").childByAutoId().key
		
		// Used describing here
		let storageRef = Storage.storage().reference().child("PublicPost/\(id)/\(String(describing: uid))")
    
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
    
    
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
    
            storageRef.putData(imageData, metadata: metaData) { metaData, error in
                if error == nil, metaData != nil {
    
                    storageRef.downloadURL { url, error in
                        completion(url)
                    }
                } else {
					print(error ?? "")
					print(metaData ?? "")
                    // failed
                    print("failed")
                    completion(nil)
                }
            }
        }
    
    func saveProfile(username:String,email:String, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {completion(false); return }
        
        
        let databaseRef = Database.database().reference().child("users/donatur/profile/\(uid)")
        
        let userObject = [
            "username": username,"email": email] as [String:Any]
        
        databaseRef.updateChildValues(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func retrieveUserToken(id:String,completion: @escaping (String,Bool) -> Void) {
        print("koko",id)
        let databaseTokenRef = Database.database().reference().child("users/fcmtoken/\(id)")
        var tempTokenKey = ""
        
        
        databaseTokenRef.observe(.value, with: { snapshot in
			var _:UserProfile?
            //print(snapshot.value)
            if let dict = snapshot.value as? [String:Any],
                let tokenkey = dict["fcmToken"] as? String
            {
                
                tempTokenKey = tokenkey
                print(tokenkey)
                completion(tempTokenKey,true)
                
            }else{
                completion(tempTokenKey,false)
                print("gagal ambil token")
            }
        })
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
        let postUserRef = Database.database().reference().child("UsersPost/\(userid)/\(idtransaksi)")
		let databaseTransaksiRef = Database.database().reference().child("PublicPost/\(idtransaksi)/transaksi")
		let databaseDeadPost = Database.database().reference().child("Riwayat/User/\(userid)/").childByAutoId()
		let databasePostRef = Database.database().reference().child("PublicPost/\(idtransaksi)")
		let transaksiObject = ["status": 0] as [String:Any]
		
        let oldDescription = data.deskripsi.split(separator: "|")
		let newDescription = "Cancelled | \(Reason) |\(oldDescription[2])"
		
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
				"status": 0,
				"waktuambil": data.waktuambil,
				"waktusampai": 0
			],"barang": [
				"namabarang": data.namaitem,
				"deskripsibarang":newDescription,
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
						
						
						let databaseRef = Database.database().reference().child("Riwayat/User/\(userid)/\(postId)")
						
						let idObject = [
							"idtransaction": postId] as [String:Any]
						
						databaseRef.updateChildValues(idObject) { error, ref in
							if error == nil {
								print("sukses masukin transaction id")
								databasePostRef.setValue(nil){ error, ref in
									if error == nil {
										print("sukses hapus data")
                                        postUserRef.setValue(nil){ error, ref in
                                            if error == nil {
                                                print("sukses hapus data")
                                                self.retrieveUserToken(id: data.idkomunitas, completion: { (token, result) in
                                                    if result{
                                                        print("masuk send notif")
                                                        let sender = PushNotificationSender()
                                                        sender.sendPushNotification(to: token, title: "Order Dibatalkan", body: "Order dibatalkan oleh donatur")
                                                        completion(true)
                                                    }else{
                                                        completion(false)
                                                    }
                                                })                                    }else{
                                                print("gagal hapus data")
                                                completion(false)
                                            }
                                        }}else{
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
	
}


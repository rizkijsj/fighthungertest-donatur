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
		
        if verifyUserExistanceInDataBase(phoneno: phoneNo) == true{
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
            let errorText = errorCode(code: 2)
            
            completion(false,errorText)
        }
	}
    
    func verifyRegister(
        phoneNo:String,
        completion: @escaping (Bool,String) -> Void){
       
        if verifyUserExistanceInDataBase(phoneno: phoneNo) == true{
            print("error")
            let errorText = errorCode(code: 1)
            
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
                    let errorText = self.errorCode(code: 0)
                    
                    completion(true,errorText)
                    print("sukses verify dong")
                }
            }
//            self.verifyPhone(phonenumber: phoneNo) { (success) in
//                if success{
//                    print("kokokoko")
//                    tempStatus = true
////                    codeError = 0
//                }
//                else{
//                    //tempStatus = false
//                    //codeError = 100
//                    print("gagal")
//                }
//                print("kukuku")
//                completion(tempStatus)
//            }
        }
//        return(tempStatus,codeError)
    }
    
    func verifyUserExistanceInDataBase(phoneno:String) -> Bool{
        let ref = Database.database().reference()
        var result = false
        ref.child("users/phonenumber/\(phoneno)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                print("phone number exist")
                result = true
            }else{
                print("phone number not exist")
                result = false
            }
        })
        return result
    }
    
	
    func signUpIn(email:String, nama:String, phonenumber:String,kodeotp:PhoneAuthCredential) -> Bool{
		// TODO:
        let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/fight-hunger.appspot.com/o/profiledefault.jpg?alt=media&token=8234e660-a04d-4e54-abe3-e615c74ff91f")
        var result = false
        
        Auth.auth().signIn(with: kodeotp) { (user, error) in
            if error != nil && user != nil{
                print("error: \(String(describing: error?.localizedDescription))")
                result = false
            }else{
                //testing
                
                print("Phone number: \(user?.phoneNumber)")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(userInfo?.providerID)")
                //codingan
				
                if self.verifyUserExistanceInDataBase(phoneno: phonenumber) == false{
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    let databaseRef = Database.database().reference().child("users/donatur/profile/\(uid)")
                    let phoneNumberDatabaseRef = Database.database().reference().child("users/phonenumber/\(phonenumber)")
                    let userObject = [
                        "username":nama,"email": email,"photoURL":url?.absoluteString,"phonenumber": phonenumber
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
                }
                
               result = true
            }
        }
        
		return result
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
    
    func uploadPostImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
            var ref: DatabaseReference!
    
            ref = Database.database().reference()
            let uid = ref.child("Post/FOI").childByAutoId().key
            let storageRef = Storage.storage().reference().child("Post/FOI/\(uid)")
    
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
    
    func saveProfile(username:String,email:String ,profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let databaseRef = Database.database().reference().child("users/donatur/profile/\(uid)")
        
        let userObject = [
            "username": username,"email": email,
            "photoURL": profileImageURL.absoluteString] as [String:Any]
        
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
	
	// MARK: - Post Donation
	func postDonationSucess(donationName:String,image:UIImage,locationName:String, locationCoor:CLLocationCoordinate2D,pickupTime:Date,desccription:String) -> Bool {
		// TODO:
		return true
	}
	func postDonationFail(donationName:String,image:UIImage,locationName:String, locationCoor:CLLocationCoordinate2D,pickup:Date,desccription:String) -> Bool {
		
		return false
	}
	
	// MARK: - Update donation Status
	func donationUpdateDeliverySuccess(transactionID:String) -> Bool{
		return true
	}
	func donationUpdateDeliveryFail(transactionID:String) -> Bool{
		return false
	}
	func donationCancel(transactionID:String,reason:String) -> Bool{
		return true
	}
	
    // MARK: - Program Detail
    func programDetail(programID:String) -> programObject? {
        
        let item:programObject = programObject.init(proId: programID, orgID: "!", proName: "1", proLocName: "1", proLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 1)!, longitude: CLLocationDegrees.init(exactly: 1)!), proTime:
            "NOW", proDesc: "1 adalah anga yang indah. ini adalah sesuatu yang PERTAMA! lebih awal lagi dari semua angka, mungkin 0. TAPI 0 itu tidak NYATA! KITA HARUS BILANG 1! Satu! SATU! jangan pernah memilih yang 0. Pililah yang pasti hanya SATU! atau pilih yang bisa berdua. 2 itu ada;ah angka indah. 2 bisa membawa diri dan pasangan satu lagi. mungkin 3 kalo di hitung yang sebelah. Bersiaplah memilih yang akan sukses", proImageLink: "https://upload.wikimedia.org/wikipedia/commons/0/09/Ayam_Pelung.jpg")
        
        
        
        return item
    }
    
    // MARK: - Organizarion Detail
    func organizationDetail(organizationID:String) -> organizationObject? {
        
        let item:organizationObject = organizationObject.init(orgId: organizationID, orgPhone: "1", orgEmail: "1@2.com", orgName: "1", orgDesc: "2", orgLogo: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg", orgLocName: "2", orgLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 5)!, longitude: CLLocationDegrees.init(exactly: 5)!), orgLink: "google.com")
        
        
        
        return item
    }
    
    // MARK: - Donator Detail
    func donatorDetail(donatorID:String) -> donatorObject? {
        
        let item:donatorObject = donatorObject.init(donId: donatorID, donPhone: "#", donEmail: "3@4.com", donName: "3", donPro: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg")
        
        
        
        return item
    }
    
    // MARK: - Transaction (donation) Detail
    func transactionDetail(transactionID:String) -> transactionObject?{
        
        let item:transactionObject = transactionObject.init(tranID: transactionID, tranDonId: "3", tranOrgId: "!", tranName: "Duck", tranImage: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg", tranLocName: "10", tranLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: -6)!, longitude: CLLocationDegrees.init(exactly: 108)!), tranPickUpTime: Date(timeIntervalSince1970: 70000000), tranDesc: "Just Ducks", tranCourierName: "2", tranCourierDesc: "2 aja", tranStatus: 0, tranReason: "Ducks", tranQuantity: 100, tranLocNote: "Di hati mu", transArrivalTime: nil)
        
        return item
    }

	
	// MARK: - Program List
	func programList() -> [programObject] {
		var items:[programObject] = []
		
        items.append(programDetail(programID: "P0")!)
        items.append(programDetail(programID: "P1")!)
        items.append(programDetail(programID: "P5")!)
		
		return items
		
	}
    
    func getOrganizationProgramList(organizationID:String, limit:Int) -> [programObject] {
        
        var items:[programObject] = []
        
        items.append(programDetail(programID: "P0")!)
        items.append(programDetail(programID: "P1")!)
        items.append(programDetail(programID: "P5")!)
        
        return items
        
    }
	
	
	// MARK: - Organization List
	func organizationList() -> [organizationObject] {
		var items:[organizationObject] = []
		
        items.append(organizationDetail(organizationID: "O1")!)
        items.append(organizationDetail(organizationID: "O2")!)
        items.append(organizationDetail(organizationID: "O3")!)
		
		return items
		
	}
	
	// MARK: - Transaction List List
	func transactionList() -> [transactionObject] {
		var items:[transactionObject] = []
		
        items.append(transactionDetail(transactionID: "T1")!)
        items.append(transactionDetail(transactionID: "T2")!)
        items.append(transactionDetail(transactionID: "T700")!)
        items.append(transactionDetail(transactionID: "T5005")!)
        items.append(transactionDetail(transactionID: "T2")!)
        items.append(transactionDetail(transactionID: "T909")!)
        items.append(transactionDetail(transactionID: "T189")!)
		
		items[0].status = 1
		items[1].status = 1
		items[2].status = 2
		items[3].status = 3
		items[4].status = 4
		items[5].status = 4
		items[6].status = 2
		
		return items
		
	}
	
	
	
}



// MARK: - Sample Classes
// TODO: Remove the sample classes into proper class
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

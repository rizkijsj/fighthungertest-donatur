//
//  Connector.swift
//  FightHunger-DonaturVersion
//
//  Created by Antonius George on 14/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreLocation


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

class connector {
	// MARK: - Login Signup
	func loginSucess(phoneNo:String) -> Bool{
		// TODO:
		return true
	}
	func loginFail(phoneNo:String) -> Bool{
		// TODO:
		return false
	}
	
	func signUpSucess(nama:String, phoneNo:String) -> Bool{
		// TODO:
		return true
	}
	func signUpFail(nama:String, honeNo:String) -> Bool{
		// TODO:
		return false
	}
	func SMSSucess(verificationCode:String) -> Bool{
		// TODO:
		return true
	}
	func SMSFail(verificationCode:String) -> Bool{
		// TODO:
		return false
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
	func programDetail() -> programObject {
		
		let item:programObject = programObject.init(proId: "1", proType: "1", orgID: "!", proName: "1", proLocName: "1", proLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 1)!, longitude: CLLocationDegrees.init(exactly: 1)!), proTime: Date(), proDesc: "1", proImageLink: ["https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg"])
		
		
		
		return item
	}
	
	// MARK: - Organizarion Detail
	func organizationDetail() -> organizationObject {
		
		let item:organizationObject = organizationObject.init(orgId: "1", orgPhone: "1", orgEmail: "1@2.com", orgName: "1", orgDesc: "2", orgLogo: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg", orgLocName: "2", orgLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: 5)!, longitude: CLLocationDegrees.init(exactly: 5)!), orgLink: ["web":"google.com"])
		
		
		
		return item
	}
	
	// MARK: - Donator Detail
	func donatorDetail() -> donatorObject {
		
		let item:donatorObject = donatorObject.init(donId: "3", donPhone: "#", donEmail: "3@4.com", donName: "3", donPro: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg")
		
		
		
		return item
	}
	
	// MARK: - Transaction (donation) Detail
	func transactionDetail() -> transactionObject{
		
        let item:transactionObject = transactionObject.init(tranID: "1-", tranDonId: "3", tranOrgId: "1", tranName: "Duck", tranImage: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Bucephala-albeola-010.jpg", tranLocName: "10", tranLocCoor: CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(exactly: -6)!, longitude: CLLocationDegrees.init(exactly: 108)!), tranPickUpTime: Date(), tranDesc: "just duck", tranCourierName: "1", tranCourierDesc: "1 aja", tranStatus: 0, tranReason: "Ducks")
		
		return item
	}

	
	// MARK: - Program List
	func programList() -> [programObject] {
		var items:[programObject] = []
		
		items.append(programDetail())
		items.append(programDetail())
		items.append(programDetail())
		
		return items
		
	}
	
	
	// MARK: - Organization List
	func organizationList() -> [organizationObject] {
		var items:[organizationObject] = []
		
		items.append(organizationDetail())
		items.append(organizationDetail())
		items.append(organizationDetail())
		
		return items
		
	}
	
	// MARK: - Transaction List List
	func transactionList() -> [transactionObject] {
		var items:[transactionObject] = []
		
		items.append(transactionDetail())
		items.append(transactionDetail())
		items.append(transactionDetail())
		items.append(transactionDetail())
		items.append(transactionDetail())
		items.append(transactionDetail())
		items.append(transactionDetail())
		
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
	var organizationId:String
	var name:String
	var image:String
	var locationName:String
	var locationCoor:CLLocationCoordinate2D
	var pickUpTime:Date
	var description:String
	var courierName:String?
	var courierDescription:String?
	var status:Int
	var reason:String?
	
	init(tranID:String,tranDonId:String,tranOrgId:String,tranName:String,tranImage:String,tranLocName:String,tranLocCoor:CLLocationCoordinate2D,tranPickUpTime:Date,tranDesc:String, tranCourierName:String?, tranCourierDesc:String?, tranStatus:Int, tranReason:String?) {
		
		id = tranID
		donatorId = tranDonId
		organizationId = tranOrgId
		name = tranName
		image = tranImage
		locationName = tranLocName
		locationCoor = tranLocCoor
		pickUpTime = tranPickUpTime
		description = tranDesc
		
		courierName = tranCourierName
		courierDescription = tranCourierDesc
		
		status = tranStatus
		reason = tranReason
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
	var link:[String:String]
	
	init(orgId:String,orgPhone:String,orgEmail:String,orgName:String,orgDesc:String,orgLogo:String,orgLocName:String,orgLocCoor:CLLocationCoordinate2D,orgLink:[String:String]) {
		
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
	var type:String
	var organizationID:String
	var name:String
	var locationName:String
	var locationCoor:CLLocationCoordinate2D
	var time:Date
	var description:String
	var imagesLink: [String]
	
	init(proId:String,proType:String,orgID:String,proName:String,proLocName:String,proLocCoor:CLLocationCoordinate2D,proTime:Date,proDesc:String,proImageLink:[String]) {
		id = proId
		type = proType
		organizationID = proId
		name = proName
		locationName = proLocName
		locationCoor = proLocCoor
		time = proTime
		description = proDesc
		imagesLink = proImageLink
	}
	
}

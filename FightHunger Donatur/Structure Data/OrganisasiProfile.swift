//
//  OrganisasiProfile.swift
//  FightHunger Donatur
//
//  Created by Rizki Adrian Saputra on 04/02/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import Foundation

class OrganisasiProfile: Equatable {

	
    
    var id:String
    var phone:String
    var email:String
    var name:String
    var description:String
    var logo:URL
    var locationName:String
    //var locationCoor:CLLocationCoordinate2D
    var latitude: Double
    var longitude: Double
    var link:URL
    
    init(orgId:String,orgPhone:String,orgEmail:String,orgName:String,orgDesc:String,orgLogo:URL,orgLocName:String,latitude: Double,longitude: Double,orgLink:URL) {
        
        self.id = orgId
        self.phone = orgPhone
        self.email = orgEmail
        self.name = orgName
        self.description = orgDesc
        self.logo = orgLogo
        self.locationName = orgLocName
        self.latitude = latitude
        self.longitude = longitude
        self.link = orgLink
        
    }
	
	static func == (lhs: OrganisasiProfile, rhs: OrganisasiProfile) -> Bool {
		return lhs.id == rhs.id &&
		lhs.phone == rhs.phone &&
		lhs.email == rhs.email &&
		lhs.name == rhs.name &&
		lhs.description == rhs.description &&
		lhs.logo == rhs.logo &&
		lhs.locationName == rhs.locationName &&
		lhs.latitude == rhs.latitude &&
		lhs.longitude == rhs.longitude &&
		lhs.link == rhs.link
	}
}

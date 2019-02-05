//
//  OrganisasiProfile.swift
//  FightHunger Donatur
//
//  Created by Rizki Adrian Saputra on 04/02/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import Foundation

class OrganisasiProfile {
    
    var id:String
    var phone:String
    var email:String
    var name:String
    var description:String
    var logo:String
    var locationName:String
    //var locationCoor:CLLocationCoordinate2D
    var latitude: String
    var longitude: String
    var link:String
    
    init(orgId:String,orgPhone:String,orgEmail:String,orgName:String,orgDesc:String,orgLogo:String,orgLocName:String,latitude: String,longitude: String,orgLink:String) {
        
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
}

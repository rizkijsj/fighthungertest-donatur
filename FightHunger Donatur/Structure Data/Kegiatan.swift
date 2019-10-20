//
//  Kegiatan.swift
//  FightHunger-Organisasi
//
//  Created by Rizki Adrian Saputra on 13/02/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import Foundation
import DeepDiff

class Kegiatan: Hashable, DiffAware {
	
	
    var id:String
    
    var orgId:String
    var orgName:String
    
    var programImage: URL
    var programName: String
    var programLocation: String
    var programDate: String
    var programInformation: String
    
    
    init(id:String, orgId:String,orgName:String, programimage: URL, programname: String, programlocation: String, programdate: String, programinformation:String) {
        
        self.id = id
        self.orgId = orgId
        self.orgName = orgName
        
        self.programImage = programimage
        self.programName = programname
        self.programLocation = programlocation
        self.programDate = programdate
        self.programInformation = programinformation
        
       
        
    }
	
	static func == (lhs: Kegiatan, rhs: Kegiatan) -> Bool {
		return lhs.id == rhs.id &&
		lhs.orgId == rhs.orgId &&
		lhs.orgName == rhs.orgName &&
		
		lhs.programImage == rhs.programImage &&
		lhs.programName == rhs.programName &&
		lhs.programLocation == rhs.programLocation &&
		lhs.programDate == rhs.programDate &&
		lhs.programInformation == rhs.programInformation
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(orgId)
		hasher.combine(orgName)
		hasher.combine(programImage)
		hasher.combine(programName)
		hasher.combine(programLocation)
		hasher.combine(programDate)
		hasher.combine(programInformation)
	}
	
//	var hashValue:Int {
//		var hasher = Hasher()
//		self.hash(into: &hasher)
//		return hasher.finalize()
//	}

	
    
}

//
//  UserProfile.swift
//  PageSpareFood1
//
//  Created by Rizki Adrian Saputra on 14/10/18.
//  Copyright © 2018 Nelis Lasta. All rights reserved.
//

import Foundation

class UserProfile: Hashable {

	
    var uid:String
    var email:String
    var phonenumber:String
    var username:String
    //var role:String
    
    init(uid:String, email:String,phonenumber:String,username:String) {
        self.uid = uid
        self.email = email
        self.phonenumber = phonenumber
        self.username = username
        //self.role = role
    }
	
	static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
		return lhs.uid == rhs.uid &&
		lhs.email == rhs.email &&
		lhs.phonenumber == rhs.phonenumber &&
		lhs.username == rhs.username
	}
	
//	var hashValue:Int {
//		var hasher = Hasher()
//		self.hash(into: &hasher)
//		return hasher.finalize()
//	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(uid)
		hasher.combine(email)
		hasher.combine(phonenumber)
		hasher.combine(username)
	}
	
}

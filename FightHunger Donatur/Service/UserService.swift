//
//  UserService.swift
//  PageSpareFood1
//
//  Created by Rizki Adrian Saputra on 14/10/18.
//  Copyright © 2018 Nelis Lasta. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/donatur/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            print(snapshot.value)
            if let dict = snapshot.value as? [String:Any],
                let email = dict["email"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL),
                let phonenumber = dict["phonenumber"] as? String,
                let namaDonatur = dict["username"] as? String
            {
                userProfile = UserProfile(uid: snapshot.key, email: email,phonenumber: phonenumber ,photoURL: url, username: namaDonatur)
            }
            
            completion(userProfile)
        })
    }
    
}


//
//  Post.swift
//  FirebaseAuth
//
//  Created by Rizki Adrian Saputra on 24/01/19.
//

import Foundation


class Post {
    var id:String
    var author:UserProfile
    var namaitem:String
    var alamat:String
    var deskripsi: String
    var postphotourl:URL
    var pickupTime:String
    var timestamp:Double
    var status:String
    
    init(id:String, author:UserProfile,namaitem:String,alamat:String,deskripsi:String,postphotourl:URL,pickupTime:String,timestamp:Double,status:String) {
        self.id = id
        self.author = author
        self.namaitem = namaitem
        self.alamat = alamat
        self.deskripsi = deskripsi
        self.postphotourl = postphotourl
        self.pickupTime = pickupTime
        self.timestamp = timestamp
        self.status = status
    }
}

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
    var keteranganlokasi:String
    var deskripsi: String
    var postphotourl:URL
    var waktuambil:String
    var jumlahbarang:String
    var timestamp:Double
    var status:String
    var latitude:String
    var longitude:String
    
    init(id:String, author:UserProfile,namaitem:String,alamat:String,keteranganlokasi:String,deskripsi:String,postphotourl:URL,waktuambil:String,jumlahbarang:String,timestamp:Double,status:String,latitude:String,longitude:String) {
        self.id = id
        self.author = author
        self.namaitem = namaitem
        self.alamat = alamat
        self.keteranganlokasi = keteranganlokasi
        self.jumlahbarang = jumlahbarang
        self.deskripsi = deskripsi
        self.postphotourl = postphotourl
        self.waktuambil = waktuambil
        self.timestamp = timestamp
        self.status = status
        self.longitude = longitude
        self.latitude = latitude
    }
}

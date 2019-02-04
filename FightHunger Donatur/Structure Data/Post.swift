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
	var organisasi:UserProfile? // Organisasi
	
	var postphotourl:String
	
    var namaitem:String
	var deskripsi: String
	var jumlahbarang:String
	
    var alamat:String
    var keteranganlokasi:String
	var latitude:String
	var longitude:String
	
    var waktuambil:Double
	var waktusampai:Double?
	
	var namakurir:String?
	var	deskripsikurir:String?
	
	
    var timestamp:Double
    var status:String
	var alasanbatal:String?
	
	init(id:String, author:UserProfile, organisasi:UserProfile?, postphotourl:String, namaitem:String, deskripsi:String, jumlahbarang:String, alamat:String, keteranganlokasi:String, latitude:String, longitude:String, waktuambil:Double, waktusampai:Double?, namakurir:String?, deskripsikurir:String?, timestamp:Double, status:String, alasanbatal:String?) {
		
		self.id = id
		self.author = author
		self.organisasi = organisasi
		
		self.postphotourl = postphotourl
		
		self.namaitem = namaitem
		self.deskripsi = deskripsi
		self.jumlahbarang = jumlahbarang
		
		self.alamat = alamat
		self.keteranganlokasi = keteranganlokasi
		self.longitude = longitude
		self.latitude = latitude
		
		
		self.waktuambil = waktuambil
		self.waktusampai = waktusampai
		
		self.namakurir = namakurir
		self.deskripsikurir = deskripsikurir
		
		self.timestamp = timestamp
		self.status = status
		self.alasanbatal = alasanbatal
		
		
	}
	
    /*
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
	*/
	
	
	
	
}

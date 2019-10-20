//
//  Post.swift
//  FirebaseAuth
//
//  Created by Rizki Adrian Saputra on 24/01/19.
//

import Foundation
import DeepDiff


class Post: Hashable, DiffAware {
    var id:String
    var author:UserProfile
	
	var logokomunitas: URL
	var namakomunitas: String
	var idkomunitas: String
	var phonekomunitas:String
	//var organisasi:OrganisasiProfile? // Organisasi
	
	var postphotourl:URL
	
    var namaitem:String
	var deskripsi: String
	var jumlahbarang:String
	
    var alamat:String
    var keteranganlokasi:String
	var latitude:Double
	var longitude:Double
	
    var waktuambil:Double
	var waktusampai:Double
	
	var namakurir:String
	var	deskripsikurir:String
	
	
    var timestamp:Double
    var idtransaksi:String
    var status:Int
	var alasanbatal:String
	
    init(id:String, author:UserProfile, idkomunitas:String, logokomunitas: URL, namakomunitas: String, phonekomunitas:String , postphotourl:URL, namaitem:String, deskripsi:String, jumlahbarang:String, alamat:String, keteranganlokasi:String, latitude:Double, longitude:Double, waktuambil:Double, waktusampai:Double, namakurir:String, deskripsikurir:String, timestamp:Double, status:Int, alasanbatal:String,idtransaction:String) {
		
		self.id = id
		self.author = author
		
		self.idkomunitas = idkomunitas
		self.logokomunitas = logokomunitas
		self.namakomunitas = namakomunitas
		self.phonekomunitas = phonekomunitas
		
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
        self.idtransaksi = idtransaction
		self.status = status
		self.alasanbatal = alasanbatal
		
		
	}
	
	static func == (lhs: Post, rhs: Post) -> Bool {
		return lhs.id == rhs.id &&
		lhs.author == rhs.author &&
		
		lhs.idkomunitas == rhs.idkomunitas &&
		lhs.logokomunitas == rhs.logokomunitas &&
		lhs.namakomunitas == rhs.namakomunitas &&
		lhs.phonekomunitas == rhs.phonekomunitas &&
		
		lhs.postphotourl == rhs.postphotourl &&
		
		lhs.namaitem == rhs.namaitem &&
		lhs.deskripsi == rhs.deskripsi &&
		lhs.jumlahbarang == rhs.jumlahbarang &&
		
		lhs.alamat == rhs.alamat &&
		lhs.keteranganlokasi == rhs.keteranganlokasi &&
		lhs.longitude == rhs.longitude &&
		lhs.latitude == rhs.latitude &&
		
		
		lhs.waktuambil == rhs.waktuambil &&
		lhs.waktusampai == rhs.waktusampai &&
		
		lhs.namakurir == rhs.namakurir &&
		lhs.deskripsikurir == rhs.deskripsikurir &&
		
		lhs.timestamp == rhs.timestamp &&
		lhs.idtransaksi == rhs.idtransaksi &&
		lhs.status == rhs.status &&
		lhs.alasanbatal == rhs.alasanbatal
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(author)
		hasher.combine(idkomunitas)
		hasher.combine(logokomunitas)
		hasher.combine(namakomunitas)
		hasher.combine(phonekomunitas)
		hasher.combine(postphotourl)
		hasher.combine(namaitem)
		hasher.combine(deskripsi)
		hasher.combine(jumlahbarang)
		hasher.combine(alamat)
		hasher.combine(keteranganlokasi)
		hasher.combine(longitude)
		hasher.combine(latitude)
		hasher.combine(waktuambil)
		hasher.combine(waktusampai)
		hasher.combine(namakurir)
		hasher.combine(deskripsikurir)
		hasher.combine(timestamp)
		hasher.combine(idtransaksi)
		hasher.combine(status)
		hasher.combine(alasanbatal)
	}
	
	
	/*
	var hashValue:Int {
	var hasher = Hasher()
	self.hash(into: &hasher)
	return hasher.finalize()
	}
	*/
	
}

extension DiffAware where Self: Hashable {
    public var diffId: Int {
        return hashValue
    }

    public static func compareContent(_ a: Self, _ b: Self) -> Bool {
        return a == b
    }
}

extension UUID: DiffAware {}
extension CGFloat: DiffAware {}

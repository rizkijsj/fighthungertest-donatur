package id.fighthunger.donatur.data.repository

import android.net.Uri
import com.fighthunger.donatur.data.model.*
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.storage.FirebaseStorage
import kotlinx.coroutines.tasks.await

class DonationRepository(private val db: FirebaseDatabase = FirebaseDatabase.getInstance(), private val storage: FirebaseStorage = FirebaseStorage.getInstance()) {
    suspend fun upload(uri: Uri, uid: String): String { val ref = storage.reference.child("PublicPost/$uid/${System.currentTimeMillis()}.jpg"); ref.putFile(uri).await(); return ref.downloadUrl.await().toString() }
    suspend fun create(user: UserProfile, org: OrganizationProfile?, item: String, location: String, note: String, description: String, quantity: String, pickup: Double, lat: Double, lon: Double, image: String): String {
        val uid = user.uid; val ref = db.reference.child("PublicPost").push(); val id = ref.key ?: error("No database id"); val o = org ?: OrganizationProfile(id = "-")
        val value = mapOf("author" to mapOf("uid" to user.uid, "email" to user.email, "phonenumber" to user.phoneNumber, "username" to user.username), "komunitas" to mapOf("id" to o.id, "logo" to o.logo, "name" to o.name, "phone" to o.phone), "alamat" to mapOf("keteranganlokasi" to note, "namalokasi" to location, "latitude" to lat, "longitude" to lon), "transaksi" to mapOf("alasanbatal" to "kosong", "deskripsikurir" to "kosong", "namakurir" to "kosong", "status" to if (o.id == "-") 1 else 2, "waktuambil" to pickup, "waktusampai" to 0), "barang" to mapOf("namabarang" to item, "deskripsibarang" to description, "jumlahbarang" to quantity, "postphotourl" to image), "idtransaction" to id, "timestamp" to mapOf(".sv" to "timestamp"))
        ref.setValue(value).await(); db.reference.child("UsersPost/$uid/$id").setValue(value).await(); return id
    }
    suspend fun history(uid: String): List<DonationPost> = db.reference.child("Riwayat/User/$uid").get().await().children.mapNotNull { parse(it.key ?: "", it.value as? Map<*, *>) }
    private fun parse(id: String, m: Map<*, *>?): DonationPost? { if (m == null) return null; val a=m["author"] as? Map<*, *> ?: return null; val o=m["komunitas"] as? Map<*, *> ?: return null; val l=m["alamat"] as? Map<*, *> ?: return null; val t=m["transaksi"] as? Map<*, *> ?: return null; val b=m["barang"] as? Map<*, *> ?: return null; return DonationPost(id, UserProfile(a["uid"] as? String ?: "", a["email"] as? String ?: "", a["phonenumber"] as? String ?: "", a["username"] as? String ?: ""), o["id"] as? String ?: "", o["logo"] as? String ?: "", o["name"] as? String ?: "", o["phone"] as? String ?: "", b["postphotourl"] as? String ?: "", b["namabarang"] as? String ?: "", b["deskripsibarang"] as? String ?: "", b["jumlahbarang"] as? String ?: "", l["namalokasi"] as? String ?: "", l["keteranganlokasi"] as? String ?: "", (l["latitude"] as? Number)?.toDouble() ?: 0.0, (l["longitude"] as? Number)?.toDouble() ?: 0.0, (t["waktuambil"] as? Number)?.toDouble() ?: 0.0, (t["waktusampai"] as? Number)?.toDouble() ?: 0.0, t["namakurir"] as? String ?: "", t["deskripsikurir"] as? String ?: "", (m["timestamp"] as? Number)?.toDouble() ?: 0.0, m["idtransaction"] as? String ?: id, (t["status"] as? Number)?.toInt() ?: 0, t["alasanbatal"] as? String ?: "") }
}

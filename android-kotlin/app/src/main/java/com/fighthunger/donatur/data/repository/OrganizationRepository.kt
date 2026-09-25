package com.fighthunger.donatur.data.repository

import com.fighthunger.donatur.data.model.OrganizationProfile
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await

class OrganizationRepository(private val db: FirebaseDatabase = FirebaseDatabase.getInstance()) {
    suspend fun all(): List<OrganizationProfile> = db.reference.child("users/komunitas").get().await().children.mapNotNull { parse(it.value as? Map<*, *>) }
    suspend fun byId(id: String): OrganizationProfile? = all().firstOrNull { it.id == id }
    private fun parse(m: Map<*, *>?): OrganizationProfile? {
        if (m == null) return null
        val c = m["locationcoor"] as? Map<*, *>
        return OrganizationProfile(
            id = m["id"] as? String ?: "", phone = m["phone"] as? String ?: "", email = m["email"] as? String ?: "",
            name = m["name"] as? String ?: "", description = m["description"] as? String ?: "", logo = m["logo"] as? String ?: "",
            locationName = m["locationname"] as? String ?: "", latitude = (c?.get("latitude") as? Number)?.toDouble() ?: 0.0,
            longitude = (c?.get("longitude") as? Number)?.toDouble() ?: 0.0, link = m["link"] as? String ?: ""
        )
    }
}

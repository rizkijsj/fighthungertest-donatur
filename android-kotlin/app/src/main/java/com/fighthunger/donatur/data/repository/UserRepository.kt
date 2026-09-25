package com.fighthunger.donatur.data.repository

import com.fighthunger.donatur.data.model.UserProfile
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await

class UserRepository(private val auth: FirebaseAuth = FirebaseAuth.getInstance(), private val db: FirebaseDatabase = FirebaseDatabase.getInstance()) {
    suspend fun current(): UserProfile? {
        val uid = auth.currentUser?.uid ?: return null
        val s = db.reference.child("users/donatur/profile/$uid").get().await()
        return UserProfile(uid, s.child("email").value as? String ?: "", s.child("phonenumber").value as? String ?: "", s.child("username").value as? String ?: "")
    }
    suspend fun update(name: String, email: String): Boolean {
        val uid = auth.currentUser?.uid ?: return false
        db.reference.child("users/donatur/profile/$uid").updateChildren(mapOf("username" to name, "email" to email)).await()
        return true
    }
}

package com.fighthunger.donatur.data.repository

import android.app.Activity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await
import java.util.concurrent.TimeUnit

class AuthRepository(
    private val auth: FirebaseAuth = FirebaseAuth.getInstance(),
    private val db: FirebaseDatabase = FirebaseDatabase.getInstance()
) {
    suspend fun phoneExists(phone: String) = db.reference.child("users/phonenumber").child(phone).get().await().exists()

    fun requestOtp(activity: Activity, phone: String, onCode: (String) -> Unit, onError: (Exception) -> Unit) {
        val callbacks = object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
            override fun onVerificationCompleted(credential: PhoneAuthCredential) { auth.signInWithCredential(credential).addOnFailureListener(onError) }
            override fun onVerificationFailed(e: com.google.firebase.FirebaseException) { onError(e) }
            override fun onCodeSent(id: String, token: PhoneAuthProvider.ForceResendingToken) { onCode(id) }
        }
        PhoneAuthProvider.verifyPhoneNumber(PhoneAuthOptions.newBuilder(auth).setPhoneNumber(phone).setTimeout(60, TimeUnit.SECONDS).setActivity(activity).setCallbacks(callbacks).build())
    }

    suspend fun verifyOtp(id: String, code: String) { auth.signInWithCredential(PhoneAuthProvider.getCredential(id, code)).await() }

    suspend fun saveProfile(email: String, name: String, phone: String) {
        val uid = auth.currentUser?.uid ?: error("Not authenticated")
        val profile = mapOf("username" to name, "email" to email, "phonenumber" to phone)
        db.reference.child("users/donatur/profile/$uid").setValue(profile).await()
        db.reference.child("users/phonenumber/$phone").setValue(uid).await()
    }
}

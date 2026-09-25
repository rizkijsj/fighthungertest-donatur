package id.fighthunger.donatur.data.repository

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
    suspend fun phoneExists(phone: String): Boolean {
        val snapshot = db.reference.child("users/phonenumber").child(phone).get().await()
        return snapshot.exists()
    }

    fun requestOtp(
        activity: Activity,
        phone: String,
        onCode: (String) -> Unit,
        onError: (Exception) -> Unit
    ) {
        val callback = object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
            override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                auth.signInWithCredential(credential).addOnFailureListener(onError)
            }

            override fun onVerificationFailed(e: com.google.firebase.FirebaseException) {
                onError(e)
            }

            override fun onCodeSent(verificationId: String, token: PhoneAuthProvider.ForceResendingToken) {
                onCode(verificationId)
            }
        }

        val options = PhoneAuthOptions.newBuilder(auth)
            .setPhoneNumber(phone)
            .setTimeout(60L, TimeUnit.SECONDS)
            .setActivity(activity)
            .setCallbacks(callback)
            .build()

        PhoneAuthProvider.verifyPhoneNumber(options)
    }

    suspend fun verifyOtp(verificationId: String, code: String) {
        val credential = PhoneAuthProvider.getCredential(verificationId, code)
        auth.signInWithCredential(credential).await()
    }

    suspend fun saveProfile(email: String, name: String, phone: String) {
        val uid = auth.currentUser?.uid ?: error("Not authenticated")
        val profile = mapOf(
            "username" to name,
            "email" to email,
            "phonenumber" to phone
        )
        db.reference.child("users/donatur/profile/$uid").setValue(profile).await()
        db.reference.child("users/phonenumber/$phone").setValue(uid).await()
    }
}

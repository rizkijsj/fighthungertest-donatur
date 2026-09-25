package com.fighthunger.donatur.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import com.fighthunger.donatur.R
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

class FightHungerMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) { val uid = FirebaseAuth.getInstance().currentUser?.uid ?: return; CoroutineScope(Dispatchers.IO).launch { FirebaseDatabase.getInstance().reference.child("users/fcmtoken/$uid").setValue(mapOf("fcmToken" to token)).await() } }
    override fun onMessageReceived(message: RemoteMessage) { show(message.notification?.title ?: "FightHunger", message.notification?.body ?: "Pembaruan donasi") }
    private fun show(title: String, body: String) { val id = "donation"; val manager = getSystemService(NotificationManager::class.java); if (Build.VERSION.SDK_INT >= 26) manager.createNotificationChannel(NotificationChannel(id, "Donations", NotificationManager.IMPORTANCE_DEFAULT)); manager.notify(System.currentTimeMillis().toInt(), NotificationCompat.Builder(this, id).setSmallIcon(android.R.drawable.ic_dialog_info).setContentTitle(title).setContentText(body).setAutoCancel(true).build()) }
}

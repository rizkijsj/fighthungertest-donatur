package id.fighthunger.donatur.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

class FightHungerMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        val uid = FirebaseAuth.getInstance().currentUser?.uid ?: return
        CoroutineScope(Dispatchers.IO).launch {
            FirebaseDatabase.getInstance().reference.child("users/fcmtoken/$uid").setValue(mapOf("fcmToken" to token)).await()
        }
    }

    override fun onMessageReceived(message: RemoteMessage) {
        val channel = "donation"
        val manager = getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(NotificationChannel(channel, "Donations", NotificationManager.IMPORTANCE_DEFAULT))
        }
        val builder = NotificationCompat.Builder(this, channel)
            .setContentTitle(message.notification?.title ?: "FightHunger")
            .setContentText(message.notification?.body ?: "Pembaruan donasi")
            .setSmallIcon(android.R.drawable.stat_notify_chat)
            .setAutoCancel(true)
        manager.notify(System.currentTimeMillis().toInt(), builder.build())
    }
}

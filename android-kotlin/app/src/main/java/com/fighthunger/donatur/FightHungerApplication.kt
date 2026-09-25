package com.fighthunger.donatur

import android.app.Application
import com.google.firebase.FirebaseApp

class FightHungerApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this)
    }
}

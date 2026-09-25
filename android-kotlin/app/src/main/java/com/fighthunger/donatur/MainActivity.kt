package com.fighthunger.donatur

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val navHost = supportFragmentManager.findFragmentById(R.id.nav_host) as? NavHostFragment
            ?: throw IllegalStateException("NavHostFragment not found")

        val navGraph = navHost.navController.navInflater.inflate(R.navigation.nav_graph)
        val startDestination = if (FirebaseAuth.getInstance().currentUser != null) {
            R.id.homeFragment
        } else {
            R.id.loginFragment
        }

        navGraph.setStartDestination(startDestination)
        navHost.navController.setGraph(navGraph, intent.extras)
    }
}

package com.fighthunger.donatur

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val host = supportFragmentManager.findFragmentById(R.id.nav_host) as NavHostFragment
        val graph = host.navController.navInflater.inflate(R.navigation.nav_graph)
        graph.setStartDestination(if (FirebaseAuth.getInstance().currentUser == null) R.id.loginFragment else R.id.homeFragment)
        host.navController.setGraph(graph, intent.extras)
    }
}

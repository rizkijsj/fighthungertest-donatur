package com.fighthunger.donatur.ui.map

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.fighthunger.donatur.databinding.FragmentMapPickerBinding
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

class MapPickerFragment : Fragment(), OnMapReadyCallback {
    private var _b: FragmentMapPickerBinding? = null
    private val b get() = _b!!
    private var map: GoogleMap? = null

    override fun onCreateView(i: LayoutInflater, c: ViewGroup?, s: Bundle?): View {
        _b = FragmentMapPickerBinding.inflate(i, c, false)
        return b.root
    }

    override fun onViewCreated(v: View, s: Bundle?) {
        (childFragmentManager.findFragmentById(com.fighthunger.donatur.R.id.map_view) as? SupportMapFragment)?.getMapAsync(this)
        b.confirmLocationButton.setOnClickListener {
            // Save selected location here when needed
        }
    }

    override fun onMapReady(g: GoogleMap) {
        map = g
        val center = LatLng(-6.2088, 106.8456)
        g.moveCamera(CameraUpdateFactory.newLatLngZoom(center, 10f))
        g.addMarker(MarkerOptions().position(center).title("Jakarta"))
        g.setOnMapClickListener {
            g.clear()
            g.addMarker(MarkerOptions().position(it).title("Lokasi dipilih"))
            g.moveCamera(CameraUpdateFactory.newLatLngZoom(it, 13f))
        }
    }

    override fun onDestroyView() { _b = null; super.onDestroyView() }
}

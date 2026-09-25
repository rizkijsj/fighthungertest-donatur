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
    private var _binding: FragmentMapPickerBinding? = null
    private val binding get() = _binding!!
    private var map: GoogleMap? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMapPickerBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val mapFragment = childFragmentManager.findFragmentById(com.fighthunger.donatur.R.id.map_view) as? SupportMapFragment
        mapFragment?.getMapAsync(this)

        binding.confirmLocationButton.setOnClickListener {
            // stub for future coordinate persistence
        }
    }

    override fun onMapReady(googleMap: GoogleMap) {
        map = googleMap
        val jakarta = LatLng(-6.2088, 106.8456)
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(jakarta, 10f))
        googleMap.addMarker(MarkerOptions().position(jakarta).title("Jakarta"))

        googleMap.setOnMapClickListener { location ->
            googleMap.clear()
            googleMap.addMarker(MarkerOptions().position(location).title("Lokasi dipilih"))
            googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(location, 13f))
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

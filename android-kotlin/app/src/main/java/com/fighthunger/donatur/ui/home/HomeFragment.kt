package id.fighthunger.donatur.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import id.fighthunger.donatur.R
import id.fighthunger.donatur.databinding.FragmentHomeBinding

class HomeFragment : Fragment() {
    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.donateButton.setOnClickListener { findNavController().navigate(R.id.donationFragment) }
        binding.activitiesButton.setOnClickListener { findNavController().navigate(R.id.activitiesFragment) }
        binding.profileButton.setOnClickListener { findNavController().navigate(R.id.profileFragment) }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

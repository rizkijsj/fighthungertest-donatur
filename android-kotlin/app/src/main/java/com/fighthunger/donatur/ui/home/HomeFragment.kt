package com.fighthunger.donatur.ui.home
import android.os.Bundle
import android.view.*
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.fighthunger.donatur.R
import com.fighthunger.donatur.databinding.FragmentHomeBinding
class HomeFragment:Fragment(){private var _b:FragmentHomeBinding?=null;private val b get()=_b!!;override fun onCreateView(i:LayoutInflater,c:ViewGroup?,s:Bundle?):View{_b=FragmentHomeBinding.inflate(i,c,false);return b.root};override fun onViewCreated(v:View,s:Bundle?){b.donateButton.setOnClickListener{findNavController().navigate(R.id.donationFragment)};b.activitiesButton.setOnClickListener{findNavController().navigate(R.id.activitiesFragment)};b.profileButton.setOnClickListener{findNavController().navigate(R.id.profileFragment)}};override fun onDestroyView(){_b=null;super.onDestroyView()}}

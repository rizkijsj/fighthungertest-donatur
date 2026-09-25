package com.fighthunger.donatur.ui/auth

import android.os.Bundle
import android.view.*
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fighthunger.donatur.R
import com.fighthunger.donatur.data.repository.AuthRepository
import com.fighthunger.donatur.databinding.FragmentOtpBinding
import kotlinx.coroutines.launch

class OtpFragment:Fragment(){ private var _b:FragmentOtpBinding?=null;private val b get()=_b!!;private val repo=AuthRepository();override fun onCreateView(i:LayoutInflater,c:ViewGroup?,s:Bundle?):View{_b=FragmentOtpBinding.inflate(i,c,false);return b.root};override fun onViewCreated(v:View,s:Bundle?){b.verifyButton.setOnClickListener{val id=arguments?.getString("verificationId").orEmpty();val existing=arguments?.getBoolean("existing")?:true;val code=b.otpInput.text.toString();if(code.length<6){b.otpInput.error="Enter 6 digits";return@setOnClickListener};lifecycleScope.launch{try{repo.verifyOtp(id,code);if(!existing)repo.saveProfile(arguments?.getString("email").orEmpty(),arguments?.getString("name").orEmpty(),arguments?.getString("phone").orEmpty());findNavController().navigate(R.id.homeFragment)}catch(e:Exception){Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()}}}};override fun onDestroyView(){_b=null;super.onDestroyView()}}

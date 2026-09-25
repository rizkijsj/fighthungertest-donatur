package com.fighthunger.donatur.ui.auth

import android.os.Bundle
import android.view.*
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.fighthunger.donatur.R
import com.fighthunger.donatur.data.repository.AuthRepository
import com.fighthunger.donatur.databinding.FragmentRegisterBinding
import com.fighthunger.donatur.util.PhoneNumberFormatter

class RegisterFragment : Fragment() {
 private var _b: FragmentRegisterBinding?=null; private val b get()=_b!!; private val repo=AuthRepository()
 override fun onCreateView(i:LayoutInflater,c:ViewGroup?,s:Bundle?):View{_b=FragmentRegisterBinding.inflate(i,c,false);return b.root}
 override fun onViewCreated(v:View,s:Bundle?){b.registerButton.setOnClickListener{val name=b.nameInput.text.toString().trim();val email=b.emailInput.text.toString().trim();val phone=PhoneNumberFormatter.format(b.phoneInput.text.toString());if(name.isBlank()||email.isBlank()||phone.isBlank()){Toast.makeText(requireContext(),"Fill all fields",Toast.LENGTH_SHORT).show();return@setOnClickListener}; if(!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()){b.emailInput.error="Invalid email";return@setOnClickListener}; repo.requestOtp(requireActivity(),phone,{id->findNavController().navigate(R.id.otpFragment,Bundle().apply{putString("verificationId",id);putBoolean("existing",false);putString("name",name);putString("email",email);putString("phone",phone)})},{e->Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()})}}
 override fun onDestroyView(){_b=null;super.onDestroyView()}
}

package com.fighthunger.donatur.ui.auth

import android.os.Bundle
import android.view.*
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fighthunger.donatur.R
import com.fighthunger.donatur.data.repository.AuthRepository
import com.fighthunger.donatur.databinding.FragmentLoginBinding
import com.fighthunger.donatur.util.PhoneNumberFormatter
import kotlinx.coroutines.launch

class LoginFragment : Fragment() {
 private var _b: FragmentLoginBinding?=null; private val b get()=_b!!; private val repo=AuthRepository()
 override fun onCreateView(i: LayoutInflater,c: ViewGroup?,s: Bundle?): View { _b=FragmentLoginBinding.inflate(i,c,false); return b.root }
 override fun onViewCreated(v: View,s: Bundle?) { b.loginButton.setOnClickListener { val phone=PhoneNumberFormatter.format(b.phoneInput.text.toString()); if(phone.isBlank()){b.phoneInput.error="Required";return@setOnClickListener}; lifecycleScope.launch { try { if(!repo.phoneExists(phone)){Toast.makeText(requireContext(),"Phone number is not registered",Toast.LENGTH_SHORT).show();return@launch}; repo.requestOtp(requireActivity(),phone,{id->findNavController().navigate(R.id.otpFragment,Bundle().apply{putString("verificationId",id);putBoolean("existing",true)})},{e->Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()}) } catch(e:Exception){Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()} } }; b.toRegisterButton.setOnClickListener{findNavController().navigate(R.id.registerFragment)} }
 override fun onDestroyView(){_b=null;super.onDestroyView()}
}

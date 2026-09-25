package com.fighthunger.donatur.ui.profile
import android.os.Bundle
import android.view.*
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.fighthunger.donatur.data.repository.UserRepository
import com.fighthunger.donatur.databinding.FragmentProfileBinding
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.launch
class ProfileFragment:Fragment(){private var _b:FragmentProfileBinding?=null;private val b get()=_b!!;override fun onCreateView(i:LayoutInflater,c:ViewGroup?,s:Bundle?):View{_b=FragmentProfileBinding.inflate(i,c,false);return b.root};override fun onViewCreated(v:View,s:Bundle?){lifecycleScope.launch{try{UserRepository().current()?.let{x->b.usernameText.text=x.username;b.emailText.text=x.email;b.phoneText.text=x.phoneNumber}}catch(e:Exception){Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()}};b.logoutButton.setOnClickListener{FirebaseAuth.getInstance().signOut();requireActivity().recreate()}};override fun onDestroyView(){_b=null;super.onDestroyView()}}

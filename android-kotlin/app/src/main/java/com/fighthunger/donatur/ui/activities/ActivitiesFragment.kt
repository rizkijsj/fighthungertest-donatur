package com.fighthunger.donatur.ui.activities
import android.os.Bundle
import android.view.*
import android.widget.*
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.fighthunger.donatur.data.repository.DonationRepository
import com.fighthunger.donatur.databinding.FragmentActivitiesBinding
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.launch
class ActivitiesFragment:Fragment(){private var _b:FragmentActivitiesBinding?=null;private val b get()=_b!!;override fun onCreateView(i:LayoutInflater,c:ViewGroup?,s:Bundle?):View{_b=FragmentActivitiesBinding.inflate(i,c,false);return b.root};override fun onViewCreated(v:View,s:Bundle?){b.activityList.layoutManager=LinearLayoutManager(requireContext());lifecycleScope.launch{try{val uid=FirebaseAuth.getInstance().currentUser?.uid?:return@launch;b.activityList.adapter=ActivityAdapter(DonationRepository().history(uid))}catch(e:Exception){Toast.makeText(requireContext(),e.message,Toast.LENGTH_LONG).show()}}};override fun onDestroyView(){_b=null;super.onDestroyView()}}

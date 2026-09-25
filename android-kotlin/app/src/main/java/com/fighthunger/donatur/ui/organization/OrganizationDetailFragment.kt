package com.fighthunger.donatur.ui.organization

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import coil.load
import com.fighthunger.donatur.databinding.FragmentOrganizationDetailBinding
import com.fighthunger.donatur.ui.attributes.ExternalActions
import com.fighthunger.donatur.data.repository.OrganizationRepository
import kotlinx.coroutines.launch

class OrganizationDetailFragment : Fragment() {
    private var _b: FragmentOrganizationDetailBinding? = null
    private val b get() = _b!!
    private val repo = OrganizationRepository()

    override fun onCreateView(i: LayoutInflater, c: ViewGroup?, s: Bundle?): View {
        _b = FragmentOrganizationDetailBinding.inflate(i, c, false)
        return b.root
    }

    override fun onViewCreated(v: View, s: Bundle?) {
        val orgId = arguments?.getString("org_id") ?: ""
        lifecycleScope.launch {
            try {
                val org = repo.byId(orgId) ?: throw IllegalStateException("Organization not found")
                b.orgName.text = org.name
                b.orgLocation.text = org.locationName
                b.orgDescription.text = org.description
                b.orgPhone.text = org.phone
                b.orgLogo.load(org.logo)
                b.callButton.setOnClickListener { ExternalActions.openPhone(requireActivity(), org.phone) }
                b.chatButton.setOnClickListener { ExternalActions.openWhatsApp(requireActivity(), org.phone) }
                b.websiteButton.setOnClickListener { ExternalActions.openWebsite(requireActivity(), org.link) }
                b.locationButton.setOnClickListener {
                    val geo = "geo:${org.latitude},${org.longitude}?q=${org.latitude},${org.longitude}(${org.name})"
                    startActivity(android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(geo)))
                }
            } catch (e: Exception) {
                Toast.makeText(requireContext(), e.message ?: "Could not load", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDestroyView() { _b = null; super.onDestroyView() }
}

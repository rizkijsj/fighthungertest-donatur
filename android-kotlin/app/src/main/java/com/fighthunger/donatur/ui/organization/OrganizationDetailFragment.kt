package id.fighthunger.donatur.ui.organization

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import coil.load
import id.fighthunger.donatur.data.repository.OrganizationRepository
import id.fighthunger.donatur.databinding.FragmentOrganizationDetailBinding
import kotlinx.coroutines.launch

class OrganizationDetailFragment : Fragment() {
    private var _binding: FragmentOrganizationDetailBinding? = null
    private val binding get() = _binding!!
    private val repo = OrganizationRepository()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentOrganizationDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val orgId = arguments?.getString("org_id") ?: ""
        lifecycleScope.launch {
            try {
                val org = repo.byId(orgId) ?: throw IllegalStateException("Organization not found")
                binding.orgLogo.load(org.logo)
                binding.orgName.text = org.name
                binding.orgLocation.text = org.locationName
                binding.orgDescription.text = org.description
                binding.orgPhone.text = org.phone

                binding.callButton.setOnClickListener {
                    startActivity(Intent(Intent.ACTION_DIAL, Uri.parse("tel:${org.phone}")))
                }

                binding.chatButton.setOnClickListener {
                    val phone = org.phone.replace("+", "")
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://wa.me/$phone")))
                }

                binding.websiteButton.setOnClickListener {
                    val url = if (org.link.startsWith("http")) org.link else "https://${org.link}"
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                }

                binding.locationButton.setOnClickListener {
                    val geo = "geo:${org.latitude},${org.longitude}?q=${org.latitude},${org.longitude}(${org.name})"
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(geo)))
                }
            } catch (e: Exception) {
                Toast.makeText(requireContext(), e.message ?: "Unable to load organization", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

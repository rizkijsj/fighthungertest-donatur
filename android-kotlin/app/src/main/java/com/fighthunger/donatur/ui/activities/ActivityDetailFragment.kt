package id.fighthunger.donatur.ui.activities

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import coil.load
import id.fighthunger.donatur.data.model.DonationPost
import id.fighthunger.donatur.data.repository.DonationRepository
import id.fighthunger.donatur.data.repository.OrganizationRepository
import id.fighthunger.donatur.databinding.FragmentActivityDetailBinding
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.launch

class ActivityDetailFragment : Fragment() {
    private var _binding: FragmentActivityDetailBinding? = null
    private val binding get() = _binding!!
    private val donationRepo = DonationRepository()
    private val orgRepo = OrganizationRepository()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentActivityDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val transactionId = arguments?.getString("transaction_id") ?: ""
        lifecycleScope.launch {
            try {
                val uid = FirebaseAuth.getInstance().currentUser?.uid ?: return@launch
                val item = donationRepo.history(uid).firstOrNull { it.transactionId == transactionId }
                    ?: throw IllegalStateException("Donation not found")
                render(item)
            } catch (e: Exception) {
                Toast.makeText(requireContext(), e.message ?: "Unable to load activity", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private suspend fun render(item: DonationPost) {
        binding.itemImage.load(item.photoUrl)
        binding.itemName.text = item.itemName
        binding.itemDescription.text = item.description
        binding.itemQuantity.text = "Jumlah: ${item.quantity}"
        binding.deliveryAddress.text = "Lokasi: ${item.address}"
        binding.statusLabel.text = when (item.status) {
            0 -> "Dibatalkan"
            1 -> "Menunggu diklaim"
            2 -> "Menunggu data kurir"
            3 -> "Sedang dijemput"
            4 -> "Sedang diantar"
            5 -> "Telah sampai"
            6 -> "Dibatalkan organisasi"
            else -> "Status tidak diketahui"
        }
        val org = orgRepo.byId(item.communityId)
        binding.organizationName.text = org?.name ?: item.communityName
        binding.orgPhone.text = org?.phone ?: item.communityPhone
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

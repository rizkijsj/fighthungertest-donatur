package com.fighthunger.donatur.ui.donation

import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fighthunger.donatur.R
import com.fighthunger.donatur.databinding.FragmentDonationBinding
import kotlinx.coroutines.launch

class DonationFragment : Fragment() {
    private var _b: FragmentDonationBinding? = null
    private val b get() = _b!!
    private var imageUri: Uri? = null
    private val viewModel = DonationViewModel()
    private val launcher = registerForActivityResult(ActivityResultContracts.GetContent()) { uri ->
        if (uri != null) {
            imageUri = uri
            b.imagePreview.setImageURI(uri)
        }
    }

    override fun onCreateView(i: LayoutInflater, c: ViewGroup?, s: Bundle?): View {
        _b = FragmentDonationBinding.inflate(i, c, false)
        return b.root
    }

    override fun onViewCreated(v: View, s: Bundle?) {
        b.pickImageButton.setOnClickListener { launcher.launch("image/*") }
        b.locationButton.setOnClickListener { findNavController().navigate(R.id.mapPickerFragment) }
        b.submitButton.setOnClickListener {
            val item = b.itemNameInput.text.toString().trim()
            val loc = b.locationInput.text.toString().trim()
            val note = b.noteInput.text.toString().trim()
            val desc = b.descriptionInput.text.toString().trim()
            val qty = b.quantityInput.text.toString().trim()
            if (imageUri == null || item.isBlank() || loc.isBlank() || note.isBlank() || desc.isBlank() || qty.isBlank()) {
                Toast.makeText(requireContext(), "Fill all fields", Toast.LENGTH_SHORT).show(); return@setOnClickListener
            }
            viewModel.submit(imageUri!!, item, loc, note, desc, qty, System.currentTimeMillis() / 1000.0, -6.2088, 106.8456)
        }

        lifecycleScope.launch {
            viewModel.state.collect { state ->
                if (state.loading) b.submitButton.isEnabled = false
                if (state.success) {
                    Toast.makeText(requireContext(), "Donation posted", Toast.LENGTH_SHORT).show()
                    findNavController().popBackStack()
                }
                if (state.error != null) {
                    Toast.makeText(requireContext(), state.error, Toast.LENGTH_LONG).show()
                    b.submitButton.isEnabled = true
                }
            }
        }
    }

    override fun onDestroyView() { _b = null; super.onDestroyView() }
}

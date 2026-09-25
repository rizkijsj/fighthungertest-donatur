package com.fighthunger.donatur.ui.donation

import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fighthunger.donatur.data.model.OrganizationProfile
import com.fighthunger.donatur.data.repository.DonationRepository
import com.fighthunger.donatur.data.repository.OrganizationRepository
import com.fighthunger.donatur.data.repository.UserRepository
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

data class DonationUiState(val loading: Boolean = false, val success: Boolean = false, val error: String? = null)

class DonationViewModel(
    private val donationRepo: DonationRepository = DonationRepository(),
    private val userRepo: UserRepository = UserRepository(),
    private val orgRepo: OrganizationRepository = OrganizationRepository()
) : ViewModel() {
    private val _state = MutableStateFlow(DonationUiState())
    val state: StateFlow<DonationUiState> = _state

    fun submit(
        imageUri: Uri,
        itemName: String,
        locationName: String,
        locationDescription: String,
        description: String,
        quantity: String,
        pickupTime: Double,
        lat: Double,
        lon: Double
    ) {
        viewModelScope.launch {
            _state.value = DonationUiState(loading = true)
            try {
                val user = userRepo.current() ?: throw IllegalStateException("User not registered")
                val org: OrganizationProfile? = orgRepo.all().firstOrNull()
                val uid = FirebaseAuth.getInstance().currentUser?.uid ?: throw IllegalStateException("Not signed in")
                val url = donationRepo.upload(imageUri, uid)
                donationRepo.create(user, org, itemName, locationName, locationDescription, description, quantity, pickupTime, lat, lon, url)
                _state.value = DonationUiState(success = true)
            } catch (e: Exception) {
                _state.value = DonationUiState(error = e.message ?: "Donation failed")
            }
        }
    }
}

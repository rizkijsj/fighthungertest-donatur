package com.fighthunger.donatur.ui.auth

import android.app.Activity
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fighthunger.donatur.data.repository.AuthRepository
import com.fighthunger.donatur.util.PhoneNumberFormatter
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

data class AuthUiState(
    val loading: Boolean = false,
    val error: String? = null,
    val verificationId: String? = null,
    val success: Boolean = false
)

class AuthViewModel(
    private val repo: AuthRepository = AuthRepository()
) : ViewModel() {

    private val _state = MutableStateFlow(AuthUiState())
    val state: StateFlow<AuthUiState> = _state

    fun requestLoginOtp(activity: Activity, rawPhone: String) {
        val phone = PhoneNumberFormatter.format(rawPhone)
        viewModelScope.launch {
            _state.value = AuthUiState(loading = true)
            try {
                if (!repo.phoneExists(phone)) {
                    _state.value = AuthUiState(error = "Phone number is not registered")
                    return@launch
                }
                repo.requestOtp(
                    activity = activity,
                    phone = phone,
                    onCode = { id -> _state.value = AuthUiState(verificationId = id) },
                    onError = { e -> _state.value = AuthUiState(error = e.message ?: "OTP failed") }
                )
            } catch (e: Exception) {
                _state.value = AuthUiState(error = e.message ?: "Unexpected error")
            }
        }
    }

    fun requestRegisterOtp(activity: Activity, email: String, name: String, rawPhone: String) {
        val phone = PhoneNumberFormatter.format(rawPhone)
        viewModelScope.launch {
            _state.value = AuthUiState(loading = true)
            try {
                if (repo.phoneExists(phone)) {
                    _state.value = AuthUiState(error = "Phone number already registered")
                    return@launch
                }
                repo.requestOtp(
                    activity = activity,
                    phone = phone,
                    onCode = { id -> _state.value = AuthUiState(verificationId = id) },
                    onError = { e -> _state.value = AuthUiState(error = e.message ?: "OTP failed") }
                )
            } catch (e: Exception) {
                _state.value = AuthUiState(error = e.message ?: "Unexpected error")
            }
        }
    }

    fun verifyCode(verificationId: String, code: String) {
        viewModelScope.launch {
            _state.value = AuthUiState(loading = true)
            try {
                repo.verifyOtp(verificationId, code)
                _state.value = AuthUiState(success = true)
            } catch (e: Exception) {
                _state.value = AuthUiState(error = e.message ?: "Verification error")
            }
        }
    }
}

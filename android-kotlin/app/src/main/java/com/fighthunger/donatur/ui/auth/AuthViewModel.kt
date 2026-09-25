package com.fighthunger.donatur.ui.auth

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
    private val _ui = MutableStateFlow(AuthUiState())
    val ui: StateFlow<AuthUiState> = _ui

    fun requestLoginOtp(activity: android.app.Activity, rawPhone: String) {
        val phone = PhoneNumberFormatter.format(rawPhone)
        viewModelScope.launch {
            _ui.value = AuthUiState(loading = true)
            try {
                if (!repo.phoneExists(phone)) {
                    _ui.value = AuthUiState(error = "Phone number is not registered")
                    return@launch
                }
                repo.requestOtp(activity, phone, onCode = { id -> _ui.value = AuthUiState(verificationId = id) }, onError = { e -> _ui.value = AuthUiState(error = e.message ?: "OTP failed") })
            } catch (e: Exception) {
                _ui.value = AuthUiState(error = e.message ?: "Unexpected error")
            }
        }
    }

    fun requestRegisterOtp(activity: android.app.Activity, email: String, name: String, rawPhone: String) {
        val phone = PhoneNumberFormatter.format(rawPhone)
        viewModelScope.launch {
            _ui.value = AuthUiState(loading = true)
            try {
                if (repo.phoneExists(phone)) {
                    _ui.value = AuthUiState(error = "Phone number already registered")
                    return@launch
                }
                repo.requestOtp(activity, phone, onCode = { id -> _ui.value = AuthUiState(verificationId = id) }, onError = { e -> _ui.value = AuthUiState(error = e.message ?: "OTP failed") })
            } catch (e: Exception) {
                _ui.value = AuthUiState(error = e.message ?: "Unexpected error")
            }
        }
    }

    fun verifyCode(id: String, code: String) {
        viewModelScope.launch {
            _ui.value = AuthUiState(loading = true)
            try {
                repo.verifyOtp(id, code)
                _ui.value = AuthUiState(success = true)
            } catch (e: Exception) {
                _ui.value = AuthUiState(error = e.message ?: "Verification error")
            }
        }
    }
}

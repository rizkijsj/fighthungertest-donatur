package id.fighthunger.donatur.ui.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import id.fighthunger.donatur.data.repository.UserRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

data class HomeUiState(val name: String = "", val error: String? = null)

class HomeViewModel(
    private val repo: UserRepository = UserRepository()
) : ViewModel() {

    private val _state = MutableStateFlow(HomeUiState())
    val state: StateFlow<HomeUiState> = _state

    fun load() {
        viewModelScope.launch {
            val user = repo.current()
            if (user == null) {
                _state.value = HomeUiState(error = "Profile not found")
            } else {
                _state.value = HomeUiState(name = user.username)
            }
        }
    }
}

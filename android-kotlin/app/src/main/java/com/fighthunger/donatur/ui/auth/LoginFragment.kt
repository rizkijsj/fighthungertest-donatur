package id.fighthunger.donatur.ui.auth

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import id.fighthunger.donatur.R
import id.fighthunger.donatur.data.repository.AuthRepository
import id.fighthunger.donatur.databinding.FragmentLoginBinding
import id.fighthunger.donatur.util.PhoneNumberFormatter
import kotlinx.coroutines.launch

class LoginFragment : Fragment() {
    private var _binding: FragmentLoginBinding? = null
    private val binding get() = _binding!!
    private val repo = AuthRepository()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentLoginBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.loginButton.setOnClickListener {
            val phone = PhoneNumberFormatter.format(binding.phoneInput.text.toString())
            if (phone.isBlank()) {
                binding.phoneInput.error = "Required"
                return@setOnClickListener
            }
            lifecycleScope.launch {
                try {
                    if (!repo.phoneExists(phone)) {
                        Toast.makeText(requireContext(), "Phone number is not registered", Toast.LENGTH_SHORT).show()
                        return@launch
                    }
                    repo.requestOtp(
                        requireActivity(),
                        phone,
                        onCode = { verificationId ->
                            val bundle = Bundle().apply {
                                putString("verificationId", verificationId)
                                putBoolean("existing", true)
                            }
                            findNavController().navigate(R.id.otpFragment, bundle)
                        },
                        onError = { e -> Toast.makeText(requireContext(), e.message ?: "OTP failed", Toast.LENGTH_LONG).show() }
                    )
                } catch (e: Exception) {
                    Toast.makeText(requireContext(), e.message ?: "Something went wrong", Toast.LENGTH_LONG).show()
                }
            }
        }

        binding.toRegisterButton.setOnClickListener {
            findNavController().navigate(R.id.registerFragment)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

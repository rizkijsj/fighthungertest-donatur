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
import id.fighthunger.donatur.databinding.FragmentOtpBinding
import kotlinx.coroutines.launch

class OtpFragment : Fragment() {
    private var _binding: FragmentOtpBinding? = null
    private val binding get() = _binding!!
    private val repo = AuthRepository()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentOtpBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.verifyButton.setOnClickListener {
            val verificationId = arguments?.getString("verificationId") ?: ""
            val code = binding.otpInput.text.toString().trim()
            if (code.length < 6) {
                binding.otpInput.error = "Enter 6-digit OTP"
                return@setOnClickListener
            }

            lifecycleScope.launch {
                try {
                    repo.verifyOtp(verificationId, code)
                    if (!(arguments?.getBoolean("existing") ?: true)) {
                        repo.saveProfile(
                            arguments?.getString("email") ?: "",
                            arguments?.getString("name") ?: "",
                            arguments?.getString("phone") ?: ""
                        )
                    }
                    findNavController().navigate(R.id.homeFragment)
                } catch (e: Exception) {
                    Toast.makeText(requireContext(), e.message ?: "Verification failed", Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

package id.fighthunger.donatur.ui.auth

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import id.fighthunger.donatur.R
import id.fighthunger.donatur.data.repository.AuthRepository
import id.fighthunger.donatur.databinding.FragmentRegisterBinding
import id.fighthunger.donatur.util.PhoneNumberFormatter

class RegisterFragment : Fragment() {
    private var _binding: FragmentRegisterBinding? = null
    private val binding get() = _binding!!
    private val repo = AuthRepository()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentRegisterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.registerButton.setOnClickListener {
            val name = binding.nameInput.text.toString().trim()
            val email = binding.emailInput.text.toString().trim()
            val phone = PhoneNumberFormatter.format(binding.phoneInput.text.toString())

            if (name.isBlank() || email.isBlank() || phone.isBlank()) {
                Toast.makeText(requireContext(), "Fill all fields", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            repo.requestOtp(
                requireActivity(),
                phone,
                onCode = { verificationId ->
                    val bundle = Bundle().apply {
                        putString("verificationId", verificationId)
                        putBoolean("existing", false)
                        putString("name", name)
                        putString("email", email)
                        putString("phone", phone)
                    }
                    findNavController().navigate(R.id.otpFragment, bundle)
                },
                onError = { e -> Toast.makeText(requireContext(), e.message ?: "OTP failed", Toast.LENGTH_LONG).show() }
            )
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

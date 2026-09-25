package id.fighthunger.donatur.data.model

data class UserProfile(val uid: String = "", val email: String = "", val phoneNumber: String = "", val username: String = "")

data class OrganizationProfile(
    val id: String = "", val phone: String = "", val email: String = "", val name: String = "",
    val description: String = "", val logo: String = "", val locationName: String = "",
    val latitude: Double = 0.0, val longitude: Double = 0.0, val link: String = ""
)

data class DonationPost(
    val id: String = "", val author: UserProfile = UserProfile(), val communityId: String = "",
    val communityLogo: String = "", val communityName: String = "", val communityPhone: String = "",
    val photoUrl: String = "", val itemName: String = "", val description: String = "",
    val quantity: String = "", val address: String = "", val locationDescription: String = "",
    val latitude: Double = 0.0, val longitude: Double = 0.0, val pickupTime: Double = 0.0,
    val deliveredTime: Double = 0.0, val courierName: String = "", val courierDescription: String = "",
    val timestamp: Double = 0.0, val transactionId: String = "", val status: Int = 1,
    val cancellationReason: String = ""
)

object DonationStatus {
    const val CANCELLED_BY_USER = 0
    const val PENDING = 1
    const val WAITING_FOR_COURIER = 2
    const val PICKUP = 3
    const val DELIVERING = 4
    const val DELIVERED = 5
    const val CANCELLED_BY_ORGANIZATION = 6
    fun label(value: Int) = when (value) {
        0, 6 -> "Dibatalkan"
        1 -> "Menunggu diklaim"
        2 -> "Menunggu data kurir"
        3 -> "Sedang dijemput"
        4 -> "Sedang diantar"
        5 -> "Telah sampai"
        else -> "Tidak diketahui"
    }
}

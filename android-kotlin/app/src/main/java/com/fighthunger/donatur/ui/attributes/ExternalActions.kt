package id.fighthunger.donatur.ui.attributes

import android.app.Activity
import android.content.Intent
import android.net.Uri

object ExternalActions {
    fun openPhone(activity: Activity, phone: String) {
        activity.startActivity(Intent(Intent.ACTION_DIAL, Uri.parse("tel:$phone")))
    }

    fun openWhatsApp(activity: Activity, phone: String) {
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://wa.me/${phone.replace("+", "")}")))
    }

    fun openWebsite(activity: Activity, url: String) {
        val resolved = if (url.startsWith("http")) url else "https://$url"
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(resolved)))
    }
}

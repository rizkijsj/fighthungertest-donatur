package com.fighthunger.donatur.ui.attributes

import android.app.Activity
import android.content.Intent
import android.net.Uri

object ExternalActions {
    fun openPhone(activity: Activity, phone: String) {
        activity.startActivity(Intent(Intent.ACTION_DIAL, Uri.parse("tel:$phone")))
    }

    fun openWhatsApp(activity: Activity, phone: String) {
        val normalized = phone.replace("+", "")
        val url = "https://wa.me/$normalized"
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
    }

    fun openWebsite(activity: Activity, url: String) {
        val resolved = if (url.startsWith("http")) url else "https://$url"
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(resolved)))
    }
}

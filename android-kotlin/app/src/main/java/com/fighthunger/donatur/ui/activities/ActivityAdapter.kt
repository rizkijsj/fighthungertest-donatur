package id.fighthunger.donatur.ui.activities

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import coil.load
import id.fighthunger.donatur.data.model.DonationPost
import id.fighthunger.donatur.data.model.DonationStatus
import id.fighthunger.donatur.databinding.ItemActivityBinding

class ActivityAdapter(private val items: List<DonationPost>) : RecyclerView.Adapter<ActivityAdapter.ActivityViewHolder>() {
    class ActivityViewHolder(private val binding: ItemActivityBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: DonationPost) {
            binding.itemName.text = item.itemName
            binding.statusText.text = DonationStatus.label(item.status)
            binding.itemImage.load(item.photoUrl)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ActivityViewHolder {
        val binding = ItemActivityBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ActivityViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ActivityViewHolder, position: Int) {
        holder.bind(items[position])
    }

    override fun getItemCount(): Int = items.size
}

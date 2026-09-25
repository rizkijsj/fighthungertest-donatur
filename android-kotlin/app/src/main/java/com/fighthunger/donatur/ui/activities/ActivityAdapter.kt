package com.fighthunger.donatur.ui.activities
import android.view.*
import androidx.recyclerview.widget.RecyclerView
import coil.load
import com.fighthunger.donatur.data.model.*
import com.fighthunger.donatur.databinding.ItemActivityBinding
class ActivityAdapter(private val items:List<DonationPost>):RecyclerView.Adapter<ActivityAdapter.H>(){class H(private val b:ItemActivityBinding):RecyclerView.ViewHolder(b.root){fun bind(x:DonationPost){b.itemName.text=x.itemName;b.statusText.text=DonationStatus.label(x.status);b.itemImage.load(x.photoUrl)}};override fun onCreateViewHolder(p:ViewGroup,t:Int)=H(ItemActivityBinding.inflate(LayoutInflater.from(p.context),p,false));override fun onBindViewHolder(h:H,p:Int)=h.bind(items[p]);override fun getItemCount()=items.size}

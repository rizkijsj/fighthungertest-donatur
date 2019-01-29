//
//  KegiatanViewController.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class KegiatanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var fotoDonasi: UIImageView!
    
    @IBOutlet weak var stasus1: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var status4: UIImageView!
    
    @IBOutlet weak var labaelStatus1: UILabel!
    @IBOutlet weak var labelStatus2: UILabel!
    @IBOutlet weak var labelStatus3: UILabel!
    @IBOutlet weak var labelStatus4: UILabel!
    
    @IBOutlet weak var namaOrganisasi: UILabel!
    @IBOutlet weak var nomorTelponOrganisasi: UILabel!
    @IBAction func telponOrganisasi(_ sender: UIButton) {
    }
    
    @IBOutlet weak var namaKurir: UILabel!
    @IBOutlet weak var deskripsiKurir: UILabel!
    
    @IBOutlet weak var namaDonasi: UILabel!
    @IBOutlet weak var deskripsiDonasi: UILabel!
    @IBOutlet weak var jumlahDonasi: UILabel!
    @IBOutlet weak var alamatPengambilan: UILabel!
    @IBOutlet weak var waktuPengambilan: UILabel!
    
    @IBAction func batalkan(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

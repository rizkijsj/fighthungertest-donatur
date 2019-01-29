//
//  CaptureImageTableViewCell.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 29/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class CaptureImageTableViewCell: UITableViewCell,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var fotoDonasi: UIImageView!
    @IBAction func btnLibraryFoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary
        print("ohana")
       
        
        self.present(imagePickerController,animated: true,completion: nil)
    }
    @IBAction func btnKamera(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerController.sourceType = .camera
           
            print("ohayou")
//                self.present(imagePickerController,animated: true,completion: nil)
            
        } else
            
            //using camera in MAC IS NOT AVAILABLE
        {
            print("Camera not available")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        let passingImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        fotoDonasi.image = passingImage
        
        picker.dismiss(animated: true, completion: nil)
        
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

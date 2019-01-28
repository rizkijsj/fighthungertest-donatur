//
//  HomeViewController.swift
//  FightHunger Donatur
//
//  Created by Julianti Cahyadi on 28/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         combined = NSMutableArray(array: [])
    }
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
     var combined : NSMutableArray!
    
    let titleSection = ["Aktivitas","Kegiatan Terbaru","Mitra Kami"]
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
               
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
              
                print("Unhide")
            }, completion: nil)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let viewSection = homeCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectioncell", for: indexPath) as! SectionCollectionReusableView
        
       viewSection.sectionLabel.text = titleSection[indexPath.row]
        
        return viewSection
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return titleSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return (combined.object(at: section)as! NSArray).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "kegiatancell", for: indexPath) as! HomeCollectionViewCell
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0
        {
           
             return CGSize(width: 343, height: 116)
        }
        else if indexPath.section == 1
        {
            return CGSize(width: 343, height: 332)
        }
        else
        {
            return CGSize(width: 343, height: 116)
        }
        
    }
}



//  Filters_Effects_VC.swift
//  PunjabiTok
//  Created by GranzaX on 13/06/21.


import UIKit


class Filters_Effects_VC: UIViewController {
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var lbltitle:UILabel!
    
    var arrFilterTitle = ["Filter","Filter","Filter","Filter","Filter","Filter","Filter",]
    var arrEffectTitle = ["Effect","Effect","Effect","Effect","Effect","Effect","Effect",]
    
    var isFilter = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgIcon.image = isFilter ? UIImage (named: "filter_1.png") : UIImage (named: "effect-1.png")
        lbltitle.text = isFilter ? "FILTER" : "EFFECT"
    }
    
    @IBAction func btnDismiss(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension Filters_Effects_VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return CGSize(
            width:60,
            height:collectionView.frame.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFilter ? arrFilterTitle.count : arrEffectTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! Filters_EffectsCollectionViewCell
        
//        cell.imgIcon.image = isFilter ? UIImage (named:"") : UIImage (named:"")
        cell.lbltitle.text = isFilter ? arrFilterTitle[indexPath.row] : arrEffectTitle[indexPath.row]
        
        return cell
    }
    
}





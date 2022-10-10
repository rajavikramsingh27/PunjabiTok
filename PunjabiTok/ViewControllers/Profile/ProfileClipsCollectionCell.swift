//
//  ProfileCollectionViewCell.swift
//  PunjabiTok
//
//  Created by GranzaX on 29/07/21.
//

import UIKit
import SDWebImage

class ProfileClipsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgThumbnail:UIImageView!
    @IBOutlet weak var btnLike:UIButton!
    @IBOutlet weak var lblCount:UILabel!
    @IBOutlet weak var btnSelect:UIButton!
    
    
    var profileModel:ClipsDetailsModel! {
        didSet {
            imgThumbnail.image = UIImage .gifImageWithURL(profileModel.preview)
            
//            imgThumbnail.sd_setImage(
//                with: URL(string: profileModel.phone_User),
//                placeholderImage: nil
//            )
            btnLike.isSelected = true
            lblCount.text = profileModel.likes_count
        }
    }
    
    override class func awakeFromNib() {
        
    }
    
}

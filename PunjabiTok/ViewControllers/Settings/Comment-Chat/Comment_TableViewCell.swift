//
//  Comment_TableViewCell.swift
//  PunjabiTok
//
//  Created by GranzaX on 27/07/21.
//

import UIKit
import SDWebImage

class Comment_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUser:UIImageView!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblText:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var btnReport:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
    
    var commentModel:CommentModel! {
        
        didSet {
            lblText.text = commentModel.text
            lblUserName.text = commentModel.username_User
            lblTime.text = commentModel.created_at
            imgUser.sd_setImage(with: commentModel.photo_User , placeholderImage: nil)
            
            btnReport.isHidden = commentModel.me_User
            btnDelete.isHidden = !commentModel.me_User
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
}



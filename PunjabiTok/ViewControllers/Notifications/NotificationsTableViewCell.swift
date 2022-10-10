//
//  NotificationsTableViewCell.swift
//  PunjabiTok
//
//  Created by GranzaX on 17/06/21.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var btnProfilePicture:UIButton!
    @IBOutlet weak var btnRightPicture:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnProfilePicture.layer.cornerRadius = btnProfilePicture.frame.height/2
        btnProfilePicture.clipsToBounds = true
        
        btnRightPicture.layer.cornerRadius = 6
        btnRightPicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

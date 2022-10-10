//
//  ProfileModel.swift
//  PunjabiTok
//
//  Created by GranzaX on 29/07/21.
//

import Foundation

class ProfileModel {
    static let shared = ProfileModel()
    
    var id = ""
    var name = ""
    var photo = URL (string: "")
    var username = ""
    var bio = ""
    var verified = ""
    var business = ""
    var links = ""
    var location = ""
    var latitude = ""
    var longitude = ""
    var created_at = ""
    var updated_at = ""
    var followers_count = ""
    var followed_count = ""
    var clips_count = ""
    var likes_count = ""
    var views_count = ""
    var me = ""
    var follower = ""
    var followed = ""
    var blocked = ""
    var blocking = ""
    var email = ""
    var phone = ""
    var redemption_mode = ""
    var redemption_address = ""
    
    
    func setValue(dict:[String:Any]) -> ProfileModel {
        let model = ProfileModel()
                
        model.id = "\(dict["id"] ?? "")"
        model.name = "\(dict["name"] ?? "")"
        model.photo =  URL (string:"\(dict["photo"] ?? "")")
        model.username = "\(dict["username"] ?? "")"
        model.bio = "\(dict["bio"] ?? "")"
        model.verified = "\(dict["verified"] ?? "")"
        model.business = "\(dict["business"] ?? "")"
        model.links = "\(dict["links"] ?? "")"
        model.location = "\(dict["location"] ?? "")"
        model.latitude = "\(dict["latitude"] ?? "")"
        model.longitude = "\(dict["longitude"] ?? "")"
        model.created_at = "\(dict["created_at"] ?? "")"
        model.updated_at = "\(dict["updated_at"] ?? "")"
        model.followers_count = "\(dict["followers_count"] ?? "")"
        model.followed_count = "\(dict["followed_count"] ?? "")"
        model.clips_count = "\(dict["clips_count"] ?? "")"
        model.likes_count = "\(dict["likes_count"] ?? "")"
        model.views_count = "\(dict["views_count"] ?? "")"
        model.me = "\(dict["me"] ?? "")"
        model.follower = "\(dict["follower"] ?? "")"
        model.followed = "\(dict["followed"] ?? "")"
        model.blocked = "\(dict["blocked"] ?? "")"
        model.blocking = "\(dict["blocking"] ?? "")"
        model.email = "\(dict["email"] ?? "")"
        model.phone = "\(dict["phone"] ?? "")"
        model.redemption_mode = "\(dict["redemption_mode"] ?? "")"
        model.redemption_address = "\(dict["redemption_address"] ?? "")"
        
        return model
    }
}

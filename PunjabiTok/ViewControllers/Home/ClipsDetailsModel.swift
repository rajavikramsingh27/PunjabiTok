


//  ProfileModel.swift
//  PunjabiTok
//  Created by GranzaX on 22/07/21.



import Foundation


// MARK: - Welcome
class ClipsDetailsModel {
    static let shared = ClipsDetailsModel()
    
    var id = ""
    var video = ""
    var screenshot = ""
    var preview = ""
    var description = ""
    var language = ""
    var privacy = ""
    var duet = ""
    var comments = ""
    var duration = ""
    var cta_label = ""
    var cta_link = ""
    var location = ""
    var latitude = ""
    var longitude = ""
    var approved = ""
    var states = ""
    var created_at = ""
    var updated_at = ""
    var song = ""
    var sections = ""
    var views_count = ""
    var likes_count = ""
    var comments_count = ""
    var liked = false
    var saved = false
    var hashtags = ""
    var mentions = ""
    
    
    var id_User = ""
    var name_User = ""
    var photo_User = URL (string: "")
    var username_User = ""
    var bio_User = ""
    var verified_User = ""
    var business_User = ""
    var links_User = ""
    var location_User = ""
    var latitude_User = ""
    var longitude_User = ""
    var created_at_User = ""
    var updated_at_User = ""
    var followers_count_User = ""
    var followed_count_User = ""
    var clips_count_User = ""
    var likes_count_User = ""
    var views_count_User = ""
    var me_User = false
    var follower_User = ""
    var followed_User = ""
    var blocked_User = ""
    var blocking_User = ""
    var email_User = ""
    var phone_User = ""
    var redemption_mode_User = ""
    var redemption_address_User = ""
    
    
    
    
    
    
    func setValue(dict:[String:Any]) -> ClipsDetailsModel {
        let model = ClipsDetailsModel()
                
        model.id = "\(dict["id"] ?? "")"
        model.video = "\(dict["video"] ?? "")"
        model.screenshot = "\(dict["screenshot"] ?? "")"
        model.preview = "\(dict["preview"] ?? "")"
        model.description = "\(dict["description"] ?? "")"
        model.language = "\(dict["language"] ?? "")"
        model.privacy = "\(dict["privacy"] ?? "")"
        model.duet = "\(dict["duet"] ?? "")"
        model.comments = "\(dict["comments"] ?? "")"
        model.duration = "\(dict["duration"] ?? "")"
        model.cta_label = "\(dict["cta_label"] ?? "")"
        model.cta_link = "\(dict["cta_link"] ?? "")"
        model.location = "\(dict["location"] ?? "")"
        model.latitude = "\(dict["latitude"] ?? "")"
        model.longitude = "\(dict["longitude"] ?? "")"
        model.approved = "\(dict["approved"] ?? "")"
        model.states = "\(dict["states"] ?? "")"
        model.created_at = "\(dict["created_at"] ?? "")"
        model.updated_at = "\(dict["updated_at"] ?? "")"
        model.song = "\(dict["song"] ?? "")"
        model.sections = "\(dict["sections"] ?? "")"
        model.views_count = "\(dict["views_count"] ?? "")"
        model.likes_count = "\(dict["likes_count"] ?? "")"
        model.comments_count = "\(dict["comments_count"] ?? "")"
        model.liked = dict["liked"] as? Bool ?? false
        model.saved = dict["saved"] as? Bool ?? false
        model.hashtags = "\(dict["hashtags"] ?? "")"
        model.mentions = "\(dict["mentions"] ?? "")"
        
        if let dictUser = dict["user"] as? [String:Any] {
//        if let dictUser = "\(dict["user"] ?? "")".anyConvertToDictionary() {
            
            debugPrint(dictUser)
            
            model.id_User = "\(dictUser["id"] ?? "")"
            model.name_User = "\(dictUser["name"] ?? "")"
            model.photo_User = URL (string: "\(dictUser["photo"] ?? "")")
            model.username_User = "\(dictUser["username"] ?? "")"
            model.bio_User = "\(dictUser["bio"] ?? "")"
            model.verified_User = "\(dictUser["verified"] ?? "")"
            model.business_User = "\(dictUser["business"] ?? "")"
            model.links_User = "\(dictUser["links"] ?? "")"
            model.location_User = "\(dictUser["location"] ?? "")"
            model.latitude_User = "\(dictUser["latitude"] ?? "")"
            model.longitude_User = "\(dictUser["longitude"] ?? "")"
            model.created_at_User = "\(dictUser["created_at"] ?? "")"
            model.updated_at_User = "\(dictUser["updated_at"] ?? "")"
            model.followers_count_User = "\(dictUser["followers_count"] ?? "")"
            model.followed_count_User = "\(dictUser["followed_count"] ?? "")"
            model.clips_count_User = "\(dictUser["clips_count"] ?? "")"
            model.likes_count_User = "\(dictUser["likes_count"] ?? "")"
            model.views_count_User = "\(dictUser["views_count"] ?? "")"
            model.me_User = dictUser["me"] as? Bool ?? false
            model.follower_User = "\(dictUser["follower"] ?? "")"
            model.followed_User = "\(dictUser["followed"] ?? "")"
            model.blocked_User = "\(dictUser["blocked"] ?? "")"
            model.blocking_User = "\(dictUser["blocking"] ?? "")"
            model.email_User = "\(dictUser["email"] ?? "")"
            model.phone_User = "\(dictUser["phone"] ?? "")"
            model.redemption_mode_User = "\(dictUser["redemption_mode"] ?? "")"
            model.redemption_address_User = "\(dictUser["redemption_address"] ?? "")"
        }
        
        return model
    }
    
}


//
//  EditPresenter.swift
//  PunjabiTok
//
//  Created by GranzaX on 23/07/21.
//

import Foundation
import MBProgressHUD
import SwiftMessageBar
import Alamofire
import SDWebImage

class EditProfilePresenter {
    static let shared = EditProfilePresenter()
    
    class func setUIData(_ vc: EditProfile_ViewController, _ profileModel:ProfileModel) {
        vc.imgProfilePicture.sd_setImage(
            with: profileModel.photo,
            placeholderImage: nil
        )
        
        vc.arrTextFields[0].text = "location"
        vc.arrTextFields[1].text = profileModel.name
        vc.arrTextFields[2].text = profileModel.username
        vc.arrTextFields[3].text = profileModel.email
        vc.arrTextFields[4].text = profileModel.phone
        vc.txtViewBio.text = profileModel.bio
    }
    
    class func profileUpdate_WithImage( _ vc:EditProfile_ViewController, _ image:UIImage) {
        
        let param = [
            "location":vc.arrTextFields[0].text!,
            "name":vc.arrTextFields[1].text!,
            "username":vc.arrTextFields[2].text!,
            "email":vc.arrTextFields[3].text!,
            "phone":vc.arrTextFields[4].text!,
            "bio":vc.txtViewBio.text!,
            "latitude":"26.91240000",
            "longitude":"75.78730000",
        ]
        
        debugPrint(param)
        
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
        API_Service.postAPI_Image(
            "profile",
            image.jpegData(compressionQuality: 0.2),
            param, "photo") { (json) in
            debugPrint(json)
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: vc.view, animated: true)
                
                if let thisMeansSuccess = json.dictionary!["status"] {
                    SwiftMessageBar.showMessage(
                        withTitle: "Profile Updated!",
                        message:"Profile updated successfully.",
                        type:.success
                    )
                } else if let dictError = json.dictionary!["errors"] {
                    for (key, value) in dictError {
                        debugPrint(key)
                        
                        if let valueError = value.array {
                            debugPrint(valueError)
                            
                            SwiftMessageBar.showMessage(
                                withTitle: "Error!",
                                message: (valueError.count>0) ? "\(valueError[0])" : "Error in submitted Params / Fields",
                                type:.error
                            )
                        }
                    }
                } else {
                    SwiftMessageBar.showMessage(
                        withTitle: "Error!",
                        message:"Something went wrong! \n Please check your API Calling Process.",
                        type:.error
                    )
                }
            }
            
        }
        
    }
        
    class func profileUpdate_WithOutImage( _ vc:EditProfile_ViewController) {
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
        let param = [
//            "photo":"",
            "location":vc.arrTextFields[0].text!,
            "name":vc.arrTextFields[1].text!,
            "username":vc.arrTextFields[2].text!,
            "email":vc.arrTextFields[3].text!,
            "phone":vc.arrTextFields[4].text!,
            "bio":vc.txtViewBio.text!,
            "latitude":"26.91240000",
            "longitude":"75.78730000",
        ]
        
        debugPrint(param)
        
        let loginUserToken = UserDefaults.standard.value(forKey: kToken) as! String
        
        let httpHeaders:HTTPHeaders = [
//            "Content-type": "multipart/form-data",
            "Authorization": "Bearer \(loginUserToken)",
            "Accept": "application/json"
        ]
        
        debugPrint(httpHeaders)
        
        API_Service.api("profile", param, httpHeaders, HTTPMethod.post) { (json) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: vc.view, animated: true)
                
                if let thisMeansSuccess = json.dictionary!["status"] {
                    SwiftMessageBar.showMessage(
                        withTitle: "Profile Updated!",
                        message:"Profile updated successfully.",
                        type:.success
                    )
                } else if let dictError = json.dictionary!["errors"] {
                    for (key, value) in dictError {
                        debugPrint(key)
                        
                        if let valueError = value.array {
                            debugPrint(valueError)
                            
                            SwiftMessageBar.showMessage(
                                withTitle: "Error!",
                                message: (valueError.count>0) ? "\(valueError[0])" : "Error in submitted Params / Fields",
                                type:.error
                            )
                        }
                    }
                } else {
                    SwiftMessageBar.showMessage(
                        withTitle: "Error!",
                        message:"Something went wrong! \n Please check your API Calling Process.",
                        type:.error
                    )
                }
            }
            
        }
        
    }
    
    class func profilePhotoDelete( _ vc:EditProfile_ViewController) {
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
        let loginUserToken = UserDefaults.standard.value(forKey: kToken) as! String
        
        let httpHeaders:HTTPHeaders = [
            "Authorization": "Bearer \(loginUserToken)",
            "Accept": "application/json"
        ]
        
        debugPrint(httpHeaders)
        
        API_Service.api("profile/photo", [:], httpHeaders, HTTPMethod.delete) { (json) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: vc.view, animated: true)
                
                if let thisMeansSuccess = json.dictionary!["status"] {
                    SwiftMessageBar.showMessage(
                        withTitle: "Profile Deleted!",
                        message:"Profile deleted successfully.",
                        type:.success
                    )
                } else if let dictError = json.dictionary!["errors"] {
                    for (key, value) in dictError {
                        debugPrint(key)
                        
                        if let valueError = value.array {
                            debugPrint(valueError)
                            
                            SwiftMessageBar.showMessage(
                                withTitle: "Error!",
                                message: (valueError.count>0) ? "\(valueError[0])" : "Error in submitted Params / Fields",
                                type:.error
                            )
                        }
                    }
                } else {
                    SwiftMessageBar.showMessage(
                        withTitle: "Error!",
                        message:"Something went wrong! \n Please check your API Calling Process.",
                        type:.error
                    )
                }
            }
            
        }
        
    }

    
}

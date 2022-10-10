//
//  ForYouPresenter.swift
//  PunjabiTok
//
//  Created by GranzaX on 26/07/21.
//

import Foundation
import UIKit
import MBProgressHUD
import SwiftMessageBar
import Alamofire

protocol ForYouDelegate {
    func likeUnlike_Update(_ like_Or_dislike:Bool)
    func savedUnSaved_Update( _ save_Or_UnSave:Bool)
    
    func updateClips()
    func deleteClips()
}


class ForYouPresenter {
    
//    static let shared = ForYouPresenter()
    
    var viewController:UIViewController!
    var delegate:ForYouDelegate!
    var indexSelected = Int()
    var arrClipsDetailsModel = [ClipsDetailsModel]()
    var isRefresh = false

    
//    loginPresenter.delegate = self ==> attachView work like this
    func attachView(_ viewController:UIViewController, _ view:ForYouDelegate) {
        self.viewController = viewController
        delegate = view
    }
    
    func like_Save_Videos(_ clipID:String, _ endURL_LikedSaved:String, _ is_Liked_Saved:Bool) {
        if let loginUserToken = UserDefaults.standard.value(forKey: kToken) as? String {
            let httpHeaders:HTTPHeaders = [
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json"
            ]
            debugPrint(httpHeaders)
            
            debugPrint(is_Liked_Saved ? HTTPMethod.delete : HTTPMethod.post)
            
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
            API_Service.api("clips/\(clipID)/\(endURL_LikedSaved)", [:], httpHeaders,
                            is_Liked_Saved ? HTTPMethod.delete : HTTPMethod.post
            ) { (json) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.viewController.view, animated: true)
                    
                    debugPrint("jsonjsonjson",json)
                    
                    if ("\(json["status"])" == "failed") {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:"\(json["message"])",
                            type:.error
                        )
                    } else {
                        (endURL_LikedSaved == "likes")
                            ? self.delegate.likeUnlike_Update(is_Liked_Saved ? false : true)
                            : self.delegate.savedUnSaved_Update(is_Liked_Saved ? false : true)
                    }
                }
                
            }            
        } else {
//            let storyBoard = UIStoryboard (name: "Main", bundle: nil)
            let loginVC = self.viewController.storyboard?.instantiateViewController(
                withIdentifier: "LoginViewController"
            ) as! LoginViewController
            
            self.viewController.present(loginVC, animated: true, completion: nil)
        }
        
    }
    
    func clips(_ param:[String:Any]) {
        self.arrClipsDetailsModel.removeAll()
//        debugPrint(param)
        
        MBProgressHUD.showAdded(to:viewController.view, animated:true)
        
        var dictHeaders = [String:String]()
        
        if let strToken = UserDefaults.standard.value(forKey: kToken) as? String {
            dictHeaders["Authorization"] = "Bearer \(strToken)"
            dictHeaders["Accept"] = "application/json"
        }
        
//        debugPrint("dictHeadersdictHeadersdictHeadersdictHeadersdictHeaders")
//        debugPrint(dictHeaders)
        
        API_Service.api("clips", param, dictHeaders, HTTPMethod.get) { (json) in
            debugPrint(json)
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for:self.viewController.view, animated:true)
//                debugPrint(json.dictionaryObject!)
                
                if let arrData = json.dictionaryObject!["data"] as? [[String:Any]] {
//                    debugPrint(arrData)
                    
                    var arrClipsData = [ClipsDetailsModel]()
                    
                    for dictData in arrData {
                        debugPrint(dictData)
                        
                        let modelGet = ClipsDetailsModel.shared.setValue(dict: dictData)
                        arrClipsData.append(modelGet)
                    }
                    
                    self.arrClipsDetailsModel = self.isRefresh ? self.arrClipsDetailsModel+arrClipsData : arrClipsData
                    self.delegate?.updateClips()
                }
            }
        }
        
    }
    
    func clipsDelete(_ clipID:String) {
        
        MBProgressHUD.showAdded(to:viewController.view, animated:true)
        
        var dictHeaders = [String:String]()
        
        if let strToken = UserDefaults.standard.value(forKey: kToken) as? String {
            dictHeaders["Authorization"] = "Bearer \(strToken)"
            dictHeaders["Accept"] = "application/json"
        }
        
        let param = ["id":clipID]
        API_Service.api("clips/\(clipID)", param, dictHeaders, HTTPMethod.delete) { (json) in
            debugPrint(json)
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for:self.viewController.view, animated:true)                
                debugPrint("jsonjsonjson",json)
                
                if ("\(json["status"])" == "failed") {
                    SwiftMessageBar.showMessage(
                        withTitle: "Error!",
                        message:"\(json["message"])",
                        type:.error
                    )
                } else {
                    self.delegate?.deleteClips()
                }
                
            }
        }
        
    }
}






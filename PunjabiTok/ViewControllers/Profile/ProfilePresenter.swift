
//  PresenterProfile.swift
//  PunjabiTok

//  Created by GranzaX on 22/07/21.



import Foundation
import FirebaseAuth
import MBProgressHUD
import SwiftMessageBar
import Alamofire


protocol ProfilePresenterDelegate {
    func updateProfileData()
    func updateClips()
}

class ProfilePresenter {
    var delegate:ProfilePresenterDelegate?
    var vc:UIViewController!
    var profileModel:ProfileModel!
    var arrClipsDetailsModel = [ClipsDetailsModel]()
    
//    loginPresenter.delegate = self ==> attachView work like this
    func attachView(_ vc:UIViewController, _ view: ProfilePresenterDelegate) {
        self.vc = vc
        delegate = view
    }
    
    func profile() {
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
        let loginUserToken = UserDefaults.standard.value(forKey: kToken) as! String
        debugPrint(loginUserToken)
        
        let httpHeaders:HTTPHeaders = [
            "Authorization": "Bearer \(loginUserToken)",
            "Accept": "application/json"
        ]
        
        debugPrint(httpHeaders)
        
        API_Service.api("profile", [:], httpHeaders, HTTPMethod.get) { (json) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.vc.view, animated: true)
                
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
                    
                }
            }
            
        }
        
    }
    
    func clips(_ viewController:UIViewController,_ param:[String:Any]) {
        self.arrClipsDetailsModel.removeAll()
        print(param)

        MBProgressHUD.showAdded(to:viewController.view, animated:true)

        var dictHeaders = [String:String]()

        if let strToken = UserDefaults.standard.value(forKey: kToken) as? String {
            dictHeaders["Authorization"] = "Bearer \(strToken)"
            dictHeaders["Accept"] = "application/json"
        }

        debugPrint("dictHeadersdictHeadersdictHeadersdictHeadersdictHeaders")
        debugPrint(dictHeaders)

        API_Service.api("clips", param, dictHeaders, HTTPMethod.get) { (json) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for:viewController.view, animated:true)
                debugPrint(json.dictionaryObject!)

                if let arrData = json.dictionaryObject!["data"] as? [[String:Any]] {
                    for dictData in arrData {
                        self.arrClipsDetailsModel.append(ClipsDetailsModel.shared.setValue(dict: dictData))
                    }

                    self.delegate?.updateClips()
                }
            }
        }
        
    }
    
}






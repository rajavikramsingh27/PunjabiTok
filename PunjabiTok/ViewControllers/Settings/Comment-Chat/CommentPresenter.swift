

//  CommentPresenter.swift
//  PunjabiTok
//  Created by GranzaX on 27/07/21.


import Foundation
import UIKit
import Alamofire
import MBProgressHUD
import SwiftMessageBar


protocol CommentDelegate {
    func updateTableView(_ arrCommentModel:[CommentModel])
}

class CommentPresenter {
    static let shared = CommentPresenter()
    var viewController:UIViewController!
    var arrCommentModel:[CommentModel]!
    
    var delegate:CommentDelegate!
        
    func attach(_ viewController:UIViewController, _ view:CommentDelegate) {
        self.viewController = viewController
        self.delegate = view
    }
    
    func getComments(_ clipID:String, _ page:Int) {
        let param = [
            "id":clipID,
            "page":page
        ] as [String : Any]
        debugPrint(param)
        
        if let loginUserToken = UserDefaults.standard.value(forKey: kToken) as? String {
            
            let httpHeaders:HTTPHeaders = [
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json"
            ]
            debugPrint(httpHeaders)
            
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
            API_Service.api("clips/\(clipID)/comments", param, httpHeaders, HTTPMethod.get) { (json) in
                debugPrint(json)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.viewController.view, animated: true)
                    
                    if ("\(json["status"])" == "failed") {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:"\(json["message"])",
                            type:.error
                        )
                    } else {
                        if let arrData = json["data"].array {
                            self.arrCommentModel = [CommentModel]()
                            
                            for dictData in arrData {
                                self.arrCommentModel.append(
                                    CommentModel.shared.setValue(dictData.dictionary!)
                                )
                            }
                            
                            self.delegate.updateTableView(self.arrCommentModel)
                        }
                    }
                }
            }
        }

    }
    
    func deleteComments(_ clipID:String, _ commentID:Int) {
        let param = [
            "id1":clipID,
            "id2":commentID
        ] as [String : Any]
        debugPrint(param)
        
        if let loginUserToken = UserDefaults.standard.value(forKey: kToken) as? String {
            
            let httpHeaders:HTTPHeaders = [
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json"
            ]
            debugPrint(httpHeaders)
            
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
            API_Service.api("clips/\(clipID)/comments/\(commentID)", param, httpHeaders, HTTPMethod.delete) { (json) in
                debugPrint(json)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.viewController.view, animated: true)
                    
                    if ("\(json["status"])" == "failed") {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:"\(json["message"])",
                            type:.error
                        )
                    } else {
                        self.getComments(clipID, 1)
                    }
                }
            }
        }

    }
    
    func createComments(_ clipID:String, _ text:String) {
        let param = [
            "id":clipID,
            "text":text
        ] as [String : Any]
        debugPrint(param)
        
        if let loginUserToken = UserDefaults.standard.value(forKey: kToken) as? String {
            
            let httpHeaders:HTTPHeaders = [
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json"
            ]
            debugPrint(httpHeaders)
            
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
            API_Service.api("clips/\(clipID)/comments", param, httpHeaders, HTTPMethod.post) { (json) in
                debugPrint(json)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.viewController.view, animated: true)
                    
                    if ("\(json["status"])" == "failed") {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:"\(json["message"])",
                            type:.error
                        )
                    } else {
                        if let _ = json["data"].dictionary {
                            self.getComments(clipID, 1)
                        }
                    }
                }
            }
        }

    }
    
}

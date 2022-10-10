//
//  ReportPresenter.swift
//  PunjabiTok
//
//  Created by GranzaX on 27/07/21.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import SwiftMessageBar


class ReportPresenter {
    static let shared = ReportPresenter()
    
    var viewController:UIViewController!
    
    func attach(_ viewController:UIViewController) {
        self.viewController = viewController
    }
    
    func report(_ subject_type:String, _ subject_id:Int, _ reason:String, _ message:String) {
        let param = [
            "subject_type":subject_type,
            "subject_id":subject_id,
            "reason":reason,
            "message":message,
        ] as [String : Any]
        debugPrint(param)
        
        if let loginUserToken = UserDefaults.standard.value(forKey: kToken) as? String {
            
            let httpHeaders:HTTPHeaders = [
                "Authorization": "Bearer \(loginUserToken)",
//                "Accept": "application/json"
            ]
            debugPrint(httpHeaders)
            
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
            API_Service.api("reports", param, httpHeaders, HTTPMethod.post) { (json) in
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
                        SwiftMessageBar.showMessage(
                            withTitle: "Report!",
                            message:"Reported Sucessfully",
                            type:.success
                        )
                        
                        self.viewController.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }

    }
    
}


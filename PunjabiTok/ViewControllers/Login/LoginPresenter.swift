


//  File.swift
//  PunjabiTok
//  Created by GranzaX on 20/06/21.



import Foundation
import FirebaseAuth
import MBProgressHUD
import SwiftMessageBar
import Alamofire

protocol LoginPresenterDelegate {
    func fireBaseRequestOTP()
    func login_Sucess()
}

class LoginPresenter {
    var delegate:LoginPresenterDelegate?
    var viewController:UIViewController!
    
    var strVerification:String!
    var strFireBaseVerified_Token:String!
    
    
//    loginPresenter.delegate = self ==> attachView work like this
    func attachView(_ viewController:UIViewController, _ view: LoginPresenterDelegate) {
        self.viewController = viewController
        delegate = view
    }
    
    func fireBaseRequestOTP(_ phoneNumber:String) {
        MBProgressHUD.showAdded(to:viewController.view, animated: true)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for:self.viewController.view, animated: true)
                if let error = error {
                    DispatchQueue.main.async {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:error.localizedDescription,
                            type:.error
                        )
                    }
                } else {
                    self.strVerification = verificationID
                    self.delegate?.fireBaseRequestOTP()
                }
            }
        }
        
    }
    
    func firebaseOTP_Verifiction(_ otp:String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID:strVerification,
            verificationCode:otp
        )
        
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for:self.viewController.view, animated: true)
                
                if let error = error {
                    DispatchQueue.main.async {
                        SwiftMessageBar.showMessage(
                            withTitle: "Error!",
                            message:error.localizedDescription,
                            type:.error
                        )
                    }
                } else {
                    authResult?.user.getIDToken(completion: { (token, error) in
                        if let error = error {
                            DispatchQueue.main.async {
                                SwiftMessageBar.showMessage(
                                    withTitle: "Error!",
                                    message:error.localizedDescription,
                                    type:.error
                                )
                            }
                        } else {
                            self.strFireBaseVerified_Token = token
                            
                            self.login_firebase()
        //                    self.delegate?.firebaseOTP_Verifiction("")
                        }
                    })
                }
            }
        }
        
    }
    
    func login_firebase() {        
        let param = [
            "token":strFireBaseVerified_Token!,
//            "referrer":"null"
        ] as [String : Any]
        debugPrint(param)
        
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
        API_Service.api("login/firebase", param, [:], HTTPMethod.post) { (json) in
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
                    UserDefaults.standard.set("\(json[kToken])", forKey: kToken)
                    self.delegate?.login_Sucess()
                }
            }
        }
    }
    
    func login_google(_ socialType:String) {
        let param = [
            "token":strFireBaseVerified_Token!,
        ] as [String : Any]
        debugPrint(param)
        
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
        API_Service.api("login/\(socialType)" ,param ,[:], HTTPMethod.post) { (json) in
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
                    UserDefaults.standard.set("\(json[kToken])", forKey: kToken)
                    self.delegate?.login_Sucess()
                }
            }
            
        }
    }
    
}



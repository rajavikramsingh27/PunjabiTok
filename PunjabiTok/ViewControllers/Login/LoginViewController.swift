

//  LoginViewController.swift
//  PunjabiTok
//  Created by GranzaX on 06/06/21.


import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import SwiftMessageBar
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var viewLogin:UIView!
        
    let fbLoginManager : LoginManager = LoginManager()
    let loginPresenter = LoginPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor.clear
        viewLogin.roundTop(13)
        
        loginPresenter.attachView(self,self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnHideLoginView(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSMS(_ sender:UIButton) {
        DispatchQueue.main.asyncAfter(deadline:.now()+1) {
            let login_Mobile_VC = self.storyboard?.instantiateViewController(
                withIdentifier: "Login_Mobile_ViewController"
            ) as! Login_Mobile_ViewController
            
            self.present(login_Mobile_VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnGoogle(_ sender:UIButton) {
//        GIDSignIn.sharedInstance().presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnFacebook(_ sender:UIButton) {
//        func_facebook()
    }
    
}



//extension LoginViewController:GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//
//        if let error = error {
//            debugPrint(error.localizedDescription)
//            return
//        }
//
//        let _ = user.userID
//        let _ = user.profile.name
//        let _ = user.profile.givenName
//        let _ = user.profile.familyName
//        let _ = user.profile.email
//
//        debugPrint(user.authentication.idToken ?? "");
//        debugPrint(user.authentication.accessToken ?? "");
//        debugPrint(user.authentication.refreshToken ?? "");
//
//        guard let email = user.profile.email else { return }
//
//        guard let authentication = user.authentication else { return }
//
//        let credential = GoogleAuthProvider.credential(
//            withIDToken: authentication.idToken,
//            accessToken: authentication.accessToken
//        )
//
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                DispatchQueue.main.async {
//                    SwiftMessageBar.showMessage(
//                        withTitle: "Error!",
//                        message:error.localizedDescription,
//                        type:.error
//                    )
//                }
//            } else {
//                authResult?.user.getIDToken(completion: { (token, error) in
//                    debugPrint(token)
//
//                    if let error = error {
//                        DispatchQueue.main.async {
//                            SwiftMessageBar.showMessage(
//                                withTitle: "Error!",
//                                message:error.localizedDescription,
//                                type:.error
//                            )
//                        }
//                    } else {
////                        self.strFireBaseVerified_Token = token
////
////                        self.login_firebase()
//    //                    self.delegate?.firebaseOTP_Verifiction("")
//                    }
//                })
//            }
//
//        }
//
//        user.authentication.getTokensWithHandler { (googleAuth, error) in
//            debugPrint(googleAuth?.idToken);
//            debugPrint(googleAuth?.accessToken);
//            debugPrint(googleAuth?.refreshToken);
//        }
//
//
////        loginPresenter.strFireBaseVerified_Token = user.authentication.idToken
////        loginPresenter.login_google("google")
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            debugPrint(error.localizedDescription)
//            return
//        }
//    }
//
//}



extension LoginViewController {
//    func func_facebook() {
//
//        let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: [:], httpMethod: .delete)
//        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
//            print("the delete permission is \(result)")
//        })
////        fbLoginManager.loginBehavior = .web
////        fbLoginManager.loginBehavior = .systemAccount
//
//
//        fbLoginManager.logIn(permissions: ["email"], viewController: self) { (result) in
//
//            DispatchQueue.main.async {
////                if (error == nil) {
//
//                let fbloginresult : LoginManagerLoginResult = result
//                    if (result.isCancelled)!{
//                        return
//                    }
////                    else if(fbloginresult.grantedPermissions.contains("email")) {
////                        fbloginresult.token.tokenString
////                        self.getFBUserData()
////                        self.fbLoginManager.logOut()
////                    }
//                    else {
//                        self.loginPresenter.strFireBaseVerified_Token = fbloginresult.token?.tokenString
//                        self.loginPresenter.login_google("facebook")
//                    }
////                }
//            }
//
//        }
//
//    }

//    func getFBUserData() {
//        if((AccessToken.current) != nil) {
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {
//                (connection, result, error) -> Void in
//                DispatchQueue.main.async {
//                    if (error == nil) {
//                        let resultJson : NSDictionary = result as! NSDictionary
//                        print(resultJson)
//
//                        let socialID = "\(resultJson["id"] ?? "")"
//                        let email = "\(resultJson["email"] ?? "")"
//
////                        let name = "\(resultJson["name"]!)"
//                        let first_name = "\(resultJson["first_name"] ?? "")"
//                        let last_name = "\(resultJson["last_name"] ?? "")"
//
//                        let imageDict : NSDictionary = resultJson["picture"] as! NSDictionary
//                        let dataOne : NSDictionary = imageDict["data"] as! NSDictionary
//                        let imageUrl = "\(dataOne["url"]!)"
//                    } else {
//
//                    }
//                }
//            })
//        }
//    }
    
}

extension LoginViewController:LoginPresenterDelegate {
    func fireBaseRequestOTP() {
        
    }
    
    func login_Sucess() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}



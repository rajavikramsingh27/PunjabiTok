

//  AppDelegate.swift
//  PunjabiTok
//  Created by GranzaX on 31/05/21.


import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import Firebase

//Name:PunjabiTok APNS
//Key ID:KG5X6SKN5D
//Services:Apple Push Notifications service (APNs)


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
        
        IQKeyboardManager.shared.enable = true
                
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
        return handled
    }
    
}



//email:
//    recipients:
//      - rajavikramsingh27@gmail.com
//      - granzax@gmail.com
//    notify:
//      success: true
//      failure: true
//slack:
//    channel: '#builds'
//    notify_on_build_start: true    # To receive a notification when a build starts
//    notify:
//      success: false               # To not receive a notification when a build succeeds
//      failure: false               # To not receive a notification when a build fails





//video (Multipart Body),
//screenshot (Multipart Body),
//preview (Multipart Body) 
//song (Request Body),
//description (Request Body),
//language (Request Body),
//private (Request Body),
//comments (Request Body),
//duet (Request Body),
//duration (Request Body),
//cta_label(Request Body),
//cta_link(Request Body),
//location (Request Body),
//latitude (Request Body),
//longitude (Request Body)



//video:
//screenshot:
//preview:
//song:
//description:
//language:
//private:
//comments:
//duet:
//duration:
//cta_label:
//cta_link:
//location:
//latitude:
//longitude:

//id:
//description:
//language:
//private:
//comments:
//duet:
//cta_label:
//cta_link:
//location:
//latitude:
//longitude:

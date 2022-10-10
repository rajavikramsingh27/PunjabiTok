//
//  SettingsViewController.swift
//  PunjabiTok
//
//  Created by GranzaX on 17/06/21.
//

import UIKit

class SettingsViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    @IBAction func btnLogOut(_ sender:UIButton) {
        let alert = UIAlertController (title: "Are you sure ?",
                                       message: "Do you want to log out ?",
                                       preferredStyle: .actionSheet
        )
        
        alert.view.tintColor = UIColor.black
        let logOut = UIAlertAction (title: "Log Out", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: kToken)
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyBoard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            let navRootView = UINavigationController(rootViewController: tabbarVC)
            navRootView .setNavigationBarHidden(true, animated: false)
            
            UIApplication.shared.windows.first?.rootViewController = navRootView
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
        let cancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(logOut)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}



//  FollowingViewController.swift
//  PunjabiTok
//  Created by GranzaX on 12/06/21.


import UIKit


class FollowingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as! LoginViewController
        
        self.present(loginVC, animated: true, completion: nil)
    }
    
}


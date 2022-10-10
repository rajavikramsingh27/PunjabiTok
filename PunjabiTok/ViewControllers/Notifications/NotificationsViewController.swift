//
//  NotificationsViewController.swift
//  PunjabiTok
//
//  Created by GranzaX on 16/06/21.
//

import UIKit

class NotificationsViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnChat(_ sender:UIButton) {
        let commentChat_VC = storyboard?.instantiateViewController(withIdentifier: "Comment_Chat_VC") as! Comment_Chat_VC
        commentChat_VC.isMyProfile = false
        
        navigationController?.pushViewController(commentChat_VC, animated: true)
    }
    
}




extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource {
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    } */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! NotificationsTableViewCell
        
        let cellBGView = UIView()
        cellBGView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = cellBGView
        
        cell.btnRightPicture.tag = indexPath.row
        cell.btnProfilePicture.tag = indexPath.row
        
        cell.btnRightPicture.addTarget(self, action: #selector(btnRightPicture(_:)), for: .touchUpInside)
        cell.btnProfilePicture.addTarget(self, action: #selector(btnProfilePicture(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
    }
    
    @IBAction func btnRightPicture(_ sender:UIButton) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.isMyProfile = false
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func btnProfilePicture(_ sender:UIButton) {
        let forYou_VC = storyboard?.instantiateViewController(withIdentifier: "ForYouViewController") as! ForYouViewController
        forYou_VC.isMyProfile = false
        
        navigationController?.pushViewController(forYou_VC, animated: true)
    }
    
}



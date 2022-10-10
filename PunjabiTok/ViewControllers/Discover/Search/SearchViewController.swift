


//  SearchViewController.swift
//  PunjabiTok
//  Created by GranzaX on 16/06/21.


import UIKit


class SearchViewController: UIViewController {
    @IBOutlet weak var view_BottomLine_Users:UIView!
    @IBOutlet weak var view_BottomLine_Hashtags:UIView!
    
    @IBOutlet weak var tblSearch:UITableView!
    
    var isMyProfile = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let btnSelect = UIButton()
        btnSelect.tag = 0
        btn_Users_Hashtags(btnSelect)
    }
    
    @IBAction func btn_Users_Hashtags(_ sender:UIButton) {
        view_BottomLine_Users.backgroundColor = (sender.tag == 1) ? UIColor.clear : UIColor("307A8D")
        view_BottomLine_Hashtags.backgroundColor = (sender.tag == 0) ? UIColor.clear : UIColor("307A8D")
        
        tblSearch.reloadData()
    }
    
//    307A8D
}




extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    } */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (view_BottomLine_Users.backgroundColor != UIColor.clear) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell-Users", for: indexPath)
            
            let cellBGView = UIView()
            cellBGView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = cellBGView
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell-Hashtags", for: indexPath)
            
            let cellBGView = UIView()
            cellBGView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = cellBGView
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
        
        if (view_BottomLine_Users.backgroundColor != UIColor.clear) {
            pushToVC("Main", "ProfileViewController", true)
        } else {
            pushToVC("Main", "_TagViewController", true)
        }
    }
    
}



//
//  DiscoverViewController.swift
//  PunjabiTok
//
//  Created by GranzaX on 16/06/21.
//

import UIKit

class DiscoverViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnSearch(_ sender:UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.isMyProfile = false
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}



extension DiscoverViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        
        return CGSize(
            width:height,
            height:height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelect(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @IBAction func btnSelect(_ sender:UIButton) {
        let forYouVC = storyboard?.instantiateViewController(withIdentifier: "ForYouViewController") as! ForYouViewController
        forYouVC.isMyProfile = false
        
        navigationController?.pushViewController(forYouVC, animated: true)
    }
    
}



extension DiscoverViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 194
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        
        let cellBGView = UIView()
        cellBGView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = cellBGView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
    }
    
}



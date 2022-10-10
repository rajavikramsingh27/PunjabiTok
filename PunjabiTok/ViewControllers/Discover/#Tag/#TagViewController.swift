//
//  #TagViewController.swift
//  PunjabiTok
//
//  Created by GranzaX on 16/06/21.
//

import UIKit

class _TagViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}



extension _TagViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/3-6
        
        return CGSize(
            width:width,
            height:width
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
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

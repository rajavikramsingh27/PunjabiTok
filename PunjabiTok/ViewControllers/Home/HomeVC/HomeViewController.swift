

//  PageViewController.swift
//  PunjabiTok
//  Created by GranzaX on 12/06/21.


import UIKit


class HomeViewController: UIViewController {
    @IBOutlet weak var view_BottomLine_Following:UIView!
    @IBOutlet weak var view_BottomLine_ForYou:UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    var tutorialPageViewController: HomePageVC? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnForYou = UIButton()
        btnForYou.tag = 1
        btn_Following_ForYou(btnForYou)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? HomePageVC {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    
    @objc func didChangePageControlValue() {
        
    }
    
    @IBAction func btn_Following_ForYou(_ sender:UIButton) {
        view_BottomLine_Following.backgroundColor = (sender.tag == 1) ? UIColor.clear : UIColor.white
        view_BottomLine_ForYou.backgroundColor = (sender.tag == 0) ? UIColor.clear : UIColor.white
        
        let dictUserInfo = ["tag":sender.tag]
        
        NotificationCenter.default.post(
            name: NSNotification.Name("updatePage"),
            object: nil,
            userInfo: dictUserInfo
        )
    }
    
}

extension HomeViewController: HomePageVCDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: HomePageVC,
        didUpdatePageCount count: Int) {
    }
    
    func tutorialPageViewController(tutorialPageViewController: HomePageVC,
        didUpdatePageIndex index: Int) {
    }
    
}



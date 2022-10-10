//
//  TabbarViewController.swift
//  PunjabiTok
//
//  Created by GranzaX on 31/05/21.
//

import UIKit

class TabbarViewController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
                
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height:32))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height-bottomSafeAreaHeight
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame

//        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        self.view.addSubview(menuButton)
        
        menuButton.setBackgroundImage(UIImage(named: "videoCameraWhite"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(_:)), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        //        self.selectedIndex = 2
        pushToVC(kMainStoryBoard, "CameraViewController", true)
    }

}





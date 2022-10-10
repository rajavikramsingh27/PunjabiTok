

//  EditProfile_ViewController.swift
//  PunjabiTok
//  Created by GranzaX on 18/06/21.


import UIKit
import SDWebImage
import SwiftMessageBar


class EditProfile_ViewController: UIViewController {
    
    @IBOutlet var arrTextFields:[UITextField]!
    @IBOutlet weak var txtViewBio:UITextView!
    @IBOutlet weak var imgProfilePicture:UIImageView!
    
    var profileModel = ProfileModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in arrTextFields {
            textField.textFiedl_Padding()
        }
        
        EditProfilePresenter.setUIData(self, profileModel)
    }
    
    @IBAction func btnSelectImage(_ sender:UIButton) {
        imageAction()
    }
    
    @IBAction func btnCheck(_ sender:UIButton) {
        if arrTextFields[0].text!.isEmpty {
            SwiftMessageBar.showMessage(
                withTitle: "Error!",
                message:"Name is must be filled.",
                type:.error
            )
        } else if arrTextFields[1].text!.isEmpty {
            SwiftMessageBar.showMessage(
                withTitle: "Error!",
                message:"User name is must be filled.",
                type:.error
            )
        } else {
            (imgProfilePicture.image == nil)
                ? EditProfilePresenter.profileUpdate_WithOutImage(self)
                : EditProfilePresenter.profileUpdate_WithImage(self, imgProfilePicture.image ?? UIImage (named: "")!)
        }
    }
    
}



extension UITextField {
    
    func textFiedl_Padding() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(
            x: 0.0,
            y: self.frame.height - 1,
            width: self.frame.width, height:1
        )
        
        bottomLine.backgroundColor = UIColor ("307A8D")?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
}




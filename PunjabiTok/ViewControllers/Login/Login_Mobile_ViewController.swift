


//  Login_Mobile_ViewController.swift
//  PunjabiTok
//  Created by GranzaX on 06/06/21.



import UIKit
import CountryPickerView
import SVPinView
import SwiftMessageBar

class Login_Mobile_ViewController: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var imgFlag:UIImageView!
    @IBOutlet weak var lblCountryCode:UILabel!
    @IBOutlet weak var lblPhoneCode:UILabel!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var viewVerify:UIView!
    @IBOutlet weak var txtOTP:SVPinView!
    
    var cpv = CountryPickerView()
    
    let loginPresenter = LoginPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewVerify.isUserInteractionEnabled = false;
        txtOTP.isHidden = true
        
        loginPresenter.attachView( self, self)
        
        cpv = CountryPickerView(frame:view.frame)
        cpv.delegate = self
        cpv.dataSource = self
    }
    
    @IBAction func btnCountryCode(_ sender: Any) {
        cpv.showCountriesList(from: self)
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        imgFlag.image = country.flag
        lblPhoneCode.text = country.phoneCode
        lblCountryCode.text = country.code
    }
    
    @IBAction func btnDismiss(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGenerate_OTP(_ sender:UIButton) {
//        loginPresenter.login_firebase()
        
        debugPrint(lblPhoneCode.text!+txtPhoneNumber.text!)
        txtOTP.isHidden = true

        if (txtPhoneNumber.text?.count != 10) {
            SwiftMessageBar.showMessage(
                withTitle: "Error!",
                message:"Please enter a valid mobile number.",
                type:.error
            )
        } else {
            loginPresenter.fireBaseRequestOTP(lblPhoneCode.text!+txtPhoneNumber.text!)
        }
        
    }
    
    @IBAction func btnVerify_OTP(_ sender:UIButton) {
        debugPrint(txtOTP.getPin())
        
        if (txtOTP.getPin().count < 6) {
            SwiftMessageBar.showMessage(
                withTitle: "Error!",
                message:"Please enter a valid OTP.",
                type:.error
            )
        } else {
            loginPresenter.firebaseOTP_Verifiction(txtOTP.getPin())
        }
        
    }
    
}



extension Login_Mobile_ViewController:LoginPresenterDelegate {
    func login_Sucess() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func fireBaseRequestOTP() {
        txtOTP.isHidden = false
        viewVerify.isUserInteractionEnabled = true;
        viewVerify.backgroundColor = UIColor ("#3588A2")
        txtPhoneNumber.isUserInteractionEnabled = false
    }
    
}



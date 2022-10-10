

//  ReportViewController.swift
//  PunjabiTok
//  Created by GranzaX on 16/06/21.


import UIKit
import SwiftMessageBar


class ReportViewController: UIViewController {
    
    @IBOutlet weak var btnReason:UIButton!
    @IBOutlet weak var txtMessage:UITextView!
    
    var subject_id = 0
    var subject_type = ""
    var reason = ""
    
    var arrReasons = ["Drugs","Fake News","Fake Profile","Harasment","Hateful","IP Infringment"]
    var arrReason_ValueForAPI = [
        "drugs","fake_news","fake_profile","harassment","hateful",
        "ip_infringement","political_propaganda","pornography",
        "spam","violence","weapons","other"
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reason = arrReason_ValueForAPI[0]
        btnReason.setTitle(arrReasons[0], for: .normal)
    }
    
    @IBAction func btnOptions(_ sender:UIButton) {
        let actionSheet = UIAlertController (title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.view.tintColor = UIColor.black
        
        for i in 0..<arrReasons.count {
            let options = UIAlertAction (title:arrReasons[i], style: .default) { (action) in
                self.reason = self.arrReason_ValueForAPI[i]
                self.btnReason.setTitle(action.title, for: .normal)
            }
            
            actionSheet.addAction(options)
        }
        
        let cancel = UIAlertAction (title:"Cancel", style: .cancel) { (action) in
            
        }
        
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnTick(_ sender:UIButton) {
        if txtMessage.text.isEmpty {
            SwiftMessageBar.showMessage(
                withTitle: "Error!",
                message:"Enter your text here.",
                type:.error
            )
        } else {
            ReportPresenter.shared.attach(self)
            ReportPresenter.shared.report(
                subject_type, subject_id,
                reason, txtMessage.text!
            )
        }
    }
}

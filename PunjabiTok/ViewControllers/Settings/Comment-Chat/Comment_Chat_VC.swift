//
//  Comment_Chat_VC.swift
//  PunjabiTok
//
//  Created by GranzaX on 18/06/21.


import UIKit

class Comment_Chat_VC: UIViewController {
    
    @IBOutlet weak var viewEmoji:UIView!
    @IBOutlet weak var viewFile:UIView!
    @IBOutlet weak var txtTypeMessage:UITextView!
    @IBOutlet weak var heightTyepMessage:NSLayoutConstraint!
    
    
    var arrCommentModel = [CommentModel]()
    var clipID = "1420"
    var isMyProfile = false
    
    @IBOutlet weak var tblComment:UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTypeMessage.textContainerInset = UIEdgeInsets(
            top: 10, left: 10,
            bottom: 10, right: 10
        );
        
        CommentPresenter.shared.attach(self,self)
        CommentPresenter.shared.getComments(clipID, 1)
    }
    
}



extension Comment_Chat_VC: CommentDelegate {
    func updateTableView(_ arrCommentModel:[CommentModel]) {
        self.arrCommentModel = arrCommentModel.reversed()
        
        tblComment.reloadData()
        let indexPath = IndexPath(row: self.arrCommentModel.count-1, section: 0)
        tblComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

extension Comment_Chat_VC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtTypeMessage.text == "Type something here" {
            txtTypeMessage.text = ""
            
            viewEmoji.isHidden = true
            viewFile.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtTypeMessage.text == "" {
            txtTypeMessage.text = "Type something here"
            
            viewEmoji.isHidden = false
            viewFile.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        debugPrint(txtTypeMessage.text ?? "")
        debugPrint(txtTypeMessage.text.size_According_Text())
                
        if txtTypeMessage.text.size_According_Text().height < 50 || txtTypeMessage.text.size_According_Text().height > 130 {
            
        } else {
            heightTyepMessage.constant = txtTypeMessage.text.size_According_Text().height

        }
        
        return true
    }
    
    @IBAction func btnSend(_ sender:UIButton) {
        
        if txtTypeMessage.text != "Type something here" && !txtTypeMessage.text.isEmpty {
            CommentPresenter.shared.createComments(clipID, txtTypeMessage.text!)
            txtTypeMessage.text = ""
            self.view.endEditing(true)
        }
    }
}

extension Comment_Chat_VC :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCommentModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! Comment_TableViewCell
        
        cell.commentModel = arrCommentModel[indexPath.row]
        
        cell.btnReport.tag = indexPath.row
        cell.btnReport.addTarget(self, action: #selector(btnReport(_:)), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDelete(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @IBAction func btnReport(_ sender:UIButton) {
        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        
        reportVC.subject_id = Int(arrCommentModel[sender.tag].id) ?? 0
        reportVC.subject_type = "comment"
        
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @IBAction func btnDelete(_ sender:UIButton) {
        let alert = UIAlertController (title: "Do you really want to delete this comment ?",
                                       message:"This can not be undone" ,
                                       preferredStyle: .alert)
        
        let yes = UIAlertAction (title: "Yes", style: .default) { [self] (action) in
            CommentPresenter.shared.deleteComments(
                self.clipID,
                Int(self.arrCommentModel[sender.tag].id) ?? 0)
        }
        
        let cancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(yes)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

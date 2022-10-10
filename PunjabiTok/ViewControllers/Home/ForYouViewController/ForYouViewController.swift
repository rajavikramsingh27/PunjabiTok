

//  ForYouViewController.swift
//  PunjabiTok
//  Created by GranzaX on 31/05/21.


import UIKit
import MBProgressHUD
import SwiftMessageBar
import AVKit
import SDWebImage
import Alamofire


class ForYouViewController: UIViewController {
    @IBOutlet weak var tbl_Following_ForYou:UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var count = 10
    var isMyProfile = true
    var is_Mine_Liked_Save = false
    var isMineVideos = false
    var arrClipsDetailsModel_FromProfile = [ClipsDetailsModel]()
    let forYouPresenter = ForYouPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint(arrClipsDetailsModel_FromProfile.count)
        forYouPresenter.attachView(self,self)
        
        if !is_Mine_Liked_Save {
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            tbl_Following_ForYou.addSubview(refreshControl) // not requi
            
            let param = [
                "following":false,
                "languages":"punjabi",
                "count":"\(count)"
            ] as [String:Any]
            print(param)
            forYouPresenter.clips(param)
        } else {
            forYouPresenter.arrClipsDetailsModel = arrClipsDetailsModel_FromProfile
            debugPrint(forYouPresenter.arrClipsDetailsModel.count)
            tbl_Following_ForYou.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        forYouPresenter.arrClipsDetailsModel.removeAll()
        
        let param = [
            "following":false,
            "languages":"punjabi",
            "count":"\(count)"
        ] as [String : Any]
        print(param)
        
        forYouPresenter.clips(param)
    }
    
}



extension ForYouViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tbl_Following_ForYou.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forYouPresenter.arrClipsDetailsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! ForYouTableViewCell
        
        cell.btnReport.isHidden = !isMyProfile
        cell.btnBack.isHidden = isMyProfile
        cell.btnEdit.isHidden = !isMineVideos
        cell.btnDelete.isHidden = !isMineVideos
        
        let url = URL(string:forYouPresenter.arrClipsDetailsModel[indexPath.row].video )
        let avPlayer = AVPlayer(url: url!)
        cell.viewPlayer.playerLayer.player = avPlayer
        
        cell.expiryTimeInterval = Double(Int(forYouPresenter.arrClipsDetailsModel[indexPath.row].duration)!)
        cell.lblDuration.text = "__:__"
                
        cell.lblviews_count.text = "\(forYouPresenter.arrClipsDetailsModel[indexPath.row].views_count)"
        cell.lbllikes_count.text = "\(forYouPresenter.arrClipsDetailsModel[indexPath.row].likes_count)"
        cell.lblcomments_count.text = "\(forYouPresenter.arrClipsDetailsModel[indexPath.row].comments_count)"
        
        cell.lblUserName.text = "@"+forYouPresenter.arrClipsDetailsModel[indexPath.row].username_User
        
        cell.imgPhoto.sd_setImage(with:forYouPresenter.arrClipsDetailsModel[indexPath.row].photo_User,placeholderImage: UIImage(named:""))
        
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(btnPlay(_:)), for: .touchUpInside)
        
        cell.btnShowOptionButtons.tag = indexPath.row
        cell.btnShowOptionButtons.addTarget(self, action: #selector(btnShowOptionButtons(_:)), for: .touchUpInside)
        
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.isSelected = forYouPresenter.arrClipsDetailsModel[indexPath.row].liked
        cell.btnHeart.addTarget(self, action: #selector(btnHeart(_:)), for: .touchUpInside)
        
        cell.btnSaved.tag = indexPath.row
        cell.btnSaved.isSelected = forYouPresenter.arrClipsDetailsModel[indexPath.row].saved
        cell.btnSaved.addTarget(self, action: #selector(btnSaved(_:)), for: .touchUpInside)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnComment(_:)), for: .touchUpInside)
        
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(btnShare(_:)), for: .touchUpInside)
        
        cell.btnReport.tag = indexPath.row
        cell.btnReport.addTarget(self, action: #selector(btnReport(_:)), for: .touchUpInside)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEdit(_:)), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDelete(_:)), for: .touchUpInside)
        
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(btnDownload(_:)), for: .touchUpInside)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            cell.trailRightContent.constant = -50
            cell.bottomDownContent.constant = -50
            
            UIView.animate(withDuration:0.6) {
                cell.stackDownContent.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
        
        let cellBGView = UIView()
        cellBGView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = cellBGView
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = (cell as? ForYouTableViewCell) else { return };
        cell.trailRightContent.constant = 20
        cell.bottomDownContent.constant = 20
        cell.stackDownContent.alpha = 1
        
        let visibleCells = tableView.visibleCells;
        let minIndex = visibleCells.startIndex;
        
        if (tableView.visibleCells.firstIndex(of: cell) != minIndex) {
            cell.viewPlayer.player?.play();
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? ForYouTableViewCell else { return };
        
        videoCell.viewPlayer.player?.pause();
        videoCell.viewPlayer.player = nil;
        
        videoCell.timer?.invalidate()
        videoCell.timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !is_Mine_Liked_Save {
            if ((tbl_Following_ForYou.contentOffset.y +
                    tbl_Following_ForYou.frame.size.height) >= tbl_Following_ForYou.contentSize.height) {
                count += 15
                
                let param = [
                    "following":false,
                    "languages":"punjabi",
                    "count":"\(count)"
                ] as [String : Any]
                print(param)
                
                forYouPresenter.clips(param)
            }
            
        }
    }
    
    @IBAction func btnPlay(_ sender:UIButton) {
        let cell = tbl_Following_ForYou.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ForYouTableViewCell
        cell.btnPlay.isSelected = !cell.btnPlay.isSelected
        
        if cell.btnPlay.isSelected {
            cell.viewPlayer.player?.pause();
            cell.timer?.invalidate()
            cell.timer = nil
        } else {
            cell.viewPlayer.player?.play();
            cell.restartTimer()
//            cell.expiryTimeInterval = Double(arrClipsData[sender.tag]["duration"] as! Int)
        }
                
    }
    
    @IBAction func btnShowOptionButtons(_ sender:UIButton) {
        let indexPath = IndexPath (row: sender.tag, section: 0)
        let cell = tbl_Following_ForYou.cellForRow(at: indexPath) as! ForYouTableViewCell
                
        if cell.stackDownContent.alpha == 1 {
            cell.trailRightContent.constant = -50
            cell.bottomDownContent.constant = -50
            
            UIView.animate(withDuration:0.6) {
                cell.stackDownContent.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            cell.trailRightContent.constant = 20
            cell.bottomDownContent.constant = 20
            cell.stackDownContent.alpha = 1
            UIView.animate(withDuration:0.6) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @IBAction func btnHeart(_ sender:UIButton) {
        forYouPresenter.indexSelected = sender.tag
        
        forYouPresenter.like_Save_Videos(
            forYouPresenter.arrClipsDetailsModel[sender.tag].id,
            "likes",
            forYouPresenter.arrClipsDetailsModel[sender.tag].liked
        )
    }
    
    @IBAction func btnSaved(_ sender:UIButton) {
        forYouPresenter.indexSelected = sender.tag
        
        forYouPresenter.like_Save_Videos(
            forYouPresenter.arrClipsDetailsModel[sender.tag].id,
            "saves",
            forYouPresenter.arrClipsDetailsModel[sender.tag].saved
        )
        
    }
    
    @IBAction func btnComment(_ sender:UIButton) {
        pushToVC("Main", "Comment_Chat_VC", true)
    }
    
    @IBAction func btnShare(_ sender:UIButton) {
        let text = "This is some text that I want to share."
        let textToShare = [text]
        let activityViewController = UIActivityViewController(
            activityItems: textToShare, applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnReport(_ sender:UIButton) {
        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        
        reportVC.subject_id = Int(forYouPresenter.arrClipsDetailsModel[sender.tag].id)!
        reportVC.subject_type = "clip"
        
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @IBAction func btnEdit(_ sender:UIButton) {
        let clipID = forYouPresenter.arrClipsDetailsModel[sender.tag].id
        
        
    }
    
    @IBAction func btnDelete(_ sender:UIButton) {
        forYouPresenter.indexSelected = sender.tag
        let clipID = forYouPresenter.arrClipsDetailsModel[sender.tag].id
        forYouPresenter.clipsDelete(clipID)
    }
    
    @IBAction func btnDownload(_ sender:UIButton) {
//        "1447"
    }
    
}

extension ForYouViewController: ForYouDelegate {
    func deleteClips() {
        forYouPresenter.arrClipsDetailsModel.remove(at: forYouPresenter.indexSelected)
        tbl_Following_ForYou.reloadData()
        
        if forYouPresenter.arrClipsDetailsModel.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func updateClips() {
        self.tbl_Following_ForYou.reloadData()
    }
    
    func likeUnlike_Update(_ like_Or_dislike: Bool) {
        debugPrint(like_Or_dislike)
        
        let indexPath = IndexPath (row: forYouPresenter.indexSelected, section: 0)
        let cell = tbl_Following_ForYou.cellForRow(at: indexPath) as! ForYouTableViewCell
        
        forYouPresenter.arrClipsDetailsModel[forYouPresenter.indexSelected].liked = like_Or_dislike
        cell.btnHeart.isSelected = like_Or_dislike
    }
    
    func savedUnSaved_Update(_ save_Or_UnSave: Bool) {
        debugPrint(save_Or_UnSave)
        
        let indexPath = IndexPath (row: forYouPresenter.indexSelected, section: 0)
        let cell = tbl_Following_ForYou.cellForRow(at: indexPath) as! ForYouTableViewCell
        
        forYouPresenter.arrClipsDetailsModel[forYouPresenter.indexSelected].saved = save_Or_UnSave
        cell.btnSaved.isSelected = save_Or_UnSave
    }
    
}




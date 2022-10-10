

//  ProfileViewController.swift
//  PunjabiTok
//  Created by GranzaX on 31/05/21.


import UIKit
import SDWebImage


class ProfileViewController: UIViewController {
    @IBOutlet weak var imgProfilePicture:UIImageView!
    
    @IBOutlet weak var lblName, lblUserName:UILabel!
    @IBOutlet weak var lblViewsCount, lblLikesCount, lblFollowersCount, lblFollowingCount:UILabel!
    
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnReportFlag:UIButton!
    @IBOutlet weak var stkView_Follow_Chat:UIStackView!
    @IBOutlet weak var view_Video_Fav_Book_Mail:UIView!
    
    @IBOutlet var arrBottomLine:[UIView]!
    @IBOutlet var arrImageSelected:[UIImageView]!
    @IBOutlet weak var coll_Clips:UICollectionView!
    
    let arrSelectedImage = ["videoSelected.png","heartSelected.png","agendaSelected.png","mailSelected.png"]
    let arrUnselectedImage = ["video.png","hearts.png","agenda.png","mails.png"]
    
    let profilePresenter = ProfilePresenter()
    
    var isMyProfile = true
    var isMineVideos = false
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        profilePresenter.attachView(self, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnBack.isHidden = isMyProfile
        btnReportFlag.isHidden = isMyProfile
        stkView_Follow_Chat.isHidden = isMyProfile
        view_Video_Fav_Book_Mail.isHidden = !isMyProfile
        
        if UserDefaults.standard.value(forKey: kToken) == nil {
            let loginVC = self.storyboard?.instantiateViewController(
                withIdentifier: "LoginViewController"
            ) as! LoginViewController
            
            self.present(loginVC, animated: true, completion: nil)
        } else {
            profilePresenter.profile()
            funcDefaultSelected()
        }
        
    }
    
    func funcDefaultSelected()  {
        let btnDefaultSelected = UIButton()
        btnDefaultSelected.tag = 0
        btnSelected(btnDefaultSelected)
    }
    
    @IBAction func btnSelected(_ sender:UIButton) {
        for i in 0..<arrBottomLine.count {
            arrBottomLine[i].isHidden = (i == sender.tag) ? false : true
            arrImageSelected[i].image = (i == sender.tag)
                ? UIImage (named:arrSelectedImage[i])
                : UIImage (named:arrUnselectedImage[i])
        }
        
        selectedClips(sender.tag)
    }
    
    func selectedClips(_ buttonTag:Int) {
        coll_Clips.isHidden = false
        
        isMineVideos = (buttonTag == 0) ? true : false
        
        if buttonTag == 0 {
            let param = [
                "mine":"true",
                "count":"10"
            ]
            profilePresenter.clips(self,param)
        } else if buttonTag == 1 {
            let param = [
                "liked":"true",
                "count":"10"
            ]
            profilePresenter.clips(self,param)
        } else if buttonTag == 2 {
            let param = [
                "saved":"true",
                "count":"10"
            ]
            profilePresenter.clips(self,param)
        } else if buttonTag == 3 {
//            here will be show draft Clips using Local DB or Core Data
            coll_Clips.isHidden = true
        }
    }
    
    @IBAction func btnChat(_ sender:UIButton) {
        pushToVC("Main", "Comment_Chat_VC", true)
    }
    
    @IBAction func btnReport(_ sender:UIButton) {
        pushToVC("Main", "ReportViewController", true)
    }
    
    @IBAction func btnMore(_ sender:UIButton) {
        let alert = UIAlertController (title: "",
                                       message: "Profile More Options...",
                                       preferredStyle: .actionSheet
        )
        
        alert.view.tintColor = UIColor.black
        let edit = UIAlertAction (title: "Edit", style: .default) { (action) in
            let editProfile_VC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile_ViewController") as! EditProfile_ViewController
            editProfile_VC.profileModel = self.profilePresenter.profileModel
            self.navigationController?.pushViewController(editProfile_VC, animated: true)
        }
        
        let share = UIAlertAction (title: "Share", style: .default) { (action) in
            let text = "This is some text that I want to share."
            let textToShare = [text]
            let activityViewController = UIActivityViewController(
                activityItems: textToShare, applicationActivities: nil
            )
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let verification = UIAlertAction (title: "Verification", style: .default) { (action) in
            self.pushToVC("Main", "VerificationViewController", true)
        }
        
        let settings = UIAlertAction (title: "Settings", style: .default) { (action) in
            self.pushToVC("Main", "SettingsViewController", true)
        }
        
        let cancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(edit)
        alert.addAction(share)
        alert.addAction(verification)
        alert.addAction(settings)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}



extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = coll_Clips.frame.size.width/3-10
        
        return CGSize(
            width:width,
            height:width
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePresenter.arrClipsDetailsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! ProfileClipsCollectionCell
        
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelect(_:)), for: .touchUpInside)
        
        cell.profileModel = profilePresenter.arrClipsDetailsModel[indexPath.row]
        
        return cell
    }
    
    @IBAction func btnSelect(_ sender:UIButton) {
        let forYouVC = storyboard?.instantiateViewController(withIdentifier: "ForYouViewController") as! ForYouViewController
        forYouVC.isMyProfile = false
        forYouVC.is_Mine_Liked_Save = true
        forYouVC.isMineVideos = self.isMineVideos
        
//        let clipModel = profilePresenter.arrClipsDetailsModel[sender.tag]
//        profilePresenter.arrClipsDetailsModel.remove(at: sender.tag)
//        profilePresenter.arrClipsDetailsModel.insert(clipModel, at: 0)
        
        profilePresenter.arrClipsDetailsModel.swapAt(0, sender.tag)
        
        forYouVC.arrClipsDetailsModel_FromProfile = profilePresenter.arrClipsDetailsModel
        navigationController?.pushViewController(forYouVC, animated: true)
    }
    
    
    
}



extension ProfileViewController: ProfilePresenterDelegate {
    func updateClips() {
        coll_Clips.reloadData()
    }
    
    func updateProfileData() {
        lblName.text = profilePresenter.profileModel.name
        lblUserName.text = profilePresenter.profileModel.username
        
        lblViewsCount.text = profilePresenter.profileModel.views_count
        lblLikesCount.text = profilePresenter.profileModel.likes_count
        lblFollowersCount.text = profilePresenter.profileModel.followers_count
        lblFollowingCount.text = profilePresenter.profileModel.followed_count
        
        imgProfilePicture.sd_setImage(
            with: profilePresenter.profileModel.photo,
            placeholderImage: nil
        )
        
    }
    
}



//  ForYouTableViewCell.swift
//  PunjabiTok
//  Created by GranzaX on 31/05/21.


import UIKit
import AVKit
import MBCircularProgressBar


class ForYouTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewPlayer: PlayerView!
    @IBOutlet weak var imgPhoto:UIImageView!
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblDuration:UILabel!
    @IBOutlet weak var lblviews_count:UILabel!
    @IBOutlet weak var lbllikes_count:UILabel!
    @IBOutlet weak var lblcomments_count:UILabel!
    @IBOutlet weak var btnPlay:UIButton!
    @IBOutlet weak var btnShowOptionButtons:UIButton!
    @IBOutlet weak var btnHeart:UIButton!
    @IBOutlet weak var btnSaved:UIButton!
    @IBOutlet weak var btnComment:UIButton!
    @IBOutlet weak var btnShare:UIButton!
    @IBOutlet weak var btnReport:UIButton!
    @IBOutlet weak var btnEdit:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var btnDownload:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var trailRightContent:NSLayoutConstraint!
    @IBOutlet weak var bottomDownContent:NSLayoutConstraint!
    @IBOutlet weak var stackDownContent:UIStackView!
    
    @IBOutlet weak var progress:MBCircularProgressBarView!
    var progressValue = 0
    
    var player = AVPlayer()
    
    var timer: Timer?
    var duration: Double = 0
    
    var expiryTimeInterval: TimeInterval? {
        didSet {
            if timer == nil {
                progressValue = 0
                progress.value = 0
                startTimer()
                RunLoop.current.add(timer!, forMode: .common)
            }
        }
    }
    
    func restartTimer() {
        timer = Timer(timeInterval: 1.0,
                      target: self,
                      selector: #selector(onComplete),
                      userInfo: nil,
                      repeats: true)
    }
    
    func startTimer() {
        if let interval = expiryTimeInterval {
            duration = interval
            if #available(iOS 10.0, *) {
                timer = Timer(timeInterval: 1.0,
                              repeats: true,
                              block: { [weak self] _ in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.onComplete()
                              })
            } else {
                timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(onComplete),
                              userInfo: nil,
                              repeats: true)
            }
        }
    }
    
    @objc func onComplete() {
        guard duration >= 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        
        var strDuration = ""
        
        if duration < 10 {
            strDuration = "00:0\(Int(duration))"
        } else {
            strDuration = "00:\(Int(duration))"
        }
        
        UIView.animate(withDuration:0.1) { [self] in
            DispatchQueue.main.async {
                self.progress.value = CGFloat(Double(self.progressValue)/self.expiryTimeInterval!)
                lblDuration.text = strDuration
                duration -= 1
                progressValue += 1
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        timer?.invalidate()
//        timer = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewPlayer.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}



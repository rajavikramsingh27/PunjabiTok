//
//  PlayerView.swift
//  PunjabiTok
//
//  Created by GranzaX on 11/06/21.
//

import Foundation
import UIKit
import AVKit


class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

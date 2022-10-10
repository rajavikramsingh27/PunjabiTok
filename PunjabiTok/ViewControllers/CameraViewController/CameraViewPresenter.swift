

//  CameraViewPresenter.swift
//  PunjabiTok
//  Created by GranzaX on 28/07/21.


import AVKit
import UIKit
import Alamofire
import Foundation
import MBProgressHUD
import SwiftMessageBar
import MobileCoreServices



/*
 
 <item>hin</item>
 <item>eng</item>
 <item>pan</item>
 <item>bgc</item>
 <item>bho</item>
 <item>ori</item>
 <item>ben</item>
 <item>guj</item>
 <item>mar</item>
 <item>kan</item>
 <item>tam</item>
 <item>tel</item>
 <item>mal</item>



 <item>contact_us</item>
 <item>get_quote</item>
 <item>learn_more</item>
 <item>shop_now</item>
 
 */



class CameraViewPresenter {
    static let shared = CameraViewPresenter()
    
    var vc:CameraViewController!
    
    func attach(_ vc:CameraViewController) {
        self.vc = vc
    }
    
    var urlVideoOrigin:URL! {
        didSet {
            createPost(self.vc)
        }
    }
    
    func createPost(_ vc:CameraViewController) {
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
//        let urlVideo_In_mp_4 = encodeVideo(urlVideoOrigin)
        encodeVideo(urlVideoOrigin) { (urlVideo_In_mp_4) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: vc.view, animated: true)
                debugPrint("urlVideo_In_mp_4 is:--\n",urlVideo_In_mp_4)
                
                MBProgressHUD.showAdded(to: vc.view, animated: true)
                let param = [
                    "song":"",
                    "description":"",
                    "language":"eng",
                    "private":"",
                    "comments":"",
                    "duet":"",
                    "duration":"20",
                    "cta_label":"",
                    "cta_link":"",
                    "location":"",
                    "latitude":"",
                    "longitude":"",
                ]
                
                var videoData:Data!
                do {
                    videoData = try Data(contentsOf: urlVideo_In_mp_4)
                } catch (let error) {
                    debugPrint(error.localizedDescription)
                    
                    SwiftMessageBar.showMessage(
                        withTitle: "Error!",
                        message:error.localizedDescription,
                        type:.error
                    )
                    
                    return
                }
                
                //        deleteFile(urlVideo_In_mp_4)
                let thumbnail_FromVideo = self.generateThumbnail(self.urlVideoOrigin)
                
                let gifCreated = self.makeGIF_FromVideo(self.urlVideoOrigin)
                
                let gifCreatedData = try! Data(contentsOf: gifCreated)
                
                let dictMedia_Param_Data = [
                    "video":videoData!,
                    "screenshot":thumbnail_FromVideo!.pngData()!,
                    "preview":gifCreatedData
                ]
                
                API_Service.postAPI_Video("clips", param, dictMedia_Param_Data) { (json) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: vc.view, animated: true)
                        
                        if let message = json.dictionary!["message"] {
                            SwiftMessageBar.showMessage(
                                withTitle: "Error!",
                                message:"\(message)",
                                type:.error
                            )
                        } else {
                            SwiftMessageBar.showMessage(
                                withTitle: "Posted!",
                                message:"Your video has posted!",
                                type:.success
                            )
                        }
                    }
                    
                }
            }
        }
        
    }
    
}



//    MARK: to create gif and mp4 video
extension CameraViewPresenter {
    func generateThumbnail(_ url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let cgImage = try imageGenerator.copyCGImage(
                at:.zero,
                actualTime: nil
            )
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func makeGIF_FromVideo( _ urlOrigin: URL) -> URL {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let destionationURL = documentsDirectory2.appendingPathComponent("videoPreview.gif")
        
        let asset = AVURLAsset(url: urlOrigin)
        
        let duration = asset.duration
        
        let vid_length : CMTime = duration
        let seconds : Double = CMTimeGetSeconds(vid_length)
        
        let tracks = asset.tracks(withMediaType: .video)
        
        let fps = tracks.first?.nominalFrameRate ?? 1.0
        
        let required_frames_count : Int = Int(seconds * Double(fps)) // You can set according
        
        let step : Int64 = vid_length.value / Int64(required_frames_count)
        
        var value : CMTimeValue = CMTimeValue.init(0.0)
        
        let destination = CGImageDestinationCreateWithURL(destionationURL! as CFURL, kUTTypeGIF, required_frames_count, nil)
        
        let gifProperties : CFDictionary = [ kCGImagePropertyGIFDictionary : [kCGImagePropertyGIFLoopCount : 0] ] as CFDictionary
        
        for _ in 0 ..< 50 {
            let image_generator : AVAssetImageGenerator = AVAssetImageGenerator.init(asset: asset)
            
            image_generator.requestedTimeToleranceAfter = CMTime.zero
            image_generator.requestedTimeToleranceBefore = CMTime.zero
            image_generator.appliesPreferredTrackTransform = true
            
            image_generator.maximumSize = CGSize(width: width, height: height)
            
            let time : CMTime = CMTime(value: value, timescale: vid_length.timescale)
            
            do {
                let image_ref : CGImage = try image_generator.copyCGImage(at: time, actualTime: nil)
                
                let thumb : UIImage = UIImage.init(cgImage: image_ref)
                mergeFrameForGif(frame: thumb, destination: destination!)
                
                value = value + step
            } catch {
                
            }
            
        }
        
        CGImageDestinationSetProperties(destination!, gifProperties)
        CGImageDestinationFinalize(destination!)
        
        return destionationURL!
    }
    
    private func mergeFrameForGif(frame: UIImage, destination: CGImageDestination) {
        let frameProperties : CFDictionary = [ kCGImagePropertyGIFDictionary : [kCGImagePropertyGIFDelayTime : 0] ] as CFDictionary
        CGImageDestinationAddImage(destination, frame.cgImage!, frameProperties)
    }
    
    func encodeVideo(_ videoURL: URL, completion:@escaping ( _ mp4_URL:URL)->()) {
        let avAsset = AVURLAsset (url: videoURL, options: nil)
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let filePath = documentsDirectory2.appendingPathComponent("renderedVideoURL.mp4")
        
        deleteFile(filePath!)
//        Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
            }
        }
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession!.timeRange = range
        
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                debugPrint("%@",exportSession?.error ?? "")
                completion(exportSession!.outputURL!)
            case .cancelled:
                debugPrint("Export canceled")
                completion(exportSession!.outputURL!)
            case .completed:
                completion(filePath!)
            default:
                break
            }
        })
    }
    
    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch {
            fatalError("Unable to delete file: \(error)")
        }
    }
    
}


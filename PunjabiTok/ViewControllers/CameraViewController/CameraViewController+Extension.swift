


//  CameraViewController+Extension.swift
//  PunjabiTok
//  Created by GranzaX on 28/07/21.



import UIKit
import Photos
import Foundation
import MobileCoreServices
import SwiftMessageBar



extension CameraViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func btnPhotos (_ sender:UIButton) {
        let actionSheet = UIAlertController (title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction (title: "Camera", style: .default, handler: { (action) in
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self.openCamera()
            } else {
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted == true {
                        // User granted
                        self.openCamera()
                    } else {
                        // User rejected
                        self.alertForMedia("camera")
                    }
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction (title: "Photos", style: .default, handler: { (action) in
            let status = PHPhotoLibrary.authorizationStatus()
            debugPrint(status.rawValue)
            
            switch status {
            case .authorized:
                //handle authorized status
                debugPrint(status.rawValue)
                DispatchQueue.main.async {
                    self.openPhotos()
                }
            case .denied, .restricted, .notDetermined, .limited:
                
                // ask for permissions
                PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                    switch status {
                    case .authorized:
                        // as above
                        debugPrint(status.rawValue)
                        DispatchQueue.main.async {
                            self.openPhotos()
                        }
                    case .denied, .restricted, .limited, .notDetermined:
                        // as above
                        debugPrint(status.rawValue)
                        DispatchQueue.main.async {
                            self.alertForMedia("photos")
                        }
                    default:
                        debugPrint("default")
                    }
                }
                
            default:
                debugPrint("limited")
            }
        }))
        
        actionSheet.addAction(UIAlertAction (title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = .camera;
                imag.mediaTypes = ["public.movie"]
                imag.allowsEditing = false
                
                self.present(imag, animated: true, completion: nil)
            } else {
                SwiftMessageBar.showMessage(withTitle: "Error", message:"Camera is not available!", type:.error)
            }
        }
    }
    
    func openPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = .photoLibrary;
            imag.mediaTypes = ["public.movie"] // kUTTypeImage as String,
            imag.allowsEditing = false
            
            self.present(imag, animated: true, completion: nil)
        } else {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"No Photos Available!", type:.error)
        }
    }
    
    func alertForMedia(_ mediaType:String) {
        let alert = UIAlertController (
            title: "\(mediaType) permission id denied",
            message: "Allow \(mediaType) permission from app settings", preferredStyle: .alert )
        
        let allow = UIAlertAction (title: "Allow", style: .default) { (action) in
            if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let cancel = UIAlertAction (title: "Cancel", style: .default) { (action) in
            
        }
        
        alert.addAction(allow)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let fileURL = info[.mediaURL] as? URL {
            debugPrint(fileURL)
            
            dismiss(animated: true, completion: nil)
            CameraViewPresenter.shared.attach(self)
            CameraViewPresenter.shared.urlVideoOrigin = fileURL
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

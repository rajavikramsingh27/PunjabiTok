


//  EditProfile+ImagePicker.swift
//  PunjabiTok
//  Created by GranzaX on 27/07/21.



import UIKit
import AVKit
import Photos
import Foundation
import MobileCoreServices
import SwiftMessageBar



extension EditProfile_ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imageAction() {
        let actionSheet = UIAlertController (title: "Profile Picture!", message: "", preferredStyle: .actionSheet)
        
        let removeCurrentPhoto = UIAlertAction (title: "Remove Current Photo", style: .default) { (action) in
            EditProfilePresenter.profilePhotoDelete(self)
        }
        
        let camera = UIAlertAction (title: "Camera", style: .default) { (action) in
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
            
        }
        
        let photos = UIAlertAction (title: "Photos", style: .default) { [self] (action) in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                //handle authorized status
                debugPrint(status)
                self.openPhotos()
            case .denied, .restricted, .notDetermined, .limited:
                
                // ask for permissions
                PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                    switch status {
                    case .authorized:
                        // as above
                        debugPrint(status)
                        self.openPhotos()
                    case .denied, .restricted, .limited, .notDetermined:
                        // as above
                        debugPrint(status)
                        self.alertForMedia("photos")
                    default:
                        debugPrint("default")
                    }
                }
                
            default:
                debugPrint("limited")
            }
        }
        
        let cancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            
        }
        
        if imgProfilePicture.image != nil {
            actionSheet.addAction(removeCurrentPhoto)
        }
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photos)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgProfilePicture.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = .camera;
                imag.mediaTypes = [kUTTypeImage as String]
                imag.allowsEditing = false
                
                self.present(imag, animated: true, completion: nil)
            } else {
                SwiftMessageBar.showMessage(withTitle: "Error", message:"Camera is not available!", type:.error)
            }
        }
    }
    
    func openPhotos() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = .photoLibrary;
                imag.mediaTypes = [kUTTypeImage as String]
                imag.allowsEditing = false
                
                self.present(imag, animated: true, completion: nil)
            } else {
                SwiftMessageBar.showMessage(withTitle: "Error", message:"No Photos Available!", type:.error)
            }
        }
    }
    
    func alertForMedia(_ mediaType:String)  {
        DispatchQueue.main.async {
            let alert = UIAlertController (
                title: "\(mediaType) permission id denied",
                message: "Allow \(mediaType) permission from app settings", preferredStyle: .alert)
            
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
        
    }
    
}

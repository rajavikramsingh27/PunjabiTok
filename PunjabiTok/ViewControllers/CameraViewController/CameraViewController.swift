

//  CameraViewController.swift
//  PunjabiTok
//  Created by GranzaX on 01/06/21.



import UIKit
import AVFoundation


class CameraViewController: UIViewController {
    
//    @IBOutlet weak var switchCameraButton:UIButton!
    @IBOutlet weak var capturedImageView:UIImageView!
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var collFeatures:UICollectionView!
    @IBOutlet weak var widthCollFeatures:NSLayoutConstraint!
    
    
    
    //MARK:- Vars
    var captureSession : AVCaptureSession!
    
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var videoOutput : AVCaptureVideoDataOutput!
    
    var takePicture = false
    var backCameraOn = true
    
    var arrFeatures = ["Slower","Slow","Normal","Fast","Faster"]
    var arrFeaturesSelected = [Bool]()
    
    
    
    @IBOutlet weak var tblFilters:UITableView!
    var arrFiltersIcons = ["flip.png","filter.png","effect.png","timer.png","flash.png","dute.png","beauty.png"]
    var arrFiltersTitles = ["Flip","Filter","Effect","Timer","Flash","Dute","Beauty"]
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblFilters.contentInset = UIEdgeInsets(top:23, left: 0, bottom: 23, right: 0);

        
        widthCollFeatures.constant = CGFloat((arrFeatures.count*70)+20)
        collFeatures.layer.cornerRadius = 5
        collFeatures.clipsToBounds = true
        
        for i in 0..<arrFeatures.count {
            arrFeaturesSelected.append((i==2) ? true : false)
        }
        
        collFeatures.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let loginVC = self.storyboard?.instantiateViewController(
//            withIdentifier: "LoginViewController"
//        ) as! LoginViewController
//        
//        self.present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkPermissions()
        setupAndStartCaptureSession()
    }
        
    //MARK:- Camera Setup
    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async{
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            if #available(iOS 10.0, *) {
                self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            } else {
                // Fallback on earlier versions
            }
            
            //setup inputs
            self.setupInputs()
            
            DispatchQueue.main.async {
                //setup preview layer
                self.setupPreviewLayer()
            }
            
            //setup output
            self.setupOutput()
            
            //commit configuration
            self.captureSession.commitConfiguration()
            //start running it
            self.captureSession.startRunning()
        }
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
//            fatalError("could not add video output")
        }
        
        //deal with the orientation
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: viewContainer.layer)
        previewLayer.frame = self.view.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    func setupInputs(){
        //get back camera
        if #available(iOS 10.0, *) {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                backCamera = device
            } else {
                //handle this appropriately for production purposes
              //  fatalError("no back camera")
                print("no back camera")
            }
        } else {
            // Fallback on earlier versions
        }
        
        //get front camera
        if #available(iOS 10.0, *) {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                frontCamera = device
            } else {
//                fatalError("no front camera")
            }
        } else {
            // Fallback on earlier versions
        }
        
        if backCamera == nil {
            return
        }
        
        //now we need to create an input objects from our devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            return
//            fatalError("could not create input device from back camera")
        }
        
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
//            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            return
//            fatalError("could not create input device from front camera")
        }
        
        frontInput = fInput
        if !captureSession.canAddInput(frontInput) {
//            fatalError("could not add front camera input to capture session")
        }
        
        //connect back camera input to session
        captureSession.addInput(backInput)
    }
    
    func switchCamera(){
        //don't let user spam the button, fun for the user, not fun for performance
//        switchCameraButton.isUserInteractionEnabled = false
        
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again for portrait mode
        videoOutput.connections.first?.videoOrientation = .portrait

        //mirror the video stream for front camera
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn

        //commit config
        captureSession.commitConfiguration()

        //acitvate the camera button again
//        switchCameraButton.isUserInteractionEnabled = true
    }
    
}



extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //get UIImage out of CIImage
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
//            self.capturedImageView.image = uiImage
            self.takePicture = false
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton?){
        takePicture = true
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            print("")
//            fatalError()
        }
    }
    
}



extension CameraViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collFeatures.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFeatures.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath
        ) as! FeaturesCollectionViewCell
        
        cell.btnSelected.setTitle(arrFeatures[indexPath.row], for: .normal)
        
        cell.btnSelected.setTitleColor(
            arrFeaturesSelected[indexPath.row] ? UIColor.black : UIColor.white,
            for: .normal
        )
        
        cell.btnSelected.backgroundColor = arrFeaturesSelected[indexPath.row] ? UIColor.white : UIColor.clear
        
        cell.btnSelected.tag = indexPath.row
        cell.btnSelected.addTarget(self, action: #selector(btnSelected(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @IBAction func btnSelected(_ sender:UIButton) {
        for i in 0..<arrFeatures.count {
            
            arrFeaturesSelected[i] = (i == sender.tag) ? true : false
            collFeatures.reloadData()
        }
    }
    
}



class FeaturesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnSelected:UIButton!
}


extension CameraViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFiltersIcons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FiltersTableViewCell
        
        cell.lblFilterTitles.text = arrFiltersTitles[indexPath.row]
        cell.imgFilterIcon.image = UIImage (named:arrFiltersIcons[indexPath.row])
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            switchCamera()
        } else if indexPath.row == 1 {
            filter_Efect(true)
        } else if indexPath.row == 2 {
            filter_Efect(false)
        }
    }
    
    func filter_Efect(_ sender:Bool)  {

        let filters_EffectsVC = storyboard?.instantiateViewController(withIdentifier: "Filters_Effects_VC") as! Filters_Effects_VC
        
        filters_EffectsVC.isFilter = sender
        
        self.present(filters_EffectsVC, animated: true, completion: nil)
    }
    
}


class FiltersTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFilterIcon:UIImageView!
    @IBOutlet weak var lblFilterTitles:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}




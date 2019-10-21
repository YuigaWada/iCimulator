//
//  FakeImagePickerController.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/19.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

fileprivate typealias AVCaptureDevice = FakeCaptureDevice
fileprivate typealias AVCaptureSession = FakeCaptureSession
fileprivate typealias AVCaptureVideoPreviewLayer = FakePreviewLayer
fileprivate typealias AVCapturePhotoOutput = FakeCapturePhotoOutput
fileprivate typealias AVCapturePhotoCaptureDelegate = FakeCapturePhotoCaptureDelegate
fileprivate typealias AVCapturePhoto = FakeCapturePhoto
fileprivate typealias AVCaptureDeviceInput = FakeCaptureDeviceInput
fileprivate typealias AVCaptureMovieFileOutput = FakeCaptureMovieFileOutput
fileprivate typealias AVCaptureFileOutput = FakeCaptureFileOutput
fileprivate typealias AVCaptureFileOutputRecordingDelegate = FakeCaptureFileOutputRecordingDelegate
fileprivate typealias AVCaptureConnection = FakeCaptureConnection
fileprivate typealias AVCapturePhotoSettings = FakeCapturePhotoSettings



//UIImagePickerController
open class FakeImagePickerController: _FakeImagePickerController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var shotButton: UIView!
    @IBOutlet weak var shotButtonAcs1: UIView!
    @IBOutlet weak var shotButtonAcs2: UIView!
    
    private var captureSession = AVCaptureSession()
    private var mainCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var currentDevice: AVCaptureDevice?
    
    private var videoOutput: AVCaptureMovieFileOutput?
    private var isRecording: Bool = false
    
    private var photoOutput : AVCapturePhotoOutput?
    private weak var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    


    private lazy var bundle = Bundle(for: FakeImagePickerController.self)
    private var spyDelegate:FakeImagePickerControllerDelegate?
    
    override open var delegate: UINavigationControllerDelegate? {
        didSet { spyDelegate = delegate as? FakeImagePickerControllerDelegate }
    }
    


    
    //-MARK: Life Cycle
    convenience init() {
        self.init(rootViewController: UIViewController())
        self.modalPresentationStyle = .fullScreen // ** HACK **
    }
    
    override open func loadView() {
        guard let view = UINib(nibName: "FakeImagePickerController", bundle: self.bundle).instantiate(withOwner: self).first as? UIView else {return}

        self.view = view
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupIOs()
        setupPreviewLayer()
        captureSession.startRunning()
        setupTapGesture()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateShotButton()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkSourceType()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.cameraPreviewLayer = nil
    }
    

    //-MARK: Linked Method
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func tapGesture(_: UITapGestureRecognizer){
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        self.photoOutput!.capturePhoto(with: settings, delegate: self)
    }
    
    //-MARK: Setup
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    
    func setupDevice() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                backCamera = device
            }
        }
        
        currentDevice = mainCamera
    }
    
    func setupIOs() {
        
        let captureDeviceInput = try! AVCaptureDeviceInput(device: currentDevice!)
        captureSession.addInput(captureDeviceInput)
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
        
        
        videoOutput = AVCaptureMovieFileOutput()
        captureSession.addOutput(videoOutput!)
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    
        self.cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: self.cameraView.frame.width, height: self.cameraView.frame.height)
        self.cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGestureRecognizer.delegate = self
        self.shotButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateShotButton() {
        shotButton.layer.cornerRadius = shotButton.layer.frame.width / 2
        shotButtonAcs1.layer.cornerRadius = shotButtonAcs1.layer.frame.width / 2
        shotButtonAcs2.layer.cornerRadius = shotButtonAcs2.layer.frame.width / 2
    }
    
    
    //-MARK: Delegate Method
    public func photoOutput(_ output: FakeCapturePhotoOutput, didFinishProcessingPhoto photo: FakeCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            guard let delegate = self.spyDelegate else {return}
            let uiImage = UIImage(data: imageData)
            
            delegate.imagePickerController(self, didFinishPickingMediaWithInfo: [.originalImage: uiImage as Any])
        }
        
    }
    
    
    public func fileOutput(_ output: FakeCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [FakeCaptureConnection], error: Error?) {
       
    }
    
    
    //-MARK: Utility
    private func getRealType(_ type: SourceType)-> UIImagePickerController.SourceType {
        switch type {
        case .photoLibrary:
            return UIImagePickerController.SourceType.photoLibrary
        case .camera:
            return UIImagePickerController.SourceType.camera
        case .savedPhotosAlbum:
            return UIImagePickerController.SourceType.savedPhotosAlbum
        }
    }
    
    private func checkSourceType() {
        guard sourceType != .camera else {return}
        
        let realSourceType = getRealType(sourceType)
        guard UIImagePickerController.isSourceTypeAvailable(realSourceType)
            else { fatalError("Cannot open photo-library.") }
        
        let realImagePicker = UIImagePickerController()
        
        realImagePicker.sourceType = realSourceType
        realImagePicker.delegate = self.parent! as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.parent!.present(realImagePicker, animated: true, completion: nil)
    }
    
    
    
    //
    //    public init() {
    //        super.init()
    //        self.modalPresentationStyle = .fullScreen
    //    }
    //
    //    required public init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //        self.modalPresentationStyle = .fullScreen
    //    }
    
    
    
    
}


//public func UIImageWriteToSavedPhotosAlbum(_ image: UIImage, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?) {}
//
//public func UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_ videoPath: String) -> Bool { return true}
//
//public func UISaveVideoAtPathToSavedPhotosAlbum(_ videoPath: String, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?) {}

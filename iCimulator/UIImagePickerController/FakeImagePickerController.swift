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


//UIImagePickerController
open class FakeImagePickerController: UINavigationController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var shotButton: UIView!
    
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
    
    
    
    
    //-MARK: Disguise UIImagePickerController
    open class func isSourceTypeAvailable(_ sourceType: FakeImagePickerController.SourceType) -> Bool {return true}
    open class func availableMediaTypes(for sourceType: FakeImagePickerController.SourceType) -> [String]? {return ["camera"]}
    
    open class func isCameraDeviceAvailable(_ cameraDevice: UIImagePickerController.CameraDevice) -> Bool {return true}
    
    open class func isFlashAvailable(for cameraDevice: FakeImagePickerController.CameraDevice) -> Bool {return true}
    
    open class func availableCaptureModes(for cameraDevice: UIImagePickerController.CameraDevice) -> [NSNumber]? {return [1]}
    
    open var sourceType: FakeImagePickerController.SourceType = .camera
    open var mediaTypes: [String] = ["camera"]
    
    open var allowsEditing: Bool = true
    
    open var imageExportPreset: FakeImagePickerController.ImageURLExportPreset = .compatible
    
    open var videoMaximumDuration: TimeInterval = 60*60
    
    open var videoQuality: FakeImagePickerController.QualityType = .typeHigh
    
    open var videoExportPreset: String = "fake"
    
    open var showsCameraControls: Bool = true
    
    open lazy var cameraOverlayView: UIView? = self.view
    
    open var cameraViewTransform: CGAffineTransform = CGAffineTransform()
    
    open func takePicture() {}
    
    open func startVideoCapture() -> Bool {return true}
    
    open func stopVideoCapture() {}
    
    open var cameraCaptureMode: FakeImagePickerController.CameraCaptureMode = .photo
    
    open var cameraDevice: FakeImagePickerController.CameraDevice = .rear
    
    open var cameraFlashMode: FakeImagePickerController.CameraFlashMode = .auto
    
}

extension FakeImagePickerController{
    public enum SourceType : Int {
        case photoLibrary
        case camera
        case savedPhotosAlbum
    }
    public enum QualityType : Int {
        case typeHigh
        case typeMedium
        case typeLow
        @available(iOS 4.0, *)
        case type640x480
        @available(iOS 5.0, *)
        case typeIFrame1280x720
        @available(iOS 5.0, *)
        case typeIFrame960x540
    }
    public enum CameraCaptureMode : Int {
        case photo
        case video
    }
    public enum CameraDevice : Int {
        case rear
        case front
    }
    public enum CameraFlashMode : Int {
        case off
        case auto
        case on
    }
    @available(iOS 11.0, *)
    public enum ImageURLExportPreset : Int {
        case compatible
        case current
    }
    public struct InfoKey : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {self.rawValue = rawValue}
        
        public static let mediaType: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        public static let originalImage: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        public static let editedImage: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        public static let cropRect: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        public static let mediaURL: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        
        @available(iOS, introduced: 4.1, deprecated: 11.0, renamed: "UIImagePickerController.InfoKey.phAsset")
        public static let referenceURL: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        
        public static let mediaMetadata: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        public static let livePhoto: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        @available(iOS 11.0, *)
        public static let phAsset: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
        @available(iOS 11.0, *)
        public static let imageURL: FakeImagePickerController.InfoKey = .init(rawValue: "mediaType")
    }
}



public protocol FakeImagePickerControllerDelegate : UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: FakeImagePickerController, didFinishPickingMediaWithInfo info: [FakeImagePickerController.InfoKey : Any])
    
    //    @objc optional func imagePickerControllerDidCancel(_ picker: FakeImagePickerController)
}






//public func UIImageWriteToSavedPhotosAlbum(_ image: UIImage, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?) {}
//
//public func UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_ videoPath: String) -> Bool { return true}
//
//public func UISaveVideoAtPathToSavedPhotosAlbum(_ videoPath: String, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?) {}

//
//  _FakeImagePickerController.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class _FakeImagePickerController: UINavigationController {
    
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




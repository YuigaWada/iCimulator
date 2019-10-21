//
//  _FakeCapturePhotoOutput.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import AVFoundation
import CoreGraphics
import CoreMedia
import Foundation

open class _FakeCapturePhotoOutput : FakeCaptureOutput {
    public override init() {}
    open func capturePhoto(with settings: FakeCapturePhotoSettings, delegate: FakeCapturePhotoCaptureDelegate) {}
    open var preparedPhotoSettingsArray: [FakeCapturePhotoSettings] = [.init()]
    open func setPreparedPhotoSettingsArray(_ preparedPhotoSettingsArray: [FakeCapturePhotoSettings], completionHandler: ((Bool, Error?) -> Void)? = nil) {}
    open var __availablePhotoPixelFormatTypes: [NSNumber] = [1]
    open var availablePhotoCodecTypes: [AVVideoCodecType] = [.jpeg]
    open var __availableRawPhotoPixelFormatTypes: [NSNumber] = [1]
    open var availablePhotoFileTypes: [AVFileType] = [.mp4]
    open var availableRawPhotoFileTypes: [AVFileType] = [.mp4]
    open func supportedPhotoPixelFormatTypes(for fileType: AVFileType) -> [NSNumber] { return [1] }
    open func supportedPhotoCodecTypes(for fileType: AVFileType) -> [AVVideoCodecType]{ return [.jpeg] }
    open func supportedRawPhotoPixelFormatTypes(for fileType: AVFileType) -> [NSNumber] { return [1] }
    open var maxPhotoQualityPrioritization: FakeCapturePhotoOutput.QualityPrioritization = .balanced
    open var isStillImageStabilizationSupported: Bool = true
    open var isStillImageStabilizationScene: Bool = true
    open var isVirtualDeviceFusionSupported: Bool = true
    open var isDualCameraFusionSupported: Bool = true
    open var isVirtualDeviceConstituentPhotoDeliverySupported: Bool = true
    open var isDualCameraDualPhotoDeliverySupported: Bool = true
    open var isVirtualDeviceConstituentPhotoDeliveryEnabled: Bool = true
    open var isDualCameraDualPhotoDeliveryEnabled: Bool = true
    open var isCameraCalibrationDataDeliverySupported: Bool = true
    open var __supportedFlashModes: [NSNumber] = [1]
    open var isAutoRedEyeReductionSupported: Bool = true
    open var isFlashScene: Bool = true
    open var photoSettingsForSceneMonitoring: FakeCapturePhotoSettings? = .init()
    open var isHighResolutionCaptureEnabled: Bool = true
    open var maxBracketedCapturePhotoCount: Int = 1
    open var isLensStabilizationDuringBracketedCaptureSupported: Bool = true
    open var isLivePhotoCaptureSupported: Bool = true
    open var isLivePhotoCaptureEnabled: Bool = true
    open var isLivePhotoCaptureSuspended: Bool = true
    open var isLivePhotoAutoTrimmingEnabled: Bool = true
    open var availableLivePhotoVideoCodecTypes: [AVVideoCodecType] = [.jpeg]
    open class func jpegPhotoDataRepresentation(forJPEGSampleBuffer JPEGSampleBuffer: FakeCMSampleBuffer, previewPhotoSampleBuffer: FakeCMSampleBuffer?) -> Data? { return nil }
    open class func dngPhotoDataRepresentation(forRawSampleBuffer rawSampleBuffer: FakeCMSampleBuffer, previewPhotoSampleBuffer: FakeCMSampleBuffer?) -> Data? { return nil }

    public var supportedFlashModes: [FakeCaptureDevice.FlashMode] = [.auto]
     public var availablePhotoPixelFormatTypes: [OSType] = [.max]
     public var availableRawPhotoPixelFormatTypes: [OSType] = [.max]

    public enum QualityPrioritization : Int {
        case speed
        case balanced
        case quality
    }

    open var isDepthDataDeliverySupported: Bool = true
    open var isDepthDataDeliveryEnabled: Bool = true
    open var isPortraitEffectsMatteDeliverySupported: Bool = true
    open var isPortraitEffectsMatteDeliveryEnabled: Bool = true
//    open var availableSemanticSegmentationMatteTypes: [AVSemanticSegmentationMatte.MatteType] = [.hair]
//    open var enabledSemanticSegmentationMatteTypes: [AVSemanticSegmentationMatte.MatteType] = [.hair]
}



open class FakeCapturePhotoBracketSettings : FakeCapturePhotoSettings {
    public init(rawPixelFormatType: OSType, processedFormat: [String : Any]?, bracketedSettings: [AVCaptureBracketedStillImageSettings]) {self.bracketedSettings = bracketedSettings}
    public init(rawPixelFormatType: OSType, rawFileType: AVFileType?, processedFormat: [String : Any]?, processedFileType: AVFileType?, bracketedSettings: [AVCaptureBracketedStillImageSettings]) {self.bracketedSettings = bracketedSettings}

    open var bracketedSettings: [AVCaptureBracketedStillImageSettings] = []
    open var isLensStabilizationEnabled: Bool = true
}

open class FakeCaptureResolvedPhotoSettings : NSObject {
    open var uniqueID: Int64 = 1
    open var photoDimensions: CMVideoDimensions = .init()
    open var rawPhotoDimensions: CMVideoDimensions = .init()
    open var previewDimensions: CMVideoDimensions = .init()
    open var embeddedThumbnailDimensions: CMVideoDimensions = .init()
    open var rawEmbeddedThumbnailDimensions: CMVideoDimensions = .init()
    open var portraitEffectsMatteDimensions: CMVideoDimensions = .init()
//    open func dimensionsForSemanticSegmentationMatte(ofType semanticSegmentationMatteType: AVSemanticSegmentationMatte.MatteType) -> CMVideoDimensions {return .init()}
    open var livePhotoMovieDimensions: CMVideoDimensions = .init()
    open var isFlashEnabled: Bool = true
    open var isRedEyeReductionEnabled: Bool = true
    open var isStillImageStabilizationEnabled: Bool = true
    open var isVirtualDeviceFusionEnabled: Bool = true
    open var isDualCameraFusionEnabled: Bool = true
    open var expectedPhotoCount: Int = 1
    open var photoProcessingTimeRange: CMTimeRange = .init()
}


open class _FakeCapturePhoto : NSObject {
    open var timestamp: CMTime = .init()
    open var isRawPhoto: Bool = true
    open var pixelBuffer: CVPixelBuffer?
    open var previewPixelBuffer: CVPixelBuffer?
    open var embeddedThumbnailPhotoFormat: [String : Any]?
    open var depthData: AVDepthData?
//    open var portraitEffectsMatte: AVPortraitEffectsMatte?
//    open func semanticSegmentationMatte(for semanticSegmentationMatteType: AVSemanticSegmentationMatte.MatteType) -> AVSemanticSegmentationMatte? {return nil}
    open var metadata: [String : Any] = ["":""]
    open var cameraCalibrationData: AVCameraCalibrationData?
    open var resolvedSettings: FakeCaptureResolvedPhotoSettings = FakeCaptureResolvedPhotoSettings()
    open var photoCount: Int = 1
    open var sourceDeviceType: FakeCaptureDevice.DeviceType?

    open func fileDataRepresentation() -> Data? {return nil}
    open func fileDataRepresentation(with customizer: FakeCapturePhotoFileDataRepresentationCustomizer) -> Data? {return nil}
    open func fileDataRepresentation(withReplacementMetadata replacementMetadOata: [String : Any]?, replacementEmbeddedThumbnailPhotoFormat: [String : Any]?, replacementEmbeddedThumbnailPixelBuffer: CVPixelBuffer?, replacementDepthData: AVDepthData?) -> Data? {return nil}
    open func cgImageRepresentation() -> Unmanaged<CGImage>? {return nil}
    open func previewCGImageRepresentation() -> Unmanaged<CGImage>? {return nil}
    
    open var bracketSettings: AVCaptureBracketedStillImageSettings?
    open var sequenceCount: Int = 1
    open var lensStabilizationStatus: FakeCaptureDevice.LensStabilizationStatus = .active
}

extension FakeCaptureDevice {
    public enum LensStabilizationStatus : Int {
        case unsupported
        case off
        case active
        case outOfRange
        case unavailable
    }
}


@objc public protocol FakeCapturePhotoFileDataRepresentationCustomizer : NSObjectProtocol {
    @objc optional func replacementMetadata(for photo: FakeCapturePhoto) -> [String : Any]?
    @objc optional func replacementEmbeddedThumbnailPixelBuffer(withPhotoFormat replacementEmbeddedThumbnailPhotoFormatOut: AutoreleasingUnsafeMutablePointer<NSDictionary?>, for photo: FakeCapturePhoto) -> Unmanaged<CVPixelBuffer>?
    @objc optional func replacementDepthData(for photo: FakeCapturePhoto) -> AVDepthData?
//    @objc optional func replacementPortraitEffectsMatte(for photo: FakeCapturePhoto) -> AVPortraitEffectsMatte?
//    @objc optional func replacementSemanticSegmentationMatte(ofType semanticSegmentationMatteType: AVSemanticSegmentationMatte.MatteType, for photo: FakeCapturePhoto) -> AVSemanticSegmentationMatte?
}

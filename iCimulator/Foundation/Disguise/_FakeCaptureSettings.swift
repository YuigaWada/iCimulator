//
//  _FakeCaptureSettings.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class _FakeCapturePhotoSettings: NSObject {
    
    public override init() {}
    public convenience init(format: [String : Any]?) {self.init()}
    public convenience init(rawPixelFormatType: OSType) {self.init()}
    public convenience init(rawPixelFormatType: OSType, processedFormat: [String : Any]?) {self.init()}
    public convenience init(rawPixelFormatType: OSType, rawFileType: AVFileType?, processedFormat: [String : Any]?, processedFileType: AVFileType?) {self.init()}
    public convenience init(from photoSettings: FakeCapturePhotoSettings) {self.init()}
    
    open var uniqueID: Int64 = 0
    open var format: [String : Any]? = ["":""]
    open var processedFileType: AVFileType? = .mp4
    open var rawPhotoPixelFormatType: OSType = .max
    open var rawFileType: AVFileType? = .mp4
    open var flashMode: FakeCaptureDevice.FlashMode = .auto
    open var isAutoRedEyeReductionEnabled = true
    /* If u wanna use photoQualityPrioritization, comment out below code! */
    //open var photoQualityPrioritization: FakeCapturePhotoOutput.QualityPrioritization = .quality
    
    open var isAutoStillImageStabilizationEnabled = true
    open var isAutoVirtualDeviceFusionEnabled = true
    open var isAutoDualCameraFusionEnabled = true
    open lazy var virtualDeviceConstituentPhotoDeliveryEnabledDevices: [FakeCaptureDevice] = [FakeCaptureDevice()]
    open var isDualCameraDualPhotoDeliveryEnabled = true
    open var isHighResolutionPhotoEnabled = true
    open var isDepthDataDeliveryEnabled = true
    open var embedsDepthDataInPhoto = true
    open var isDepthDataFiltered = true
    open var isCameraCalibrationDataDeliveryEnabled = true
    open var isPortraitEffectsMatteDeliveryEnabled = true
    open var embedsPortraitEffectsMatteInPhoto = true

    /* If u wanna use enabledSemanticSegmentationMatteTypes, comment out below code! */
    //open var enabledSemanticSegmentationMatteTypes: [AVSemanticSegmentationMatte.MatteType] = [.hair]
    
    open var embedsSemanticSegmentationMattesInPhoto = true
    open var metadata: [String : Any] = ["":""]
    open var livePhotoMovieFileURL: URL?
    open var livePhotoVideoCodecType: AVVideoCodecType = .jpeg
    open var livePhotoMovieMetadata: [AVMetadataItem]! = []
    open var __availablePreviewPhotoPixelFormatTypes: [NSNumber] = [1]
    open var previewPhotoFormat: [String : Any]? = ["":""]
    open var availableEmbeddedThumbnailPhotoCodecTypes: [AVVideoCodecType] = [.jpeg]
    open var embeddedThumbnailPhotoFormat: [String : Any]? = ["":""]
    open var availableRawEmbeddedThumbnailPhotoCodecTypes: [AVVideoCodecType] = [.jpeg]
    open var rawEmbeddedThumbnailPhotoFormat: [String : Any]? = ["":""]
    
    public var availablePreviewPhotoPixelFormatTypes: [OSType] = [.max]
}

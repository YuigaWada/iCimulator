//
//  _FakeCaptureConnection.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class _FakeCaptureConnection : NSObject {
    
    public override init() {
        
    }
    
    
    public init(inputPorts ports: [AVCaptureInput.Port], output: AVCaptureOutput){}
    public init(inputPort port: AVCaptureInput.Port, videoPreviewLayer layer: FakeCaptureVideoPreviewLayer) {}
    
    open var inputPorts: [AVCaptureInput.Port] = []
    open var output: FakeCaptureOutput? = FakeCaptureOutput()
    
    open weak var videoPreviewLayer: FakeCaptureVideoPreviewLayer?
    open var isEnabled: Bool = true
    open var isActive: Bool = true
    open var audioChannels: [AVCaptureAudioChannel] = []
    open var isVideoMirroringSupported: Bool = true
    open var isVideoMirrored: Bool = false
    
    open var automaticallyAdjustsVideoMirroring: Bool = true
    open var isVideoOrientationSupported: Bool = true
    open var videoOrientation: AVCaptureVideoOrientation = .portrait
    
    open var videoMaxScaleAndCropFactor: CGFloat = 10
    
    open var videoScaleAndCropFactor: CGFloat = 10
    
    open var preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode = .auto
    
    open var activeVideoStabilizationMode: AVCaptureVideoStabilizationMode = .auto
    
    open var isVideoStabilizationSupported: Bool = true
    
    open var isVideoStabilizationEnabled: Bool = true
    
    open var enablesVideoStabilizationWhenAvailable: Bool = true
    
    open var isCameraIntrinsicMatrixDeliverySupported: Bool = true
    
    open var isCameraIntrinsicMatrixDeliveryEnabled: Bool = true
}

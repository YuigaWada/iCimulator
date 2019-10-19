//
//  FakeCaptureStillImageOutput.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation


open class FakeCMSampleBuffer: NSObject {
    internal var spy: Data?
    
    internal init(spy: Data) {
        self.spy = spy
    }
}


/*
 AVCaptureStillImageOutput is deprecated,
 but many old libraries seem to be using these deprecated classes / methods so I've dicided to suppport.
 */

//@available(iOS, deprecated: 10.0, message: "Use AVCapturePhotoOutput instead.")
open class FakeCaptureStillImageOutput: FakeCaptureOutput {

    public override init() {
        
    }
    
    open func captureStillImageAsynchronously(from connection: FakeCaptureConnection, completionHandler handler: @escaping (FakeCMSampleBuffer?, Error?) -> Void) {
        guard let session = self.session else { return }
        
        let imageRawData = self.getCapturedImage(session: session)
        let fakeBuffer = FakeCMSampleBuffer(spy: imageRawData)
        
        handler(fakeBuffer, nil)
    }
    
    internal func getCapturedImage(session: FakeCaptureSession)-> Data {
        guard let main = session.mainCenter else { fatalError("No Session.") }
        
        return main.captureImage()
    }
    
    open func prepareToCaptureStillImageBracket(from connection: FakeCaptureConnection, withSettingsArray settings: [AVCaptureBracketedStillImageSettings], completionHandler handler: @escaping (Bool, Error?) -> Void) { handler(true,nil) }
    
    
    open func captureStillImageBracketAsynchronously(from connection: FakeCaptureConnection, withSettingsArray settings: [AVCaptureBracketedStillImageSettings], completionHandler handler: @escaping (CMSampleBuffer?, AVCaptureBracketedStillImageSettings?, Error?) -> Void) {
        guard let session = self.session else { return }
        
        let imageRawData = self.getCapturedImage(session: session)
        handler(imageRawData.toCMSampleBuffer(), settings[0], nil)
    }
    
    open class func jpegStillImageNSDataRepresentation(_ jpegSampleBuffer: FakeCMSampleBuffer) -> Data? {
        return jpegSampleBuffer.spy
    }
    
    open var outputSettings: [String : Any] = ["": ""]
    open var availableImageDataCVPixelFormatTypes: [NSNumber] = [1.0]
    open var availableImageDataCodecTypes: [AVVideoCodecType] = .init()
    open var isStillImageStabilizationSupported: Bool = true
    open var automaticallyEnablesStillImageStabilizationWhenAvailable: Bool = true
    open var isStillImageStabilizationActive: Bool = true
    open var isHighResolutionStillImageOutputEnabled: Bool = true
    open var isCapturingStillImage: Bool = true

    open var maxBracketedCaptureStillImageCount: Int = 20
    open var isLensStabilizationDuringBracketedCaptureSupported: Bool = true
    open var isLensStabilizationDuringBracketedCaptureEnabled = true
}

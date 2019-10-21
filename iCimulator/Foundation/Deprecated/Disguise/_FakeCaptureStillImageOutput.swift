//
//  _FakeCaptureStillImageOutput.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class _FakeCaptureStillImageOutput: FakeCaptureOutput {
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


open class FakeCMSampleBuffer: NSObject {
    internal var spy: Data?
    
    internal init(spy: Data) {
        self.spy = spy
    }
}

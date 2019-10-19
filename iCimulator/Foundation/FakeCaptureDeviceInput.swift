//
//  FakeCaptureDeviceInput.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/16.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class FakeCaptureInput: NSObject {
    open var ports: [AVCaptureInput.Port] = []
}

open class FakeCaptureDeviceInput: FakeCaptureInput {
    
    public init(device: FakeCaptureDevice) throws {

    }
    
    open var device: FakeCaptureDevice = FakeCaptureDevice()
    open var unifiedAutoExposureDefaultsEnabled: Bool = true
    open var videoMinFrameDurationOverride: CMTime = CMTime()
    
    open func ports(for mediaType: AVMediaType?, sourceDeviceType: AVCaptureDevice.DeviceType?, sourceDevicePosition: AVCaptureDevice.Position) -> [AVCaptureInput.Port] {
        return []
    }
}


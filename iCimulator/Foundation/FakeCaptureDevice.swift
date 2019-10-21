//
//  FakeCaptureDevice.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/18.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

//Checked: ^(?=.*:.+)(?!.*(=|func|class|init|enum|struct|\()).*$

import AVFoundation
import CoreGraphics
import CoreMedia
import Foundation

open class FakeCaptureDevice : _FakeCaptureDevice {
    
    open class func devices() -> [FakeCaptureDevice] {
        let fake1 = FakeCaptureDevice()
        let fake2 = FakeCaptureDevice()
        
        fake1.position = .back
        fake2.position = .front
        
        return [fake1, fake2]
    }
    
    private func createFakeDeviceInfo(_  position: FakeCaptureDevice.Position)-> FakeCaptureDevice {
        let fake = FakeCaptureDevice()
        fake.position = position
        
        return fake
    }
    
    open class func devices(for mediaType: AVMediaType) -> [FakeCaptureDevice] {
        return self.devices()
    }
    
    open class func `default`(for mediaType: AVMediaType) -> FakeCaptureDevice? {
        let fake = FakeCaptureDevice()
        fake.position = .back
        return fake
    }
}

//
//  FakeCaptureSession.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class FakeCaptureSession: NSObject {
    
    //-MARK: Original
    open weak var mainCenter: FakePreviewLayer?

    open func addOutput(_ output: FakeCaptureOutput) {
        outputs.append(output)
        
        output.session = self
    }
    
    //TODO: FIX IT.
    open func addOutput(_ output: FakeCapturePhotoOutput) {
//         outputs.append(output as! FakeCaptureOutput)
        //FakeCapturePhotoOutputの親元が既存のAVCapture~~クラスなのでキャストできない
        
        output.session = self
    }
    
    open func addOutput(_ output: FakeCaptureMovieFileOutput) {
        outputs.append(output)
        
        output.session = self
    }
    
    open func addOutput(_ output: FakeCaptureFileOutput) {
        outputs.append(output)
        
        output.session = self
    }
    
    //-MARK: For disguising
    open var inputs: [FakeCaptureInput] = []
    open var isInterrupted: Bool = false
    open var usesApplicationAudioSession: Bool = false
    open var automaticallyConfiguresApplicationAudioSession: Bool = true
    open var automaticallyConfiguresCaptureDeviceForWideColor: Bool = true
    open var masterClock: CMClock? = nil
    open var sessionPreset: FakeCaptureSession.Preset = .high
    open var outputs: [FakeCaptureOutput] = []
    open var isRunning: Bool = true
    
    open func addOutput(_ output: AVCaptureOutput) {}
    
    open func addInput(_ input: FakeCaptureDeviceInput) {}
    open func canAddInput(_ input: FakeCaptureInput) -> Bool { return true}
    open func addInput(_ input: FakeCaptureInput) {}
    open func removeInput(_ input: FakeCaptureInput) {}
    
    
    open func canAddOutput(_ output: FakeCaptureOutput) -> Bool { return true }
    open func removeOutput(_ output: FakeCaptureOutput) {}
    open func addOutputWithNoConnections(_ output: FakeCaptureOutput) {}
    
    open func canAddOutput(_ output: FakeCapturePhotoOutput) -> Bool { return true }
    open func removeOutput(_ output: FakeCapturePhotoOutput) {}
    open func addOutputWithNoConnections(_ output: FakeCapturePhotoOutput) {}
    
    
    open func addInputWithNoConnections(_ input: FakeCaptureInput) {}

    open func canAddConnection(_ connection: FakeCaptureConnection) -> Bool { return true}
    open func addConnection(_ connection: FakeCaptureConnection) {}
    open func removeConnection(_ connection: FakeCaptureConnection) {}
    open func canSetSessionPreset(_ preset: FakeCaptureSession.Preset) -> Bool {return true}
    open func beginConfiguration() {}
    open func commitConfiguration() {}
    open func startRunning() {}
    open func stopRunning() {}
    
    public struct Preset : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) { self.rawValue=rawValue }
    }
    
    public override init() {}
}



public extension FakeCaptureSession.Preset {
    static let photo = FakeCaptureSession.Preset(rawValue: "photo")
    static let high = FakeCaptureSession.Preset(rawValue: "high")
    static let medium = FakeCaptureSession.Preset(rawValue: "medium")
    static let low = FakeCaptureSession.Preset(rawValue: "low")
    static let cif352x288 = FakeCaptureSession.Preset(rawValue: "cif352x288")
    static let vga640x480 = FakeCaptureSession.Preset(rawValue: "vga640x480")
    static let hd1280x720 = FakeCaptureSession.Preset(rawValue: "hd1280x720")
    static let hd1920x1080 = FakeCaptureSession.Preset(rawValue: "hd1920x1080")
    static let hd4K3840x2160 = FakeCaptureSession.Preset(rawValue: "hd4K3840x2160")
    static let iFrame960x540 = FakeCaptureSession.Preset(rawValue: "iFrame960x540")
    static let iFrame1280x720 = FakeCaptureSession.Preset(rawValue: "iFrame1280x720")
    static let inputPriority = FakeCaptureSession.Preset(rawValue: "inputPriority")
}

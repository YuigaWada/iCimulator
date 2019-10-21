//
//  FakeCaptureOutput.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation


//-MARK: Protocol
@objc public protocol FakeCapturePhotoCaptureDelegate: NSObjectProtocol {
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, didFinishProcessingPhoto photo: FakeCapturePhoto, error: Error?)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?)
    @objc optional func photoOutput(_ output: FakeCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?)
}

@objc public protocol FakeCaptureFileOutputRecordingDelegate : NSObjectProtocol {
    @objc optional func fileOutput(_ output: FakeCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [FakeCaptureConnection])
    @objc func fileOutput(_ output: FakeCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [FakeCaptureConnection], error: Error?)
}




//-MARK: Output Classes

open class FakeCaptureOutput : NSObject {
    internal weak var main: iCimulatorFoundation? {
        guard let session = self.session else { return nil }
        
        return session.mainCenter
    }
    internal weak var session: FakeCaptureSession?
    
    
    
    
    open var connections: [FakeCaptureConnection] = []
    open func connection(with mediaType: AVMediaType) -> FakeCaptureConnection? {
        return FakeCaptureConnection()
    }
    open func transformedMetadataObject(for metadataObject: AVMetadataObject, connection: FakeCaptureConnection) -> AVMetadataObject? {return nil}
    open func metadataOutputRectConverted(fromOutputRect rectInOutputCoordinates: CGRect) -> CGRect {
        return CGRect().getScreenFit()
    }
    open func outputRectConverted(fromMetadataOutputRect rectInMetadataOutputCoordinates: CGRect) -> CGRect {
        return CGRect().getScreenFit()
    }
    
    public enum DataDroppedReason : Int {
        case none
        case lateData
        case outOfBuffers
        case discontinuity
    }
}


open class FakeCapturePhoto: _FakeCapturePhoto {
    public var capturedImage: Data? = nil
    
    init(workaround _: Void = ()) {
        
    }

    init(capturedImage: Data) {
        self.capturedImage = capturedImage
    }
    
    public override func fileDataRepresentation()-> Data? {
        return capturedImage
    }
}


open class FakeCapturePhotoOutput: _FakeCapturePhotoOutput {
        
    private lazy var photo = FakeCapturePhoto()
    
    public override func capturePhoto(with settings: FakeCapturePhotoSettings, delegate: FakeCapturePhotoCaptureDelegate) {
        guard let session = self.session else {return}
        
        self.getCapturedImage(session: session)
        //get captured image.
        delegate.photoOutput!(self, didFinishProcessingPhoto: self.photo, error: nil)
    }
    
    internal func getCapturedImage(session: FakeCaptureSession) {
        guard let main = session.mainCenter else {return}
        
        photo.capturedImage = main.captureImage()
    }
    
    //Deprecated: iOS 10.0 - 11.0
    open override class func jpegPhotoDataRepresentation(forJPEGSampleBuffer JPEGSampleBuffer: FakeCMSampleBuffer, previewPhotoSampleBuffer: FakeCMSampleBuffer?) -> Data? {
        return JPEGSampleBuffer.spy
    }
    
}

open class FakeCaptureFileOutput: FakeCaptureOutput {
    
    private var delegate: FakeCaptureFileOutputRecordingDelegate?
    
    open var outputFileURL: URL?
    open func startRecording(to outputFileURL: URL, recordingDelegate delegate: FakeCaptureFileOutputRecordingDelegate) {
        guard let main = self.main else { return }
        
        main.startRecording()
        self.isRecording = true
        self.delegate = delegate
    }
    
    open func stopRecording() {
        guard let main = self.main else { return }
        
        self.isRecording = false
        main.stopRecording { url in
            self.delegate?.fileOutput(self, didFinishRecordingTo: url, from: [], error: nil)
        }
    }
 
    open var isRecording: Bool = false
    open var recordedDuration: CMTime = CMTime()
    open var recordedFileSize: Int64 = 0
    open var maxRecordedDuration: CMTime = CMTime(seconds: 1.0 * 60 * 60 * 24, preferredTimescale: .max)
    open var maxRecordedFileSize: Int64 = 1000000
    open var minFreeDiskSpaceLimit: Int64 = 1000000
}


open class FakeCaptureMovieFileOutput: FakeCaptureFileOutput {
    
    open var movieFragmentInterval: CMTime = CMTime()
    open var metadata: [AVMetadataItem]?
    open var availableVideoCodecTypes: [AVVideoCodecType] = []
    
    open func supportedOutputSettingsKeys(for connection: FakeCaptureConnection) -> [String] { return [] }
    open func outputSettings(for connection: FakeCaptureConnection) -> [String : Any] { return [:] }
    open func setOutputSettings(_ outputSettings: [String : Any]?, for connection: FakeCaptureConnection) {}
    open func recordsVideoOrientationAndMirroringChangesAsMetadataTrack(for connection: FakeCaptureConnection) -> Bool  { return true }
    open func setRecordsVideoOrientationAndMirroringChangesAsMetadataTrack(_ doRecordChanges: Bool, for connection: FakeCaptureConnection) {}
}

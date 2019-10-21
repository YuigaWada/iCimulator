//
//  _FakePreviewLayer.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/21.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation


open class _FakeCaptureVideoPreviewLayer: CALayer {
  open var videoGravity: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            switch self.videoGravity
            {
            case .resizeAspect:
                self.updateGravity(gravity: .resizeAspect)
            case .resize:
                self.updateGravity(gravity: .resize)
            case .resizeAspectFill:
                self.updateGravity(gravity: .resizeAspectFill)
            default:
                self.updateGravity(gravity: nil)
            }
            
            if let playerLayer = self.playerLayer {
                playerLayer.videoGravity = self.videoGravity
            }
        }
    }
    
    open var isPreviewing: Bool = false
    open var session: FakeCaptureSession?
    open var connection: FakeCaptureConnection?
    open var outputs: [FakeCaptureOutput] = []
    
    private var fakeSession: FakeCaptureSession?
    required public init(session: FakeCaptureSession) {
        super.init()
        setup()
        setSession(session: session)
    }
    
    required public init(sessionWithNoConnection session: FakeCaptureSession) {
        super.init()
        setup()
        setSession(session: session)
    }
    
    private func updateGravity(gravity: CALayerContentsGravity?) {
        guard gravity != nil else { return }
        
        self.contentsGravity = gravity!
    }
    
    open func setSessionWithNoConnection(_ session: FakeCaptureSession) {
        setSession(session: session)
    }
    
    open func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint {
        let width = CGRect().getScreenFit().width
        let height = CGRect().getScreenFit().height
        
        return CGPoint(x: pointInLayer.x / width, y: pointInLayer.y / height)
    }
    
    open func layerPointConverted(fromCaptureDevicePoint captureDevicePointOfInterest: CGPoint) -> CGPoint {
        return captureDevicePointConverted(fromLayerPoint: captureDevicePointOfInterest)
    }
    
    open func metadataOutputRectConverted(fromLayerRect rectInLayerCoordinates: CGRect) -> CGRect {
        return rectInLayerCoordinates
    }
    
    open func layerRectConverted(fromMetadataOutputRect rectInMetadataOutputCoordinates: CGRect) -> CGRect {
        return rectInMetadataOutputCoordinates
    }
    
    open func transformedMetadataObject(for metadataObject: AVMetadataObject) -> AVMetadataObject? {
        return metadataObject
    }
    
    
}



//internal protocol FakeAVCaptureVideoPreviewLayer {
//    //cf. AVCaptureVideoPreviewLayer
//    var videoGravity: AVLayerVideoGravity { get set }
//    var outputs: [FakeCaptureOutput] { get }
//
//    @available(iOS 13.0, *)
//    var isPreviewing: Bool { get set }
//
//    var session: FakeCaptureSession? { get set }
//    var connection: FakeCaptureConnection? { get }
//
//    init(session: FakeCaptureSession)
//    init(sessionWithNoConnection session: FakeCaptureSession)
//
//    func setSessionWithNoConnection(_ session: FakeCaptureSession)
//    func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint
//    func layerPointConverted(fromCaptureDevicePoint captureDevicePointOfInterest: CGPoint) -> CGPoint
//    func metadataOutputRectConverted(fromLayerRect rectInLayerCoordinates: CGRect) -> CGRect
//    func layerRectConverted(fromMetadataOutputRect rectInMetadataOutputCoordinates: CGRect) ->CGRect
//    func transformedMetadataObject(for metadataObject: AVMetadataObject) -> AVMetadataObject?
//}

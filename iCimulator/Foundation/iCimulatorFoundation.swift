//
//  iCimulatorFoundation.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

public typealias FakePreviewLayer = iCimulatorFoundation
public typealias FakeCaptureVideoPreviewLayer = iCimulatorFoundation
open class iCimulatorFoundation: CALayer { //** MAIN CLASS **//
    
    //-MARK: Original
    private var previewType: PreviewType?
    private var plistArgument: String?

    private var capturedImage: Data? = nil
    private var avPlayer: AVPlayerLooper?
    private var avQueuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var stopWatch: StopWatch = StopWatch()
    private var recordingStartTime: CMTime?
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        
        if playerLayer != nil {
            playerLayer!.frame = self.frame
        }
    }
    
    
    //-MARK: Setup
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    public override init()
    {
        super.init()
        setup()
    }
    
    private func setup() {
        self.checkPreviewType()
        self.generateFakeLayer()
    }
    
    private func setSession(session: FakeCaptureSession) {
        session.mainCenter = self
        self.fakeSession = session
    }
    
    private func checkPreviewType() {
        guard let plistPath = Bundle.main.path(forResource: "iCimulator", ofType:"plist") else { fatalError("Failed to read plist.") }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: plistPath))
            let plist = try PropertyListDecoder().decode(iCimulatorPlist.self, from: data)
            
            self.previewType = PreviewType(rawValue: plist.Type)
            self.plistArgument = plist.Argument
            
        } catch let e {
            fatalError("Failed to read plist: \(e)")
        }
    }
    
    
    //-MARK: Generating Fake Layer
    private func generateFakeLayer() {
        guard let previewType = self.previewType else { fatalError("Unknown Type. (written on iCimulator.plist)") }
        
        switch previewType {
        case .StaticImage:
            self.generateStaticImageLayer()
            
        case .LoopedMovie:
            self.generateVideoLayer(loop: true)
            
        case .NonLoopedMovie:
            fatalError("Deprecated.")
            
        case .MacCamera:
            print("debug")
                    
        case .Adhoc:
            print("debug")
        }
    }
    
    private func generateStaticImageLayer() {
        guard let imagePath = plistArgument else { return }
        guard let image = UIImage(contentsOfFile: imagePath) else { fatalError("Invalid image path.") }
        
        self.contents = image.cgImage
    }
    
    private func generateVideoLayer(loop: Bool) {
        guard let videoPath = plistArgument else { return }
        let url = URL(fileURLWithPath: videoPath)
        
        let playerItem = AVPlayerItem(asset: AVAsset(url: url))
        self.avQueuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        self.avPlayer = AVPlayerLooper(player: avQueuePlayer!, templateItem: playerItem)
        playerLayer = AVPlayerLayer(player: self.avQueuePlayer!)
        
        playerLayer!.frame = CGRect().getScreenFit()
        self.addSublayer(playerLayer!)
        self.avQueuePlayer!.play()
        //if loop { self.avPlayer!.automateLoop() }
    }
    
    
    //-MARK: Capture Method
    private func captureStaticImage()->Data {
        guard let data = (self.contents! as! CGImage).toData() else {fatalError("iCimulator: Internal Error...")}
        
        return data
    }
    
    private func captureVideo()-> Data{
        guard let avQueuePlayer = self.avQueuePlayer else {fatalError("iCimulator: Unknown Error")}
        guard let image = avQueuePlayer.shotPhoto() else {fatalError("iCimulator: Unknown Error")}
        
        return image.jpegData(compressionQuality: 1.0)!
    }

    
    
    
    //-MARK: Record Video Method
    private func convertStillImage2Video(_ interval: Int, completion: @escaping UrlFunction) {
        let image = self.contents! as! CGImage
        image.toVideo(seconds: interval, completion)
    }
    
    
    private func shapeVideo(_ interval: Int, completion: @escaping UrlFunction) {
      
        /*
        self.recordingStartTime //t1
        interval64 // t3
         
        t1~t (BLOCK-1) → (0~t) * k  (BLOCK-2) → 0~t2 (BLOCK-3)
         */
        guard let videoDuration = avQueuePlayer?.currentItem?.duration.seconds else { return }//t
        guard videoDuration > 0.0 else { fatalError("iCimulator: Division By Zero Error.") }
        
        let skipLoopCount = floor((Double(interval) + recordingStartTime!.seconds - videoDuration) / videoDuration) //k
        let stopRecordPoint = videoDuration - (videoDuration * (skipLoopCount + 1) - recordingStartTime!.seconds ) //t2
        
        guard let videoPath = self.plistArgument else { return }
        let videoUrl = URL(fileURLWithPath: videoPath)
        
        let videoBlock1 = [recordingStartTime!.seconds, videoDuration]
        let videoBlock2 = [0.0, videoDuration]
        let videoBlock3 = [0.0, stopRecordPoint]
        let looped = recordingStartTime!.seconds + Double(interval) >= videoDuration
        
        
        if !looped {
            self.trimVideo(videoUrl,timeRange: [recordingStartTime!.seconds,
                                                recordingStartTime!.seconds + Double(interval)],
                                                completion: completion)
            return
        }
        
        //If looped == true:
        var videoUrls: [URL] = []
        var completeCount: Int = 0
        
        for timeBlock in [videoBlock1, videoBlock2, videoBlock3] {
            self.trimVideo(videoUrl, timeRange: timeBlock) { [weak self] videoUrl in
                videoUrls.append(videoUrl)
                
                completeCount += 1
                if completeCount == 3 { //break when three video-blocks are completely trimmed.
                    self?.mergeVideoBlocks(videoUrls,skip: Int(skipLoopCount), completion: completion) // Merge BLOCK 1 ~ 3
                }
            }
        }
        
    }
    
    private func trimVideo(_ videoUrl: URL, timeRange: [Double], completion: @escaping UrlFunction) {
        guard timeRange.count == 2 else { fatalError("iCimulator: Invalid Argument→ 'timeRange'.") }
        let startCMTime = CMTime(seconds: timeRange[0], preferredTimescale: 1)
        let endCMTime = CMTime(seconds: timeRange[1], preferredTimescale: 1)
        
        VideoConverter.trim(videoUrl: videoUrl,
                            timeRange: CMTimeRange(start: startCMTime, end: endCMTime),
                            completion: completion)
    }
    
    private func mergeVideoBlocks(_ videoUrls: [URL], skip skipLoopCount: Int, completion: @escaping UrlFunction) {
        
        var videos: [AVAsset] = []
        videos.append(AVAsset(url: videoUrls[0]))
        
        if skipLoopCount > 0 {
            let videoBlock2 = AVAsset(url: videoUrls[1])
            videos.append(videoBlock2)
            if skipLoopCount > 1 {
                for _ in 0...skipLoopCount-2 { videos.append(videoBlock2.copy() as! AVAsset) }
            }
        }
        
        videos.append(AVAsset(url: videoUrls[2]))
        VideoConverter.merge(arrayVideos: videos, completion: completion)
    }
    
    
    //-MARK: Communicating Method
    internal func captureImage()-> Data {
        guard let previewType = self.previewType else { fatalError("Unknown Type. (written on iCimulator.plist)") }
        
        switch previewType {
        case .StaticImage:
            return captureStaticImage()
        case .LoopedMovie:
            return captureVideo()
        case .NonLoopedMovie:
            fatalError("Deprecated.")
        case .Adhoc:
            fatalError("iCimulator: Adhoc Mode has not been developed...")
        case .MacCamera:
            fatalError("iCimulator: MacCamera Mode has not been developed...")
        }
        
        fatalError("iCimulator: Internal Error...")
    }
    
    internal func startRecording() {
        guard let previewType = self.previewType else { fatalError("Unknown Type. (written on iCimulator.plist)") }
        
        switch previewType {
        case .StaticImage:
            stopWatch.start()
        case .LoopedMovie:
            stopWatch.start()
            self.recordingStartTime = self.avQueuePlayer?.currentTime()
        case .NonLoopedMovie:
            fatalError("Deprecated.")
        case .Adhoc:
            fatalError("iCimulator: Adhoc Mode has not been developed...")
        case .MacCamera:
            fatalError("iCimulator: MacCamera Mode has not been developed...")
        }
    }
    
    internal func stopRecording(_ completion: @escaping UrlFunction) {
        guard let interval = stopWatch.stop() else { fatalError("iCimulator: StopWatch is not working properly.") }
        let interval64 = Int(interval)
        
        switch previewType {
        case .StaticImage:
            convertStillImage2Video(interval64, completion: completion)
        case .LoopedMovie:
            shapeVideo(interval64, completion: completion)
        case .NonLoopedMovie:
            fatalError("Deprecated.")
        case .Adhoc:
            fatalError("iCimulator: Adhoc Mode has not been developed...")
        case .MacCamera:
            fatalError("iCimulator: MacCamera Mode has not been developed...")
        case .none:
            fatalError("iCimulator: Internal Error...")
        }
    }

    
    
    
    
    
    
    //-MARK: Disguise AVCaptureVideoPreviewLayer
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

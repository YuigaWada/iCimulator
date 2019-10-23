//
//  VideoConverter.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/17.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

typealias UrlFunction = (URL)->()
internal class VideoConverter {
    
    private lazy var url:URL = URL(fileURLWithPath: NSTemporaryDirectory() + "iCimulator-temp-\(Date()).mp4")
    private lazy var imageSize: CGSize = UIScreen.main.bounds.size
    
    private var frameCount = 0
    private let fps: Int32 = 30
    
    private var videoWriter:AVAssetWriter?
    private var writerInput:AVAssetWriterInput?
    private var adaptor:AVAssetWriterInputPixelBufferAdaptor!
    
    private lazy var outputSettings = [AVVideoCodecKey: AVVideoCodecType.h264,
                                       AVVideoWidthKey: imageSize.width,
                                       AVVideoHeightKey: imageSize.height] as [String : Any]
    
    private lazy var bufferAttributes = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                                         kCVPixelBufferWidthKey as String: imageSize.width,
                                         kCVPixelBufferHeightKey as String: imageSize.height,] as [String : Any]
    
    
    //-MARK: For Video
    internal class func trim(videoUrl: URL, timeRange: CMTimeRange, completion: @escaping UrlFunction) {
        
        let videoAsset = AVURLAsset(url: videoUrl)
        let audioAsset1 = videoAsset.copy() as! AVURLAsset
        let comp = AVMutableComposition()
        
        let videoAssetSourceTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first! as AVAssetTrack
        let videoCompositionTrack = comp.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioAssetSourceTrack1 = audioAsset1.tracks(withMediaType: AVMediaType.audio).first! as AVAssetTrack
        let audioCompositionTrack = comp.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            
            try videoCompositionTrack?.insertTimeRange(
                CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(15, preferredTimescale: 600)),
                of: videoAssetSourceTrack,
                at: CMTime.zero)
            
            try audioCompositionTrack?.insertTimeRange(
                CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(15, preferredTimescale: 600)),
                of: audioAssetSourceTrack1,
                at: CMTime.zero)
            
        }catch { fatalError(error.localizedDescription) }
        
        let asset: AVAsset = comp
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory() + "iCimulator-temp-\(Double.random(in: 0..<10000)) (trimmed).mp4")
        
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: comp)
        var preset: String = AVAssetExportPresetPassthrough
        if compatiblePresets.contains(AVAssetExportPreset1920x1080) { preset = AVAssetExportPreset1920x1080 }
        
        
        if let exportSession = AVAssetExportSession(asset: asset, presetName: preset){
            
            exportSession.canPerformMultiplePassesOverSourceMediaData = true
            exportSession.outputURL = filePath
            exportSession.timeRange = timeRange
            exportSession.outputFileType = AVFileType.mp4
                        exportSession.exportAsynchronously {
                            print("iCimulator: \(filePath)")
                            completion(filePath)
                        }
            
            //return filePath
        }
        else { fatalError("iCimulator: Failed to trim videos.") }
    }
    
    
    internal class func merge(arrayVideos:[AVAsset], completion: @escaping UrlFunction) {
        guard arrayVideos.count > 0 else {return}
        
        let mainComposition = AVMutableComposition()
        let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)
        
        let soundtrackTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var insertTime = CMTime.zero
        
        for videoAsset in arrayVideos {
            try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
            try! soundtrackTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio)[0], at: insertTime)
            
            insertTime = CMTimeAdd(insertTime, videoAsset.duration)
        }
        
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: arrayVideos[0])
        var preset: String = AVAssetExportPresetPassthrough
        if compatiblePresets.contains(AVAssetExportPreset1920x1080) { preset = AVAssetExportPreset1920x1080 }
        
        let outputFileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "iCimulator-temp-\(Double.random(in: 0..<10000)) (merged).mp4")
        let exporter = AVAssetExportSession(asset: mainComposition, presetName: preset)
        
        exporter?.outputURL = outputFileURL
        exporter?.outputFileType = AVFileType.mp4
        exporter?.shouldOptimizeForNetworkUse = true
        
        exporter?.exportAsynchronously {
            DispatchQueue.main.async {
                completion(outputFileURL)
            }
        }
        
        
    }
    
    
    
    //-MARK: For Image
    internal func fromImage(seconds: Int, image: UIImage, _ completion: @escaping UrlFunction) {
        
        let imageCount = Int(fps) * seconds //fps (frame/s) * t (s)
        let duplicatedImages = image.duplicate(count: imageCount)
        
        self.fromImages(images: duplicatedImages, completion)
    }
    
    internal func fromImages(images: [UIImage], _ completion: @escaping UrlFunction) {
        guard let assetWriter = try? AVAssetWriter(outputURL: url, fileType: AVFileType.mov)
            else { fatalError("iCimulator: AVAssetWriter error") }
        
        videoWriter = assetWriter
        writerInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings as [String : AnyObject])
        videoWriter!.add(writerInput!)
        writerInput?.expectsMediaDataInRealTime = true
        
        
        adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: writerInput!,
            sourcePixelBufferAttributes: bufferAttributes
        )
        
        guard videoWriter!.startWriting() else { fatalError("iCimulator: Failed to write a video in converting image to video.") }
        videoWriter!.startSession(atSourceTime: CMTime.zero)
        
        frameCount = 0
        for image in images {
            var buffer: CVPixelBuffer?
            guard adaptor.assetWriterInput.isReadyForMoreMediaData else { return }
            
            let frameTime: CMTime = CMTimeMake(value: Int64(__int32_t(frameCount) * __int32_t(1)), timescale: fps)
            buffer = self.pixelBufferFromCGImage(cgImage: image.cgImage!)
            guard adaptor.append(buffer!, withPresentationTime: frameTime) else { fatalError(videoWriter!.error!.localizedDescription) }
            
            //print("frameCount :\(frameCount)")
            frameCount += 1
        }
        
        writerInput!.markAsFinished()
        videoWriter!.endSession(atSourceTime: CMTimeMake(value: Int64((__int32_t(frameCount)) *  __int32_t(1)), timescale: fps))
        videoWriter!.finishWriting(completionHandler: {
            self.writerInput = nil
            completion(self.url)
        })
    }
    
    //cf. https://github.com/uruly/MovieCreator/blob/master/MovieCreator/MovieCreator.swift
    //Thanks for @uruly.
    func pixelBufferFromCGImage(cgImage: CGImage) -> CVPixelBuffer {
        
        let options = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pxBuffer: CVPixelBuffer? = nil
        
        let width = cgImage.width
        let height = cgImage.height
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32ARGB,
                            options as CFDictionary?,
                            &pxBuffer)
        
        CVPixelBufferLockBaseAddress(pxBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pxdata = CVPixelBufferGetBaseAddress(pxBuffer!)
        
        let bitsPerComponent: size_t = 8
        let bytesPerRow: size_t = 4 * width
        
        let rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(x:0, y:0, width:CGFloat(width),height:CGFloat(height)))
        
        CVPixelBufferUnlockBaseAddress(pxBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxBuffer!
    }
    
}


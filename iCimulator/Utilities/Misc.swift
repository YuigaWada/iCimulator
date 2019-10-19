//
//  Misc.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

//-MARK: Structure
internal struct iCimulatorPlist: Codable{
    let `Type`: String
    let Argument: String
}

//-MARK: Enumeration
internal enum PreviewType: String
{
    case StaticImage = "Image"
    case MacCamera = "Mac-Camera"
    case LoopedMovie = "Video"
    case NonLoopedMovie = "NonLooped-Video" //Deprecated
    case Adhoc = "Adhoc-iOS"
}







//-MARK: Utility Extension
internal extension NSObject {
    
    var isOnSimulator: Bool {
        #if targetEnvironment(simulator)
          return true
        #else
          return false
        #endif
    }
    
}

internal extension CGRect {
    func getScreenFit()->CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

internal extension AVQueuePlayer {
    func shotPhoto()->UIImage? {
        if let item = self.currentItem {
            let imageGenerator = AVAssetImageGenerator(asset: item.asset)
            if let cgImage = try? imageGenerator.copyCGImage(at: item.currentTime(), actualTime: nil) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
}
//
//internal extension AVPlayer {
//    func automateLoop() {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
//            self?.seek(to: CMTime.zero)
//            self?.play()
//        }
//    }
//}

internal extension UIImage {
    func duplicate(count: Int)-> [UIImage] {
        var images: [UIImage] = []
        for _ in 0...count-1 {
            let deepCopied = self.copy() as! UIImage
            images.append(deepCopied)
        }
        
        return images
    }
}


internal extension CGImage {
    
    func toUIImage()-> UIImage {
        return UIImage(cgImage: self)
    }
    
    func toData()-> Data? {
        return self.toUIImage().pngData()
    }
    
    func toVideo(seconds: Int, _ completion: @escaping UrlFunction) {
        let videoConverter = VideoConverter()
        
        videoConverter.fromImage(seconds: seconds, image: self.toUIImage(), completion)
    }
}

internal extension Data {
    func toUIImage()-> UIImage {
        return UIImage(data: self)!
    }
    
    func toCMSampleBuffer() -> CMSampleBuffer {
        var pixelBuffer : CVPixelBuffer? = self.toUIImage().toCVPixelBuffer()
        CVPixelBufferCreate(kCFAllocatorDefault, 100, 100, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        
        var info = CMSampleTimingInfo()
        info.presentationTimeStamp = .zero
        info.duration = .zero
        info.decodeTimeStamp = .zero
        
        
        var formatDesc: CMFormatDescription? = nil
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pixelBuffer!, formatDescriptionOut: &formatDesc)
        
        var sampleBuffer: CMSampleBuffer? = nil
        
        CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                 imageBuffer: pixelBuffer!,
                                                 formatDescription: formatDesc!,
                                                 sampleTiming: &info,
                                                 sampleBufferOut: &sampleBuffer);
        
        return sampleBuffer!
    }
    
}


internal extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let image = self
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}



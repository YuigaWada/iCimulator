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

open class FakeCaptureDevice : NSObject {
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
    
    open class func devices(for mediaType: AVMediaType) -> [FakeCaptureDevice] {  return self.devices() }
    open class func `default`(for mediaType: AVMediaType) -> FakeCaptureDevice? {
        let fake = FakeCaptureDevice()
        fake.position = .back
        
        return fake
    }
    
    
    
    public init?(uniqueID deviceUniqueID: String) {}
    public override init() {}
    open var uniqueID: String = "iCimulator-Fake"
    open var modelID: String = "iCimulator-Fake"
    open var localizedName: String = "iCimulator-Fake"
    open func hasMediaType(_ mediaType: AVMediaType) -> Bool {return true}
    open func lockForConfiguration() throws {}
    open func unlockForConfiguration(){}
    open func supportsSessionPreset(_ preset: AVCaptureSession.Preset) -> Bool {return true}
    open var isConnected: Bool = false  //TODO
    open var formats: [FakeCaptureDevice.Format] = [Format()]
    open var activeFormat: FakeCaptureDevice.Format = Format()
    open var activeVideoMinFrameDuration: CMTime = .zero
    open var activeVideoMaxFrameDuration: CMTime = CMTime(seconds: 60*60*24, preferredTimescale: .max)
    public enum Position : Int {
        case unspecified
        case back
        case front
    }
    public struct DeviceType : Hashable, Equatable, RawRepresentable {
        public var rawValue: String = "Hashable"
        public init(rawValue: String) {self.rawValue = rawValue}
        public static let builtInMicrophone: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInMicrophone")
        public static let builtInWideAngleCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInWideAngleCamera")
        public static let builtInTelephotoCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInTelephotoCamera")
        public static let builtInUltraWideCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInUltraWideCamera")
        public static let builtInDualCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInDualCamera")
        public static let builtInDualWideCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInDualWideCamera")
        public static let builtInTripleCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInTripleCamera")
        public static let builtInTrueDepthCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInTrueDepthCamera")
        public static let builtInDuoCamera: FakeCaptureDevice.DeviceType = FakeCaptureDevice.DeviceType(rawValue: "builtInDuoCamera")
    }
    public enum FlashMode : Int {
        case off
        case on
        case auto
    }
    public enum TorchMode : Int {
        case off
        case on
        case auto
    }
    public let maxAvailableTorchLevel: Float = 100000
    public enum FocusMode : Int {
        case locked
        case autoFocus
        case continuousAutoFocus
    }
    public enum AutoFocusRangeRestriction : Int {
        case none
        case near
        case far
    }
    public let currentLensPosition: Float = 1.0
    public enum ExposureMode : Int {
        case locked
        case autoExpose
        case continuousAutoExposure
        case custom
    }
    public let currentExposureDuration: CMTime = CMTime(seconds: 0.0, preferredTimescale: .max)
    public let currentISO: Float = 1.0
    public let currentExposureTargetBias: Float = 1.0
    public enum WhiteBalanceMode : Int {
        case locked
        case autoWhiteBalance
        case continuousAutoWhiteBalance
    }
    public struct WhiteBalanceGains {
        public var redGain: Float
        public var greenGain: Float
        public var blueGain: Float
        public init(){ self.redGain = 0 ;self.greenGain = 0;self.blueGain = 0 }
        public init(redGain: Float, greenGain: Float, blueGain: Float) {self.redGain = redGain;self.greenGain = greenGain;self.blueGain = blueGain}
    }
    open var position: FakeCaptureDevice.Position = .back
    open var hasTorch: Bool = true
    open var isTorchAvailable: Bool = true
    open var isTorchActive: Bool = true
    open var torchLevel: Float  = 1.0
    open func isTorchModeSupported(_ torchMode: FakeCaptureDevice.TorchMode) -> Bool {return true}
    open var torchMode: FakeCaptureDevice.TorchMode = .on
    open var hasFlash: Bool = true
    open var isFlashAvailable: Bool = true
    open var isFlashActive: Bool = true
    open func isFlashModeSupported(_ flashMode: FakeCaptureDevice.FlashMode) -> Bool {return true}
    open var isVirtualDevice: Bool = false
    open var constituentDevices: [FakeCaptureDevice] = []
    open var virtualDeviceSwitchOverVideoZoomFactors: [NSNumber] = [1]
    open var deviceType: FakeCaptureDevice.DeviceType = .builtInDualCamera
    open class func `default`(_ deviceType: FakeCaptureDevice.DeviceType, for mediaType: AVMediaType?, position: FakeCaptureDevice.Position) -> FakeCaptureDevice? {
        let fake = FakeCaptureDevice()
        fake.position = .back
        
        return fake
    }
//    open var systemPressureState: AVCaptureDevice.SystemPressureState = AVCaptureDevice.SystemPressureState
    open var flashMode: FakeCaptureDevice.FlashMode = .on
    open func setTorchModeOn(level torchLevel: Float) throws {}
    open func isFocusModeSupported(_ focusMode: FakeCaptureDevice.FocusMode) -> Bool {return true}
    open var isLockingFocusWithCustomLensPositionSupported: Bool = true
    open var focusMode: FakeCaptureDevice.FocusMode = .autoFocus
    open var isFocusPointOfInterestSupported: Bool = true
    open var focusPointOfInterest: CGPoint = CGPoint()
    open var isAdjustingFocus: Bool = true
    open var isAutoFocusRangeRestrictionSupported: Bool = true
    open var autoFocusRangeRestriction: FakeCaptureDevice.AutoFocusRangeRestriction = .none
    open var isSmoothAutoFocusSupported: Bool = true
    open var isSmoothAutoFocusEnabled: Bool = true
    open var lensPosition: Float = 1.0
    open func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)? = nil) {}
    public struct WhiteBalanceChromaticityValues {
        public var x: Float
        public var y: Float
        public init() {x=0;y=0}
        public init(x: Float, y: Float) {self.x = x; self.y = y}
    }
    public struct WhiteBalanceTemperatureAndTintValues {
        public var temperature: Float
        public var tint: Float
        public init() {temperature=25;tint=0}
        public init(temperature: Float, tint: Float) {self.temperature = temperature; self.tint = tint}
    }
    public static let currentWhiteBalanceGains = FakeCaptureDevice.WhiteBalanceGains(redGain: 0, greenGain: 0, blueGain: 0)
    open class DiscoverySession : NSObject {
        public convenience init(deviceTypes: [FakeCaptureDevice.DeviceType], mediaType: AVMediaType?, position: FakeCaptureDevice.Position) { self.init() }
        
        public override init() {
            super.init()
            self.devices = [createFakeDeviceInfo(.front), createFakeDeviceInfo(.back)]
            self.supportedMultiCamDeviceSets = [Set([createFakeDeviceInfo(.front), createFakeDeviceInfo(.back)])]
        }
        open var devices: [FakeCaptureDevice] = []
        open var supportedMultiCamDeviceSets: [Set<FakeCaptureDevice>] = []
        

        private func createFakeDeviceInfo(_  position: FakeCaptureDevice.Position)-> FakeCaptureDevice {
            let fake = FakeCaptureDevice()
            fake.position = position
            
            return fake
        }
        
    }
    open class Format : NSObject {
        open var mediaType: AVMediaType = .video
        open var formatDescription: CMFormatDescription? = nil
        open var videoSupportedFrameRateRanges: [AVFrameRateRange] = [AVFrameRateRange()]
        open var videoFieldOfView: Float = 1.0
        open var isVideoBinned: Bool = true
        open func isVideoStabilizationModeSupported(_ videoStabilizationMode: AVCaptureVideoStabilizationMode) -> Bool
        {return true}
        open var isVideoStabilizationSupported: Bool = true
        open var videoMaxZoomFactor: CGFloat = 1.0
        open var videoZoomFactorUpscaleThreshold: CGFloat = 1.0
        open var minExposureDuration: CMTime = CMTime(seconds: 1.0, preferredTimescale: .max)
        open var maxExposureDuration: CMTime = CMTime(seconds: 1.0, preferredTimescale: .max)
        open var minISO: Float = 1.0
        open var maxISO: Float = 10
        open var isGlobalToneMappingSupported: Bool = true
        open var isVideoHDRSupported: Bool = true
        open var highResolutionStillImageDimensions: CMVideoDimensions = CMVideoDimensions(width: 1000, height: 1000)
        open var isHighestPhotoQualitySupported: Bool = true
        open var autoFocusSystem: FakeCaptureDevice.Format.AutoFocusSystem = .contrastDetection
        open var __supportedColorSpaces: [NSNumber] = [1]
        open var videoMinZoomFactorForDepthDataDelivery: CGFloat  = 1.0
        open var videoMaxZoomFactorForDepthDataDelivery: CGFloat = 1.0
        open var supportedDepthDataFormats: [FakeCaptureDevice.Format] = []
        open var unsupportedCaptureOutputClasses: [AnyClass] = []
        public enum AutoFocusSystem : Int {
            case none
            case contrastDetection
            case phaseDetection
        }
        open var isPortraitEffectsMatteStillImageDeliverySupported:Bool = true
        open var isMultiCamSupported:Bool = true
        open var geometricDistortionCorrectedVideoFieldOfView: Float = 1.0
    }
    open func isExposureModeSupported(_ exposureMode: FakeCaptureDevice.ExposureMode) -> Bool {return true}
    open var exposureMode: FakeCaptureDevice.ExposureMode = .autoExpose
    open var isExposurePointOfInterestSupported:Bool = true
    open var exposurePointOfInterest: CGPoint = CGPoint(x:0,y:0)
    open var activeMaxExposureDuration: CMTime = CMTime(seconds: 60*60, preferredTimescale: .max)
    open var isAdjustingExposure:Bool = true
    open var lensAperture: Float = 1.0
    open var exposureDuration: CMTime = CMTime()
    open var iso: Float = 1.0
    open func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)? = nil)
    {
        guard let _handler = handler else { return }
               _handler(CMTime(seconds: 1.0, preferredTimescale: .max))
    }
    open var exposureTargetOffset: Float = 1.0
    open var exposureTargetBias: Float = 1.0
    open var minExposureTargetBias: Float = 1.0
    open var maxExposureTargetBias: Float = 1.0
    open func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)? = nil)
    {
        guard let _handler = handler else { return }
               _handler(CMTime(seconds: 1.0, preferredTimescale: .max))
    }
    open var isGlobalToneMappingEnabled: Bool = true
    open func isWhiteBalanceModeSupported(_ whiteBalanceMode: FakeCaptureDevice.WhiteBalanceMode) -> Bool {return true}
    open var isLockingWhiteBalanceWithCustomDeviceGainsSupported:Bool = true
    open var whiteBalanceMode: FakeCaptureDevice.WhiteBalanceMode = .autoWhiteBalance
    open var isAdjustingWhiteBalance:Bool = true
    open var deviceWhiteBalanceGains: FakeCaptureDevice.WhiteBalanceGains = .init(redGain: 0, greenGain: 0, blueGain: 0)
    open var grayWorldDeviceWhiteBalanceGains: FakeCaptureDevice.WhiteBalanceGains = .init(redGain: 0, greenGain: 0, blueGain: 0)
    open var maxWhiteBalanceGain: Float = 1.0
    open func setWhiteBalanceModeLocked(with whiteBalanceGains: FakeCaptureDevice.WhiteBalanceGains, completionHandler handler: ((CMTime) -> Void)? = nil) {
        guard let _handler = handler else { return }
        _handler(CMTime(seconds: 1.0, preferredTimescale: .max))
    }
    open func chromaticityValues(for whiteBalanceGains: FakeCaptureDevice.WhiteBalanceGains) -> FakeCaptureDevice.WhiteBalanceChromaticityValues { .init(x: 0, y: 0)}
    open func deviceWhiteBalanceGains(for chromaticityValues: FakeCaptureDevice.WhiteBalanceChromaticityValues) -> FakeCaptureDevice.WhiteBalanceGains { return .init(redGain: 0, greenGain: 0, blueGain: 0)}
    open func temperatureAndTintValues(for whiteBalanceGains: FakeCaptureDevice.WhiteBalanceGains) -> FakeCaptureDevice.WhiteBalanceTemperatureAndTintValues{ return .init(temperature: 30, tint: 0) }
    open func deviceWhiteBalanceGains(for tempAndTintValues: FakeCaptureDevice.WhiteBalanceTemperatureAndTintValues) -> FakeCaptureDevice.WhiteBalanceGains{ return .init(redGain: 0, greenGain: 0, blueGain: 0)}
    open var isSubjectAreaChangeMonitoringEnabled: Bool = true
    open var isLowLightBoostSupported:Bool = true
    open var isLowLightBoostEnabled:Bool = true
    open var automaticallyEnablesLowLightBoostWhenAvailable: Bool = true
        open var videoZoomFactor: CGFloat = 3.0
    open func ramp(toVideoZoomFactor factor: CGFloat, withRate rate: Float) {}
    open var isRampingVideoZoom:Bool = true
    open func cancelVideoZoomRamp() {}
    open var dualCameraSwitchOverVideoZoomFactor: CGFloat = 1.0
    open class func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {return .authorized}
    open class func requestAccess(for mediaType: AVMediaType, completionHandler handler: @escaping (Bool) -> Void) {
        handler(true)
    }
    open var automaticallyAdjustsVideoHDREnabled: Bool = true
    open var isVideoHDREnabled: Bool = true
    public enum AVCaptureColorSpace : Int {
        case sRGB
        case P3_D65
    }
    open var activeColorSpace: AVCaptureColorSpace = .sRGB
    open var activeDepthDataFormat: FakeCaptureDevice.Format? = .init()
    open var activeDepthDataMinFrameDuration: CMTime = CMTime(seconds: 60*60, preferredTimescale: .max)
    open var minAvailableVideoZoomFactor: CGFloat = 1.0
    open var maxAvailableVideoZoomFactor: CGFloat = 1.0
    open var isGeometricDistortionCorrectionSupported:Bool = true
    open var isGeometricDistortionCorrectionEnabled: Bool = true
    open class func extrinsicMatrix(from fromDevice: FakeCaptureDevice, to toDevice: FakeCaptureDevice) -> Data? {return nil}
    open class AVFrameRateRange : NSObject {
        open var minFrameRate: Float64 = 1.0
        open var maxFrameRate: Float64 = 1.0
        open var maxFrameDuration: CMTime = CMTime(seconds: 60*60*24, preferredTimescale: .max)
        open var minFrameDuration: CMTime = .zero
    }
    public enum AVCaptureVideoStabilizationMode : Int {
        case off
        case standard
        case cinematic
        case cinematicExtended
        case auto
    }
}
//
//    open class SystemPressureState : NSObject {
//
//
//        /**
//         @property level
//         @discussion
//            An enumerated string value characterizing the pressure level to which the system is currently elevated.
//         */
//
//        open var level: AVCaptureDevice.SystemPressureState.Level = .nominal
//
//
//        /**
//         @property factors
//         @discussion
//            A bitmask of values indicating the factors contributing to the current system pressure level.
//         */
//
//        open var factors: AVCaptureDevice.SystemPressureState.Factors = .peakPower
//    }
//
//
//   open class SystemPressureState {
//
//
//
//    public struct Level : Hashable, Equatable, RawRepresentable {
//            public var rawValue: String
//
//
//            public init(rawValue: String) {self.rawValue = rawValue}
//        }
//
//
//
//    public struct Factors : OptionSet {
//            public var rawValue: UInt
//
//
//            public init(rawValue: UInt) {self.rawValue = rawValue}
//
//
//            public static var systemTemperature: AVCaptureDevice.SystemPressureState.Factors = .depthModuleTemperature
//
//            public static var peakPower: AVCaptureDevice.SystemPressureState.Factors = .depthModuleTemperature
//
//            public static var depthModuleTemperature: AVCaptureDevice.SystemPressureState.Factors = .depthModuleTemperature
//        }
//    class Level {
//
//        public static let nominal: AVCaptureDevice.SystemPressureState.Level = .critical
//
//        /**
//         @constant AVCaptureSystemPressureLevelFair
//            System pressure is slightly elevated.
//         */
//
//        public static let fair: AVCaptureDevice.SystemPressureState.Level = .critical
//
//        /**
//         @constant AVCaptureSystemPressureLevelSerious
//            System pressure is highly elevated. Capture performance may be impacted. Frame rate throttling is advised.
//         */
//
//        public static let serious: AVCaptureDevice.SystemPressureState.Level = .critical
//
//        /**
//         @constant AVCaptureSystemPressureLevelCritical
//            System pressure is critically elevated. Capture quality and performance are significantly impacted. Frame rate throttling is highly advised.
//         */
//
//        public static let critical: AVCaptureDevice.SystemPressureState.Level = .critical
//
//        /**
//         @constant AVCaptureSystemPressureLevelShutdown
//            System pressure is beyond critical. Capture must immediately stop.
//         */
//
//        public static let shutdown: AVCaptureDevice.SystemPressureState.Level = .critical
//    }
//
//}
//}

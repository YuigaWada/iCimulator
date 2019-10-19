/*
 Try to run shaper.sh :P
 (This code can be watched on your Xcode.)
 */

import Foundation
import UIKit
import _SwiftUIKitOverlayShims

extension UIImagePickerController {

    
    public enum SourceType : Int {

        
        case photoLibrary

        case camera

        case savedPhotosAlbum
    }

    
    public enum QualityType : Int {

        
        case typeHigh // highest quality

        case typeMedium // medium quality, suitable for transmission via Wi-Fi

        case typeLow // lowest quality, suitable for tranmission via cellular network

        @available(iOS 4.0, *)
        case type640x480 // VGA quality

        @available(iOS 5.0, *)
        case typeIFrame1280x720

        @available(iOS 5.0, *)
        case typeIFrame960x540
    }

    
    public enum CameraCaptureMode : Int {

        
        case photo

        case video
    }

    
    public enum CameraDevice : Int {

        
        case rear

        case front
    }

    
    public enum CameraFlashMode : Int {

        
        case off

        case auto

        case on
    }

    
    @available(iOS 11.0, *)
    public enum ImageURLExportPreset : Int {

        
        case compatible

        case current
    }

    
    public struct InfoKey : Hashable, Equatable, RawRepresentable {

        public init(rawValue: String)
    }
}
extension UIImagePickerController.InfoKey {

    
    public static let mediaType: UIImagePickerController.InfoKey

    public static let originalImage: UIImagePickerController.InfoKey // a UIImage

    public static let editedImage: UIImagePickerController.InfoKey // a UIImage

    public static let cropRect: UIImagePickerController.InfoKey // an NSValue (CGRect)

    public static let mediaURL: UIImagePickerController.InfoKey // an NSURL

    @available(iOS, introduced: 4.1, deprecated: 11.0, renamed: "UIImagePickerController.InfoKey.phAsset")
    public static let referenceURL: UIImagePickerController.InfoKey // an NSURL that references an asset in the AssetsLibrary framework

    @available(iOS 4.1, *)
    public static let mediaMetadata: UIImagePickerController.InfoKey // an NSDictionary containing metadata from a captured photo

    @available(iOS 9.1, *)
    public static let livePhoto: UIImagePickerController.InfoKey // a PHLivePhoto

    @available(iOS 11.0, *)
    public static let phAsset: UIImagePickerController.InfoKey // a PHAsset

    @available(iOS 11.0, *)
    public static let imageURL: UIImagePickerController.InfoKey // an NSURL
}

@available(iOS 2.0, *)
open class UIImagePickerController : UINavigationController, NSCoding {

    
    open class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool // returns YES if source is available (i.e. camera present)

    open class func availableMediaTypes(for sourceType: UIImagePickerController.SourceType) -> [String]? // returns array of available media types (i.e. kUTTypeImage)

    
    @available(iOS 4.0, *)
    open class func isCameraDeviceAvailable(_ cameraDevice: UIImagePickerController.CameraDevice) -> Bool // returns YES if camera device is available

    @available(iOS 4.0, *)
    open class func isFlashAvailable(for cameraDevice: UIImagePickerController.CameraDevice) -> Bool // returns YES if camera device supports flash and torch.

    @available(iOS 4.0, *)
    open class func availableCaptureModes(for cameraDevice: UIImagePickerController.CameraDevice) -> [NSNumber]? // returns array of NSNumbers (UIImagePickerControllerCameraCaptureMode)

    
    weak open var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

    
    open var sourceType: UIImagePickerController.SourceType // default value is UIImagePickerControllerSourceTypePhotoLibrary.

    open var mediaTypes: [String]

    // default value is an array containing kUTTypeImage.
    @available(iOS 3.1, *)
    open var allowsEditing: Bool // replacement for -allowsImageEditing; default value is NO.

    
    @available(iOS 11.0, *)
    open var imageExportPreset: UIImagePickerController.ImageURLExportPreset // default value is UIImagePickerControllerImageExportPresetCompatible.

    
    // video properties apply only if mediaTypes includes kUTTypeMovie
    @available(iOS 3.1, *)
    open var videoMaximumDuration: TimeInterval // default value is 10 minutes.

    @available(iOS 3.1, *)
    open var videoQuality: UIImagePickerController.QualityType // default value is UIImagePickerControllerQualityTypeMedium. If the cameraDevice does not support the videoQuality, it will use the default value.

    @available(iOS 11.0, *)
    open var videoExportPreset: String // videoExportPreset can be used to specify the transcoding quality for videos (via a AVAssetExportPreset* string). If the value is nil (the default) then the transcodeQuality is determined by videoQuality instead. Not valid if the source type is UIImagePickerControllerSourceTypeCamera

    
    // camera additions available only if sourceType is UIImagePickerControllerSourceTypeCamera.
    @available(iOS 3.1, *)
    open var showsCameraControls: Bool // set to NO to hide all standard camera UI. default is YES

    @available(iOS 3.1, *)
    open var cameraOverlayView: UIView? // set a view to overlay the preview view.

    @available(iOS 3.1, *)
    open var cameraViewTransform: CGAffineTransform // set the transform of the preview view.

    
    @available(iOS 3.1, *)
    open func takePicture()

    // programatically initiates still image capture. ignored if image capture is in-flight.
    // clients can initiate additional captures after receiving -imagePickerController:didFinishPickingMediaWithInfo: delegate callback
    
    @available(iOS 4.0, *)
    open func startVideoCapture() -> Bool

    @available(iOS 4.0, *)
    open func stopVideoCapture()

    
    @available(iOS 4.0, *)
    open var cameraCaptureMode: UIImagePickerController.CameraCaptureMode // default is UIImagePickerControllerCameraCaptureModePhoto

    @available(iOS 4.0, *)
    open var cameraDevice: UIImagePickerController.CameraDevice // default is UIImagePickerControllerCameraDeviceRear

    @available(iOS 4.0, *)
    open var cameraFlashMode: UIImagePickerController.CameraFlashMode // default is UIImagePickerControllerCameraFlashModeAuto.
}

// cameraFlashMode controls the still-image flash when cameraCaptureMode is Photo. cameraFlashMode controls the video torch when cameraCaptureMode is Video.

public protocol UIImagePickerControllerDelegate : NSObjectProtocol {

    
    @available(iOS 2.0, *)
    optional func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])

    @available(iOS 2.0, *)
    optional func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}

// Adds a photo to the saved photos album.  The optional completionSelector should have the form:
//  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
public func UIImageWriteToSavedPhotosAlbum(_ image: UIImage, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?)

// Is a specific video eligible to be saved to the saved photos album?
@available(iOS 3.1, *)
public func UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_ videoPath: String) -> Bool

// Adds a video to the saved photos album. The optional completionSelector should have the form:
//  - (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@available(iOS 3.1, *)
public func UISaveVideoAtPathToSavedPhotosAlbum(_ videoPath: String, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?)

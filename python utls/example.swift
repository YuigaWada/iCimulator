/*
 Try to run shaper.sh :P
 (This code can be watched on your Xcode.)
 */

@available(iOS 10.0, *)
open class AVCapturePhotoSettings : NSObject, NSCopying {

    
    /**
     @method photoSettingsWithFormat:
     @abstract
        Creates an instance of AVCapturePhotoSettings with a user-specified output format.
     
     @param format
        A dictionary of Core Video pixel buffer attributes or AVVideoSettings, analogous to AVCaptureStillImageOutput's outputSettings property.
     @result
        An instance of AVCapturePhotoSettings.
     
     @discussion
        If you wish an uncompressed format, your dictionary must contain kCVPixelBufferPixelFormatTypeKey, and the format specified must be present in AVCapturePhotoOutput's -availablePhotoPixelFormatTypes array. kCVPixelBufferPixelFormatTypeKey is the only supported key when expressing uncompressed output. If you wish a compressed format, your dictionary must contain AVVideoCodecKey and the codec specified must be present in AVCapturePhotoOutput's -availablePhotoCodecTypes array. If you are specifying a compressed format, the AVVideoCompressionPropertiesKey is also supported, with a payload dictionary containing a single AVVideoQualityKey. Passing a nil format dictionary is analogous to calling +photoSettings.
     */
    public convenience init(format: [String : Any]?)

    
    /**
     @method photoSettingsWithRawPixelFormatType:
     @abstract
        Creates an instance of AVCapturePhotoSettings specifying RAW only output.
     
     @param rawPixelFormatType
        A Bayer RAW pixel format OSType (defined in CVPixelBuffer.h).
     @result
        An instance of AVCapturePhotoSettings.
    
     @discussion
        rawPixelFormatType must be one of the OSTypes contained in AVCapturePhotoOutput's -availableRawPhotoPixelFormatTypes array. See AVCapturePhotoOutput's -capturePhotoWithSettings:delegate: inline documentation for a discussion of restrictions on AVCapturePhotoSettings when requesting RAW capture.
     */
    public convenience init(rawPixelFormatType: OSType)

    
    /**
     @method photoSettingsWithRawPixelFormatType:processedFormat:
     @abstract
        Creates an instance of AVCapturePhotoSettings specifying RAW + a processed format (such as JPEG).
     
     @param rawPixelFormatType
        A Bayer RAW pixel format OSType (defined in CVPixelBuffer.h).
     @param processedFormat
        A dictionary of Core Video pixel buffer attributes or AVVideoSettings, analogous to AVCaptureStillImageOutput's outputSettings property.
     @result
        An instance of AVCapturePhotoSettings.
     
     @discussion
        rawPixelFormatType must be one of the OSTypes contained in AVCapturePhotoOutput's -availableRawPhotoPixelFormatTypes array. If you wish an uncompressed processedFormat, your dictionary must contain kCVPixelBufferPixelFormatTypeKey, and the processedFormat specified must be present in AVCapturePhotoOutput's -availablePhotoPixelFormatTypes array. kCVPixelBufferPixelFormatTypeKey is the only supported key when expressing uncompressed processedFormat. If you wish a compressed format, your dictionary must contain AVVideoCodecKey and the codec specified must be present in AVCapturePhotoOutput's -availablePhotoCodecTypes array. If you are specifying a compressed format, the AVVideoCompressionPropertiesKey is also supported, with a payload dictionary containing a single AVVideoQualityKey. Passing a nil processedFormat dictionary is analogous to calling +photoSettingsWithRawPixelFormatType:. See AVCapturePhotoOutput's -capturePhotoWithSettings:delegate: inline documentation for a discussion of restrictions on AVCapturePhotoSettings when requesting RAW capture.
     */
    public convenience init(rawPixelFormatType: OSType, processedFormat: [String : Any]?)

    
    /**
     @method photoSettingsWithRawPixelFormatType:processedFormat:fileType:
     @abstract
        Creates an instance of AVCapturePhotoSettings specifying RAW + a processed format (such as JPEG) and a file container to which it will be written.
     
     @param rawPixelFormatType
        A Bayer RAW pixel format OSType (defined in CVPixelBuffer.h). Pass 0 if you do not desire a RAW photo callback.
     @param rawFileType
        The file container for which the RAW image should be formatted to be written. Pass nil if you have no preferred file container. A default container will be chosen for you.
     @param processedFormat
        A dictionary of Core Video pixel buffer attributes or AVVideoSettings, analogous to AVCaptureStillImageOutput's outputSettings property. Pass nil if you do not desire a processed photo callback.
     @param processedFileType
        The file container for which the processed image should be formatted to be written. Pass nil if you have no preferred file container. A default container will be chosen for you.
     @result
        An instance of AVCapturePhotoSettings.
     
     @discussion
        rawPixelFormatType must be one of the OSTypes contained in AVCapturePhotoOutput's -availableRawPhotoPixelFormatTypes array. Set rawPixelFormatType to 0 if you do not desire a RAW photo callback. If you are specifying a rawFileType, it must be present in AVCapturePhotoOutput's -availableRawPhotoFileTypes array. If you wish an uncompressed processedFormat, your dictionary must contain kCVPixelBufferPixelFormatTypeKey, and the processedFormat specified must be present in AVCapturePhotoOutput's -availablePhotoPixelFormatTypes array. kCVPixelBufferPixelFormatTypeKey is the only supported key when expressing uncompressed processedFormat. If you wish a compressed format, your dictionary must contain AVVideoCodecKey and the codec specified must be present in AVCapturePhotoOutput's -availablePhotoCodecTypes array. If you are specifying a compressed format, the AVVideoCompressionPropertiesKey is also supported, with a payload dictionary containing a single AVVideoQualityKey. If you are specifying a processedFileType, it must be present in AVCapturePhotoOutput's -availablePhotoFileTypes array. Pass a nil processedFormat dictionary if you only desire a RAW photo capture. See AVCapturePhotoOutput's -capturePhotoWithSettings:delegate: inline documentation for a discussion of restrictions on AVCapturePhotoSettings when requesting RAW capture.
     */
    @available(iOS 11.0, *)
    public convenience init(rawPixelFormatType: OSType, rawFileType: AVFileType?, processedFormat: [String : Any]?, processedFileType: AVFileType?)

    
    /**
     @method photoSettingsFromPhotoSettings:
     @abstract
        Creates an instance of AVCapturePhotoSettings with a new uniqueID from an existing instance of AVCapturePhotoSettings.
     
     @param photoSettings
         An existing AVCapturePhotoSettings instance.
     @result
        An new instance of AVCapturePhotoSettings with new uniqueID.
     
     @discussion
        Use this factory method to create a clone of an existing photo settings instance, but with a new uniqueID that can safely be passed to AVCapturePhotoOutput -capturePhotoWithSettings:delegate:.
     */
    public convenience init(from photoSettings: AVCapturePhotoSettings)

    
    /**
     @property uniqueID
     @abstract
        A 64-bit number that uniquely identifies this instance.
    
     @discussion
        When you create an instance of AVCapturePhotoSettings, a uniqueID is generated automatically. This uniqueID is guaranteed to be unique for the life time of your process.
     */
    open var uniqueID: Int64 { get }

    
    /**
     @property format
     @abstract
        A dictionary of Core Video pixel buffer attributes or AVVideoSettings, analogous to AVCaptureStillImageOutput's outputSettings property.
    
     @discussion
        The format dictionary you passed to one of the creation methods. May be nil if you've specified RAW-only capture.
     */
    open var format: [String : Any]? { get }

    
    /**
     @property processedFileType
     @abstract
        The file container for which the processed photo is formatted to be stored.
    
     @discussion
        The formatting of data within a photo buffer is often dependent on the file format intended for storage. For instance, a JPEG encoded photo buffer intended for storage in a JPEG (JPEG File Interchange Format) file differs from JPEG to be stored in HEIF. The HEIF-containerized JPEG buffer is tiled for readback efficiency and partitioned into the box structure dictated by the HEIF file format. Some codecs are only supported by AVCapturePhotoOutput if containerized. For instance, the AVVideoCodecTypeHEVC is only supported with AVFileTypeHEIF and AVFileTypeHEIC formatting. To discover which photo pixel format types and video codecs are supported for a given file type, you may query AVCapturePhotoOutput's -supportedPhotoPixelFormatTypesForFileType:, or -supportedPhotoCodecTypesForFileType: respectively.
     */
    @available(iOS 11.0, *)
    open var processedFileType: AVFileType? { get }

    
    /**
     @property rawPhotoPixelFormatType
     @abstract
        A Bayer RAW pixel format OSType (defined in CVPixelBuffer.h).
    
     @discussion
        The rawPixelFormatType you specified in one of the creation methods. Returns 0 if you did not specify RAW capture. See AVCapturePhotoOutput's -capturePhotoWithSettings:delegate: inline documentation for a discussion of restrictions on AVCapturePhotoSettings when requesting RAW capture.
     */
    open var rawPhotoPixelFormatType: OSType { get }

    
    /**
     @property rawFileType
     @abstract
        The file container for which the RAW photo is formatted to be stored.
    
     @discussion
        The formatting of data within a RAW photo buffer may be dependent on the file format intended for storage. To discover which RAW photo pixel format types are supported for a given file type, you may query AVCapturePhotoOutput's -supportedRawPhotoPixelFormatTypesForFileType:.
     */
    @available(iOS 11.0, *)
    open var rawFileType: AVFileType? { get }

    
    /**
     @property flashMode
     @abstract
        Specifies whether the flash should be on, off, or chosen automatically by AVCapturePhotoOutput.
    
     @discussion
        flashMode takes the place of the deprecated AVCaptureDevice -flashMode API. Setting AVCaptureDevice.flashMode has no effect on AVCapturePhotoOutput, which only pays attention to the flashMode specified in your AVCapturePhotoSettings. The default value is AVCaptureFlashModeOff. Flash modes are defined in AVCaptureDevice.h. If you specify a flashMode of AVCaptureFlashModeOn, it wins over autoStillImageStabilizationEnabled=YES. When the device becomes very hot, the flash becomes temporarily unavailable until the device cools down (see AVCaptureDevice's -flashAvailable). While the flash is unavailable, AVCapturePhotoOutput's -supportedFlashModes property still reports AVCaptureFlashModeOn and AVCaptureFlashModeAuto as being available, thus allowing you to specify a flashMode of AVCaptureModeOn. You should always check the AVCaptureResolvedPhotoSettings provided to you in the AVCapturePhotoCaptureDelegate callbacks, as the resolved flashEnabled property will tell you definitively if the flash is being used.
     */
    open var flashMode: AVCaptureDevice.FlashMode

    
    /**
     @property autoRedEyeReductionEnabled
     @abstract
        Specifies whether red-eye reduction should be applied automatically on flash captures.
     
     @discussion
        Default is YES on platforms that support automatic red-eye reduction unless you are capturing a bracket using AVCapturePhotoBracketSettings or a RAW photo without a processed photo.  For RAW photos with a processed photo the red-eye reduction will be applied to the processed photo only (RAW photos by definition are not processed). When set to YES, red-eye reduction is applied as needed for flash captures if the photo output's autoRedEyeReductionSupported property returns YES.
     */
    @available(iOS 12.0, *)
    open var isAutoRedEyeReductionEnabled: Bool

    
    /**
     @property photoQualityPrioritization
     @abstract
        Indicates how photo quality should be prioritized against speed of photo delivery.
    
     @discussion
        Default value is AVCapturePhotoQualityPrioritizationBalanced. The AVCapturePhotoOutput is capable of applying a variety of techniques to improve photo quality (reduce noise, preserve detail in low light, freeze motion, etc), depending on the source device's activeFormat. Some of these techniques can take significant processing time before the photo is returned to your delegate callback. The photoQualityPrioritization property allows you to specify your preferred quality vs speed of delivery. By default, speed and quality are considered to be of equal importance. When you specify AVCapturePhotoQualityPrioritizationSpeed, you indicate that speed should be prioritized at the expense of quality. Likewise, when you choose AVCapturePhotoQualityPrioritizationQuality, you signal your willingness to prioritize the very best quality at the expense of speed, and your readiness to wait (perhaps significantly) longer for the photo to be returned to your delegate.
     */
    @available(iOS 13.0, *)
    open var photoQualityPrioritization: AVCapturePhotoOutput.QualityPrioritization

    
    /**
     @property autoStillImageStabilizationEnabled
     @abstract
        Specifies whether still image stabilization should be used automatically.
    
     @discussion
        Default is YES unless you are capturing a RAW photo (RAW photos may not be processed by definition) or a bracket using AVCapturePhotoBracketSettings. When set to YES, still image stabilization is applied automatically in low light to counteract hand shake. If the device has optical image stabilization, autoStillImageStabilizationEnabled makes use of lens stabilization as well.
     
        As of iOS 13 hardware, the AVCapturePhotoOutput is capable of applying a variety of multi-image fusion techniques to improve photo quality (reduce noise, preserve detail in low light, freeze motion, etc), all of which have been previously lumped under the stillImageStabilization moniker. This property should no longer be used as it no longer provides meaningful information about the techniques used to improve quality in a photo capture. Instead, you should use -photoQualityPrioritization to indicate your preferred quality vs speed.
     */
    @available(iOS, introduced: 10.0, deprecated: 13.0)
    open var isAutoStillImageStabilizationEnabled: Bool

    
    /**
     @property autoVirtualDeviceFusionEnabled
     @abstract
        Specifies whether virtual device image fusion should be used automatically.
    
     @discussion
        Default is YES unless you are capturing a RAW photo (RAW photos may not be processed by definition) or a bracket using AVCapturePhotoBracketSettings. When set to YES, and -[AVCapturePhotoOutput isVirtualDeviceFusionSupported] is also YES, constituent camera images of a virtual device may be fused to improve still image quality, depending on the current zoom factor, light levels, and focus position. You may determine whether virtual device fusion is enabled for a particular capture request by inspecting the virtualDeviceFusionEnabled property of the AVCaptureResolvedPhotoSettings. Note that when using the deprecated AVCaptureStillImageOutput interface with a virtual device, autoVirtualDeviceFusionEnabled fusion is always enabled if supported, and may not be turned off.
     */
    @available(iOS 13.0, *)
    open var isAutoVirtualDeviceFusionEnabled: Bool

    
    /**
     @property autoDualCameraFusionEnabled
     @abstract
        Specifies whether DualCamera image fusion should be used automatically.
    
     @discussion
        Default is YES unless you are capturing a RAW photo (RAW photos may not be processed by definition) or a bracket using AVCapturePhotoBracketSettings. When set to YES, and -[AVCapturePhotoOutput isDualCameraFusionSupported] is also YES, wide-angle and telephoto images may be fused to improve still image quality, depending on the current zoom factor, light levels, and focus position. You may determine whether DualCamera fusion is enabled for a particular capture request by inspecting the dualCameraFusionEnabled property of the AVCaptureResolvedPhotoSettings. Note that when using the deprecated AVCaptureStillImageOutput interface with the DualCamera, auto DualCamera fusion is always enabled and may not be turned off. As of iOS 13, this property is deprecated in favor of autoVirtualDeviceFusionEnabled.
     */
    @available(iOS, introduced: 10.2, deprecated: 13.0)
    open var isAutoDualCameraFusionEnabled: Bool

    
    /**
     @property virtualDeviceConstituentPhotoDeliveryEnabledDevices
     @abstract
        Specifies the constituent devices for which the virtual device should deliver photos.
    
     @discussion
        Default is empty array. To opt in for constituent device photo delivery, you may set this property to any subset of the devices in virtualDevice.constituentDevices. Your captureOutput:didFinishProcessingPhoto:error: callback will be called n times -- one for each of the devices you include in the array. You may only set this property to a non-nil array if you've set your AVCapturePhotoOutput's virtualDeviceConstituentPhotoDeliveryEnabled property to YES, and your delegate responds to the captureOutput:didFinishProcessingPhoto:error: selector.
     */
    @available(iOS 13.0, *)
    open var virtualDeviceConstituentPhotoDeliveryEnabledDevices: [AVCaptureDevice]

    
    /**
     @property dualCameraDualPhotoDeliveryEnabled
     @abstract
        Specifies whether the DualCamera should return both the telephoto and wide image.
    
     @discussion
        Default is NO. When set to YES, your captureOutput:didFinishProcessingPhoto:error: callback will receive twice the number of callbacks, as both the telephoto image(s) and wide-angle image(s) are delivered. You may only set this property to YES if you've set your AVCapturePhotoOutput's dualCameraDualPhotoDeliveryEnabled property to YES, and your delegate responds to the captureOutput:didFinishProcessingPhoto:error: selector. As of iOS 13, this property is deprecated in favor of virtualDeviceConstituentPhotoDeliveryEnabledDevices.
     */
    @available(iOS, introduced: 11.0, deprecated: 13.0)
    open var isDualCameraDualPhotoDeliveryEnabled: Bool

    
    /**
     @property highResolutionPhotoEnabled
     @abstract
        Specifies whether photos should be captured at the highest resolution supported by the source AVCaptureDevice's activeFormat.
    
     @discussion
        Default is NO. By default, AVCapturePhotoOutput emits images with the same dimensions as its source AVCaptureDevice's activeFormat.formatDescription. However, if you set this property to YES, the AVCapturePhotoOutput emits images at its source AVCaptureDevice's activeFormat.highResolutionStillImageDimensions. Note that if you enable video stabilization (see AVCaptureConnection's preferredVideoStabilizationMode) for any output, the high resolution photos emitted by AVCapturePhotoOutput may be smaller by 10 or more percent. You may inspect your AVCaptureResolvedPhotoSettings in the delegate callbacks to discover the exact dimensions of the capture photo(s).
     */
    open var isHighResolutionPhotoEnabled: Bool

    
    /**
     @property depthDataDeliveryEnabled
     @abstract
        Specifies whether AVDepthData should be captured along with the photo.
    
     @discussion
        Default is NO. Set to YES if you wish to receive depth data with your photo. Throws an exception if -[AVCapturePhotoOutput depthDataDeliveryEnabled] is not set to YES or your delegate does not respond to the captureOutput:didFinishProcessingPhoto:error: selector. Note that setting this property to YES may add significant processing time to the delivery of your didFinishProcessingPhoto: callback.
     
        For best rendering results in Apple's Photos.app, portrait photos should be captured with both embedded depth data and a portrait effects matte (see portraitEffectsMatteDeliveryEnabled). When supported, it is recommended to opt in for both of these auxiliary images in your photo captures involving depth.
     */
    @available(iOS 11.0, *)
    open var isDepthDataDeliveryEnabled: Bool

    
    /**
     @property embedsDepthDataInPhoto
     @abstract
        Specifies whether depth data included with this photo should be written to the photo's file structure.
    
     @discussion
        Default is YES. When depthDataDeliveryEnabled is set to YES, this property specifies whether the included depth data should be written to the resulting photo's internal file structure. Depth data is currently only supported in HEIF and JPEG. This property is ignored if depthDataDeliveryEnabled is set to NO.
     */
    @available(iOS 11.0, *)
    open var embedsDepthDataInPhoto: Bool

    
    /**
     @property depthDataFiltered
     @abstract
        Specifies whether the depth data delivered with the photo should be filtered to fill invalid values.
    
     @discussion
        Default is YES. This property is ignored unless depthDataDeliveryEnabled is set to YES. Depth data maps may contain invalid pixel values due to a variety of factors including occlusions and low light. When depthDataFiltered is set to YES, the photo output interpolates missing data, filling in all holes.
     */
    @available(iOS 11.0, *)
    open var isDepthDataFiltered: Bool

    
    /**
     @property cameraCalibrationDataDeliveryEnabled
     @abstract
        Specifies whether AVCameraCalibrationData should be captured and delivered along with this photo.
    
     @discussion
        Default is NO. Set to YES if you wish to receive camera calibration data with your photo. Camera calibration data is delivered as a property of an AVCapturePhoto, so if you are using the CMSampleBuffer delegate callbacks rather than -captureOutput:didFinishProcessingPhoto:error:, an exception is thrown. Also, you may only set this property to YES if your AVCapturePhotoOutput's cameraCalibrationDataDeliverySupported property is YES. When requesting dual camera dual photo delivery plus camera calibration data, the wide and tele photos each contain camera calibration data for their respective camera. Note that AVCameraCalibrationData can be delivered as a property of an AVCapturePhoto or an AVDepthData, thus your delegate must respond to the captureOutput:didFinishProcessingPhoto:error: selector.
     */
    @available(iOS 11.0, *)
    open var isCameraCalibrationDataDeliveryEnabled: Bool

    
    /**
     @property portraitEffectsMatteDeliveryEnabled
     @abstract
        Specifies whether an AVPortraitEffectsMatte should be captured along with the photo.
    
     @discussion
        Default is NO. Set to YES if you wish to receive a portrait effects matte with your photo. Throws an exception if -[AVCapturePhotoOutput portraitEffectsMatteDeliveryEnabled] is not set to YES or your delegate does not respond to the captureOutput:didFinishProcessingPhoto:error: selector. Portrait effects matte generation requires depth to be present, so if you wish to enable portrait effects matte delivery, you must set depthDataDeliveryEnabled to YES. Setting this property to YES does not guarantee that a portrait effects matte will be present in the resulting AVCapturePhoto. As the property name implies, the matte is primarily used to improve the rendering quality of portrait effects on the image. If the photo's content lacks a clear foreground subject, no portrait effects matte is generated, and the -[AVCapturePhoto portraitEffectsMatte] property returns nil. Note that setting this property to YES may add significant processing time to the delivery of your didFinishProcessingPhoto: callback.
     
        For best rendering results in Apple's Photos.app, portrait photos should be captured with both embedded depth data (see depthDataDeliveryEnabled) and a portrait effects matte. When supported, it is recommended to opt in for both of these auxiliary images in your photo captures involving depth.
     */
    @available(iOS 12.0, *)
    open var isPortraitEffectsMatteDeliveryEnabled: Bool

    
    /**
     @property embedsPortraitEffectsMatteInPhoto
     @abstract
        Specifies whether the portrait effects matte captured with this photo should be written to the photo's file structure.
    
     @discussion
        Default is YES. When portraitEffectsMatteDeliveryEnabled is set to YES, this property specifies whether the included portrait effects matte should be written to the resulting photo's internal file structure. Portrait effects mattes are currently only supported in HEIF and JPEG. This property is ignored if portraitEffectsMatteDeliveryEnabled is set to NO.
     */
    @available(iOS 12.0, *)
    open var embedsPortraitEffectsMatteInPhoto: Bool

    
    /**
     @property enabledSemanticSegmentationMatteTypes
     @abstract
        Specifies which types of AVSemanticSegmentationMatte should be captured along with the photo.
    
     @discussion
        Default is empty array. You may set this property to an array of AVSemanticSegmentationMatteTypes you'd like to capture. Throws an exception if -[AVCapturePhotoOutput enabledSemanticSegmentationMatteTypes] does not contain any of the AVSemanticSegmentationMatteTypes specified. In other words, when setting up a capture session, you opt in for the superset of segmentation matte types you might like to receive, and then on a shot-by-shot basis, you may opt in to all or a subset of the previously specified types by setting this property. An exception is also thrown during -[AVCapturePhotoOutput capturePhotoWithSettings:delegate:] if your delegate does not respond to the captureOutput:didFinishProcessingPhoto:error: selector. Setting this property to YES does not guarantee that the specified mattes will be present in the resulting AVCapturePhoto. If the photo's content lacks any persons, for instance, no hair, skin, or teeth mattes are generated, and the -[AVCapturePhoto semanticSegmentationMatteForType:] property returns nil. Note that setting this property to YES may add significant processing time to the delivery of your didFinishProcessingPhoto: callback.
     */
    @available(iOS 13.0, *)
    open var enabledSemanticSegmentationMatteTypes: [AVSemanticSegmentationMatte.MatteType]

    
    /**
     @property embedsSemanticSegmentationMattesInPhoto
     @abstract
        Specifies whether enabledSemanticSegmentationMatteTypes captured with this photo should be written to the photo's file structure.
    
     @discussion
        Default is YES. This property specifies whether the captured semantic segmentation mattes should be written to the resulting photo's internal file structure. Semantic segmentation mattes are currently only supported in HEIF and JPEG. This property is ignored if enabledSemanticSegmentationMatteTypes is set to an empty array.
     */
    @available(iOS 13.0, *)
    open var embedsSemanticSegmentationMattesInPhoto: Bool

    
    /**
     @property metadata
     @abstract
        A dictionary of metadata key/value pairs you'd like to have written to each photo in the capture request.
    
     @discussion
        Valid metadata keys are found in <ImageIO/CGImageProperties.h>. AVCapturePhotoOutput inserts a base set of metadata into each photo it captures, such as kCGImagePropertyOrientation, kCGImagePropertyExifDictionary, and kCGImagePropertyMakerAppleDictionary. You may specify metadata keys and values that should be written to each photo in the capture request. If you've specified metadata that also appears in AVCapturePhotoOutput's base set, your value replaces the base value. An NSInvalidArgumentException is thrown if you specify keys other than those found in <ImageIO/CGImageProperties.h>.
     */
    @available(iOS 11.0, *)
    open var metadata: [String : Any]

    
    /**
     @property livePhotoMovieFileURL
     @abstract
        Specifies that a Live Photo movie be captured to complement the still photo.
    
     @discussion
        A Live Photo movie is a short movie (with audio, if you've added an audio input to your session) containing the moments right before and after the still photo. A QuickTime movie file will be written to disk at the URL specified if it is a valid file URL accessible to your app's sandbox. You may only set this property if AVCapturePhotoOutput's livePhotoCaptureSupported property is YES. When you specify a Live Photo, your AVCapturePhotoCaptureDelegate object must implement -captureOutput:didFinishProcessingLivePhotoToMovieFileAtURL:duration:photoDisplayTime:resolvedSettings:error:.
     */
    open var livePhotoMovieFileURL: URL?

    
    /**
     @property livePhotoVideoCodecType
     @abstract
        Specifies the video codec type to use when compressing video for the Live Photo movie complement.
    
     @discussion
        Prior to iOS 11, all Live Photo movie video tracks are compressed using H.264. Beginning in iOS 11, you can select the Live Photo movie video compression format by specifying one of the strings present in AVCapturePhotoOutput's availableLivePhotoVideoCodecTypes array.
     */
    @available(iOS 11.0, *)
    open var livePhotoVideoCodecType: AVVideoCodecType

    
    /**
     @property livePhotoMovieMetadata
     @abstract
        Movie-level metadata to be written to the Live Photo movie.
    
     @discussion
        An array of AVMetadataItems to be inserted into the top level of the Live Photo movie. The receiver makes immutable copies of the AVMetadataItems in the array. Live Photo movies always contain a AVMetadataQuickTimeMetadataKeyContentIdentifier which allow them to be paired with a similar identifier in the MakerNote of the photo complement. AVCapturePhotoSettings generates a unique content identifier for you. If you provide a metadata array containing an AVMetadataItem with keyspace = AVMetadataKeySpaceQuickTimeMetadata and key = AVMetadataQuickTimeMetadataKeyContentIdentifier, an NSInvalidArgumentException is thrown.
     */
    open var livePhotoMovieMetadata: [AVMetadataItem]!

    
    /**
     @property availablePreviewPhotoPixelFormatTypes
     @abstract
        An array of available kCVPixelBufferPixelFormatTypeKeys that may be used when specifying a previewPhotoFormat.
     
     @discussion
        The array is sorted such that the preview format requiring the fewest conversions is presented first.
     */
    open var __availablePreviewPhotoPixelFormatTypes: [NSNumber] { get }

    
    /**
     @property previewPhotoFormat
     @abstract
        A dictionary of Core Video pixel buffer attributes specifying the preview photo format to be delivered along with the RAW or processed photo.
    
     @discussion
        A dictionary of pixel buffer attributes specifying a smaller version of the RAW or processed photo for preview purposes. The kCVPixelBufferPixelFormatTypeKey is required and must be present in the receiver's -availablePreviewPhotoPixelFormatTypes array. Optional keys are { kCVPixelBufferWidthKey | kCVPixelBufferHeightKey }. If you wish to specify dimensions, you must add both width and height. Width and height are only honored up to the display dimensions. If you specify a width and height whose aspect ratio differs from the RAW or processed photo, the larger of the two dimensions is honored and aspect ratio of the RAW or processed photo is always preserved.
     */
    open var previewPhotoFormat: [String : Any]?

    
    /**
     @property availableEmbeddedThumbnailPhotoCodecTypes
     @abstract
        An array of available AVVideoCodecKeys that may be used when specifying an embeddedThumbnailPhotoFormat.
     
     @discussion
        The array is sorted such that the thumbnail codec type that is most backward compatible is listed first.
     */
    @available(iOS 11.0, *)
    open var availableEmbeddedThumbnailPhotoCodecTypes: [AVVideoCodecType] { get }

    
    /**
     @property embeddedThumbnailPhotoFormat
     @abstract
        A dictionary of AVVideoSettings keys specifying the thumbnail format to be written to the processed or RAW photo.
    
     @discussion
        A dictionary of AVVideoSettings keys specifying a thumbnail (usually smaller) version of the processed photo to be embedded in that image before calling the AVCapturePhotoCaptureDelegate. This image is sometimes referred to as a "thumbnail image". The AVVideoCodecKey is required and must be present in the receiver's -availableEmbeddedThumbnailPhotoCodecTypes array. Optional keys are { AVVideoWidthKey | AVVideoHeightKey }. If you wish to specify dimensions, you must specify both width and height. If you specify a width and height whose aspect ratio differs from the processed photo, the larger of the two dimensions is honored and aspect ratio of the RAW or processed photo is always preserved. For RAW captures, use -rawEmbeddedThumbnailPhotoFormat to specify the thumbnail format you'd like to capture in the RAW image. For apps linked on or after iOS 12, the raw thumbnail format must be specified using the -rawEmbeddedThumbnailPhotoFormat API rather than -embeddedThumbnailPhotoFormat. Beginning in iOS 12, HEIC files may contain thumbnails up to the full resolution of the main image.
     */
    @available(iOS 11.0, *)
    open var embeddedThumbnailPhotoFormat: [String : Any]?

    
    /**
     @property availableRawEmbeddedThumbnailPhotoCodecTypes
     @abstract
        An array of available AVVideoCodecKeys that may be used when specifying a rawEmbeddedThumbnailPhotoFormat.
     
     @discussion
        The array is sorted such that the thumbnail codec type that is most backward compatible is listed first.
     */
    @available(iOS 12.0, *)
    open var availableRawEmbeddedThumbnailPhotoCodecTypes: [AVVideoCodecType] { get }

    
    /**
     @property rawEmbeddedThumbnailPhotoFormat
     @abstract
        A dictionary of AVVideoSettings keys specifying the thumbnail format to be written to the RAW photo in a RAW photo request.
    
     @discussion
        A dictionary of AVVideoSettings keys specifying a thumbnail (usually smaller) version of the RAW photo to be embedded in that image's DNG before calling back the AVCapturePhotoCaptureDelegate. The AVVideoCodecKey is required and must be present in the receiver's -availableRawEmbeddedThumbnailPhotoCodecTypes array. Optional keys are { AVVideoWidthKey | AVVideoHeightKey }. If you wish to specify dimensions, you must specify both width and height. If you specify a width and height whose aspect ratio differs from the RAW or processed photo, the larger of the two dimensions is honored and aspect ratio of the RAW or processed photo is always preserved. For apps linked on or after iOS 12, the raw thumbnail format must be specified using the -rawEmbeddedThumbnailPhotoFormat API rather than -embeddedThumbnailPhotoFormat. Beginning in iOS 12, DNG files may contain thumbnails up to the full resolution of the RAW image.
     */
    @available(iOS 12.0, *)
    open var rawEmbeddedThumbnailPhotoFormat: [String : Any]?
}

@available(iOS 10.0, *)
extension AVCapturePhotoSettings {

    @available(swift 4.0)
    @available(iOS 10.0, *)
    @nonobjc public var availablePreviewPhotoPixelFormatTypes: [OSType] { get }
}


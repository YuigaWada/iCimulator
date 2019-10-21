//
//   ** iCimulator.swift **
//


// MIT License
//
// Copyright (c) 2019 YuigaWada
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//



#if targetEnvironment(simulator)
    import iCimulator

    //AVFoundation
    public typealias AVCaptureDevice = FakeCaptureDevice
    public typealias AVCaptureSession = FakeCaptureSession
    public typealias AVCaptureVideoPreviewLayer = FakePreviewLayer
    public typealias AVCapturePhotoOutput = FakeCapturePhotoOutput
    public typealias AVCapturePhotoCaptureDelegate = FakeCapturePhotoCaptureDelegate
    public typealias AVCapturePhoto = FakeCapturePhoto
    public typealias AVCaptureDeviceInput = FakeCaptureDeviceInput
    public typealias AVCaptureMovieFileOutput = FakeCaptureMovieFileOutput
    public typealias AVCaptureFileOutput = FakeCaptureFileOutput
    public typealias AVCaptureFileOutputRecordingDelegate = FakeCaptureFileOutputRecordingDelegate
    public typealias AVCaptureConnection = FakeCaptureConnection
    public typealias AVCapturePhotoSettings = FakeCapturePhotoSettings
    public typealias AVCaptureResolvedPhotoSettings = FakeCaptureResolvedPhotoSettings


    //For supporting iOS 10.
    public typealias AVCaptureStillImageOutput = FakeCaptureStillImageOutput
    public typealias CMSampleBuffer = FakeCMSampleBuffer

    //UIImagePickerController
    public typealias UIImagePickerController = FakeImagePickerController
    public typealias UIImagePickerControllerDelegate = FakeImagePickerControllerDelegate
#endif


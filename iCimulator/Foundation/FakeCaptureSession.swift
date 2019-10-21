//
//  FakeCaptureSession.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation

open class FakeCaptureSession: _FakeCaptureSession {
    open weak var mainCenter: FakePreviewLayer?

    open func addOutput(_ output: FakeCaptureOutput) {
        outputs.append(output)
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
    
    //TODO: FIX IT.
    open func addOutput(_ output: FakeCapturePhotoOutput) {
        //outputs.append(output as! FakeCaptureOutput)
        //FakeCapturePhotoOutputの親元が既存のAVCapture~~クラスなのでキャストできない
        
        output.session = self
    }
    
}

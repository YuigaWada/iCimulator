//
//  iCimulatorTests.swift
//  iCimulatorTests
//
//  Created by Yuiga Wada on 2019/10/15.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import XCTest
import AVFoundation
@testable import iCimulator

class iCimulatorTests: XCTestCase {

    private var layerInstance: FakePreviewLayer?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        layerInstance = FakePreviewLayer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() {
        let testSession = AVCaptureSession()
        FakePreviewLayer(sessionWithNoConnection: testSession)
    }
}

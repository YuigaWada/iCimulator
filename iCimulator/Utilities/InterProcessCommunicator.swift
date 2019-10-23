//
//  InterProcessCommunication.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/22.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import Network

@available(iOS 12, *)
internal class InterProcessCommunicator {
    private var connection: NWConnection?
    private var savedImages: [UIImage] = []
    private var tempImage: Data?
    
    private var isRecording: Bool = false
    private var willDeinit: Bool = false
    
    
    //-MARK: Network Method
    internal func connect(_  handler: @escaping (UIImage)->Void) {
        let myQueue = DispatchQueue.global()
        
        do {
            let listener = try NWListener(using: .udp, on: 5005)
            listener.newConnectionHandler = { [weak self] (newConnection) in
                guard let self = self , !self.willDeinit else { listener.cancel(); return }
                
                // Handle inbound connections
                print("iCimulator: UDP connection is ok")
                
                newConnection.start(queue: myQueue)
                self.receive(on: newConnection, handler: handler)
            }
            print("iCimulator: listener starts")
            listener.start(queue: .global())
        }
        catch {
            print(error)
        }
        print("iCimulator: UDP connection ends")
    }


    private func receive(on connection: NWConnection, handler: @escaping (UIImage)->Void) {
        guard !self.willDeinit else { return }
        
        connection.receiveMessage { [weak self](data: Data?, _: NWConnection.ContentContext?, _: Bool, error: NWError?) in
            guard let self = self else { return }
            
            if let error = error { fatalError(error.localizedDescription) }
            guard let data = data else { self.receive(on: connection, handler: handler); return }
            
            if data.count != 1 {
                if let _ = self.tempImage {
                    self.tempImage!.append(data)
//                    print(self.tempImage!.count)
                }
                else {
                    self.tempImage = data
                }
            }
            else {
                guard let tempImage = self.tempImage, let image = UIImage(data: tempImage)
                    else { self.receive(on: connection, handler: handler); return }
                
                if self.isRecording { self.savedImages.append(image) } // Saves each images if recording was started.
                handler(image) // Updates contents of FakePreviewLayer.
                
                self.tempImage = nil
            }
            
            self.receive(on: connection, handler: handler)
//            print("Received Message: \(data)")
        }
    }
    
    
    //-MARK: Communicating Method
    internal func startRecording() {
        self.isRecording = true
    }
    
    internal func stopRecording()-> [UIImage] {
        let images = savedImages // In theory, savedImages is deep-copied.
        
        savedImages = []
        self.isRecording = false
        return images
    }
    
    internal func detachConnection() {
        willDeinit = true
    }
}

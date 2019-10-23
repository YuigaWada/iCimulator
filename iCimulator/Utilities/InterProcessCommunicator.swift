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
    private var images: [UIImage] = []
    private var tempImage: Data?
    
    internal func connect(_  handler: @escaping (UIImage)->Void) {
        let myQueue = DispatchQueue.global()
        
        do {
            let listener = try NWListener(using: .udp, on: 5005)
            listener.newConnectionHandler = {  (newConnection) in
                // Handle inbound connections
                print("connection ok")
                
                newConnection.start(queue: myQueue)
                self.receive(on: newConnection, handler: handler)
            }
            print("listener start")
            listener.start(queue: .global())
        }
        catch {
            print(error)
        }
        print("end")
    }


    private func receive(on connection: NWConnection, handler: @escaping (UIImage)->Void) {
        connection.receiveMessage { (data: Data?, _: NWConnection.ContentContext?, _: Bool, error: NWError?) in
            if let error = error { fatalError(error.localizedDescription) }
            guard let data = data else { self.receive(on: connection, handler: handler); return }
            
            if data.count != 1 {
                if let _ = self.tempImage {
                    self.tempImage!.append(data)
                    print(self.tempImage!.count)
                }
                else {
                    self.tempImage = data
                }
            }
            else {
                guard let tempImage = self.tempImage, let image = UIImage(data: tempImage)
                    else { self.receive(on: connection, handler: handler); return }
                
                self.images.append(image)
                handler(image) // Updates contents of FakePreviewLayer.
                
                self.tempImage = nil
            }
            
            self.receive(on: connection, handler: handler)
            print("Received Message: \(data)")
        }
    }
}

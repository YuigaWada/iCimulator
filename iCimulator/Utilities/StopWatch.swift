//
//  StopWatch.swift
//  iCimulator
//
//  Created by Yuiga Wada on 2019/10/17.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

internal class StopWatch {
    private var startDate: Date?

    func start() {
        startDate = Date() //Updating Date.
    }
    
    func stop()-> TimeInterval? {
        guard let startDate = self.startDate else { return nil }
        
        return Date().timeIntervalSince(startDate)
    }

}

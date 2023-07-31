//
//  Logger.swift
//  PinkNews
//
//  Created by Michael Thornton on 1/11/22.
//  Copyright © 2022 Michael Thornton. All rights reserved.
//

import Foundation


extension Notification.Name {
    static let logsUpdated = Notification.Name("logMessage")
}



class Logger {
    
    static let shared = Logger()
    
    private init() {}

    private var logs = [String]()
    
    
    
    var count: Int {
        return logs.count
    }
    
    
    
    func clear() {
        logs.removeAll()
        NotificationCenter.default.post(name: .logsUpdated, object: nil)
    }
    
    
    
    func log(_ message: String) {
     
        print(message)
        logs.append(message)
        NotificationCenter.default.post(name: .logsUpdated, object: nil)
    }
    
    
    
    func messageForIndex(_ index: Int) -> String {
        return logs[index]
    }

    
} // end class

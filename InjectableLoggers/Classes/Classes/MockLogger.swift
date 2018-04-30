//
//  MockLogger.swift
//  Zoomy_Example
//
//  Created by Menno on 30/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

open class MockLogger: HasDefaultLoglevel {
    
    public var defaultLogLevel: Loglevel = .info
    
    public typealias LoggedMessage = (level: Loglevel, message: Any)
    
    public private(set) var loggedMessages = [LoggedMessage]()
    
    public init() {}
}

extension MockLogger: CanLogMessageAtLevel {
    
    open func log(_ message: Any, at level: Loglevel) {
        loggedMessages.append((level: level, message: message))
    }
}

public extension MockLogger {
    
    func loggedMessages(at logLevel: Loglevel) -> [LoggedMessage] {
        return loggedMessages.filter{ $0.level == logLevel }
    }
}

//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

public protocol CanLogMessage: CanLog {
    
    func log(_ message: Any)
}

extension CanLogMessage {
    
    public func log() {
        log("")
    }
}

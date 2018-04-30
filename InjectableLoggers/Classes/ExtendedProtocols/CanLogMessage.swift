public protocol CanLogMessage: CanLog {
    
    func log(_ message: Any)
}

public extension CanLogMessage {
    
    func log() {
        log("")
    }
    
    func log(_ message: Any) {
        print(message)
    }
}

public protocol CanLogMessageAtLevel: CanLogMessage {
    
    func log(_ message: Any, at level: Loglevel)
}

extension CanLogMessageAtLevel {
    
    public func log(_ message: Any) {
        log(message, at: Loglevel.info)
    }
}

extension CanLogMessageAtLevel where Self: HasDefaultLoglevel {
    
    public func log(_ message: Any) {
        log(message, at: defaultLogLevel)
    }
}

open class Logger {
    
    public var settings: Settings
    
    public required init(settings: Settings) {
        self.settings = settings
    }
    
    public convenience init() {
        self.init(settings: .verboseSettings)
    }
}

extension Logger: HasDefaultLoglevel {
    
    public var defaultLogLevel: Loglevel {
        return settings.defaultLogLevel
    }
}

//MARK: CanLogMessageAtLevel
extension Logger: CanLogMessageAtLevel {
    
    open func log(_ message: Any, at level: Loglevel) {
        guard shouldLog(at: level) else { return }
        
        settings.destination.log(string(for: message, at: level))
    }
}

extension Logger {
    
    open func string(for message: Any, at level: Loglevel) -> String {
        return "\(string(for: level)) \(message)"
    }
    
    open func string(for level: Loglevel) -> String {
        switch level {
        case .none:
            return ""
        case .error:
            return "⛔️"
        case .warning:
            return "⚠️"
        case .info:
            return "ℹ️"
        case .verbose:
            return "🔍"
        }
    }
    
    open func shouldLog(at level: Loglevel) -> Bool {
        guard level != .none else { return false }
        return level.rawValue >= settings.activeLogLevel.rawValue
    }
}

//MARK: - Logger.Settings
extension Logger {
    
    public struct Settings {
        /// All messages with loglevel equal to or above this logLevel will be logged
        public var activeLogLevel: Loglevel
        
        /// Messages logged without a logLevel will automatically be logged at this logLevel
        public var defaultLogLevel: Loglevel
        
        /// All messages crated by logger will be logged to this destination
        /// By default this destination will be a ConsoleLogger but any other destination can be injected either here on in the constructor
        public var destination: CanLogMessage
        
        public init(activeLogLevel: Loglevel = .verbose, defaultLogLevel: Loglevel = .info, destination: CanLogMessage = ConsoleLogger()) {
            self.activeLogLevel = activeLogLevel
            self.defaultLogLevel = defaultLogLevel
            self.destination = destination
        }
    }
}

public extension Logger.Settings {
    
    /// Will cause messages for all levels to be logged to the destination
    static var verboseSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .verbose
        return settings
    }
    
    /// Will cause messages for Loglevel.info and higher to be logged to the destination
    static var infoSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .info
        return settings
    }
    
    /// Will cause messages for Loglevel.warning and higher to be logged to the destination
    static var warningSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .warning
        return settings
    }
    
    /// Will cause messages for Loglevel.error and higher to be logged to the destination
    static var errorSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .error
        return settings
    }
    
    /// Will cause no message to be logged to the destination
    static var inactiveSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .none
        return settings
    }
    
    /// Same settings but with provided defaultLogLevel
    func with(defaultLogLevel: Loglevel) -> Logger.Settings {
        var settings = self
        settings.defaultLogLevel = defaultLogLevel
        return settings
    }
    
    /// Same settings but with provided destination
    func with(destination: CanLogMessage) -> Logger.Settings {
        var settings = self
        settings.destination = destination
        return settings
    }
}

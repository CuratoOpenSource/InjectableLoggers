//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

public protocol HasDefaultLoglevel {
    
    var defaultLogLevel: Loglevel { get }
}

public extension HasDefaultLoglevel {
    
    var defaultLogLevel: Loglevel {
        return .info
    }
}

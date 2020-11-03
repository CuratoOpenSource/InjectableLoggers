//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

public protocol CanLog {
    
    func log()
}

public extension CanLog {
    
    func log() {
        print("")
    }
}

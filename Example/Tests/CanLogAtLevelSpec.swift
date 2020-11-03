//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

import Quick
import Nimble
import InjectableLoggers

class CanLogAtLevelSpec: QuickSpec {
    
    override func spec() {

        given("a logger conforming to CanLogAtLevel") {
            var sut: CanLogAtLevel!
            var relayMock: MockLogger!
            
            beforeEach {
                let logger = SimpleLogger()
                relayMock = MockLogger()
                logger.relay = relayMock
                sut = logger
            }
            
            when("logging an error", closure: {
                beforeEach {
                    sut.logError()
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(""))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.error))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging a warning", closure: {
                beforeEach {
                    sut.logWarning()
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(""))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.warning))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging info", closure: {
                beforeEach {
                    sut.logInfo()
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(""))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.info))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging verbose", closure: {
                beforeEach {
                    sut.logVerbose()
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(""))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.verbose))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
        }
    }
}

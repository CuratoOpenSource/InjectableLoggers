import Quick
import Nimble
import InjectableLoggers

class CanLogMessageAtLevelInFileInFunctionAtLineSpec: QuickSpec {
    
    override func spec() {

        given("a logger conforming to CanLogMessageAtLevelInFileInFunctionAtLine") {
            var sut: CanLogMessageAtLevelInFileInFunctionAtLine!
            var relayMock: MockLogger!
            let stubMessage = "stubMessage"
            
            beforeEach {
                let logger = Logger()
                relayMock = MockLogger()
                logger.relay = relayMock
                sut = logger
            }
            
            when("logging an error message", closure: {
                beforeEach {
                    sut.logError(stubMessage)
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(stubMessage))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.error))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging a warning message", closure: {
                beforeEach {
                    sut.logWarning(stubMessage)
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(stubMessage))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.warning))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging info message", closure: {
                beforeEach {
                    sut.logInfo(stubMessage)
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(stubMessage))
                })
                
                then("it logged at Loglevel.error", closure: {
                    expect(relayMock.loggedMessages.last?.level).to(equal(Loglevel.info))
                })
                
                then("It logged 1 message", closure: {
                    expect(relayMock.loggedMessages.count).to(equal(1))
                })
            })
            
            when("logging verbose message", closure: {
                beforeEach {
                    sut.logVerbose(stubMessage)
                }
                
                then("It logged an empty message", closure: {
                    expect(relayMock.loggedMessages.last?.message as? String).to(equal(stubMessage))
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

//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

import Quick
import Nimble
import InjectableLoggers

class SimpleLoggerSpec: QuickSpec {
    
    override func spec() {
        
        given("a SimpleLogger") {
            
            var sut: SimpleLogger!
            var settings: SimpleLogger.Settings!
            var mockDestination: MockLogger!
            
            beforeEach {
                mockDestination = MockLogger()
                
                settings = SimpleLogger.Settings()
                settings.loglevelStrings = [.verbose: "🔍", .info: "ℹ️", .warning: "⚠️", .error:"⛔️"]
                settings.activeLogLevel = .verbose
                settings.destination = mockDestination
            }
            
            context("relay", {
                
                let mockRelay = MockLogger()
                
                beforeEach {
                    settings.defaultLogLevel = .verbose
                    sut = SimpleLogger(settings: settings)
                    sut.relay = mockRelay
                }
                
                it("logs everyting to relay", closure: {
                    sut.log()
                    expect(mockRelay.loggedMessages(atLevel: settings.defaultLogLevel).last?.message as? String).to(equal(""))
                    
                    sut.log("a", atLevel: .verbose)
                    expect(mockRelay.loggedMessages(atLevel: Loglevel.verbose).last?.message as? String).to(equal("a"))
                    
                    sut.log("b", atLevel: .info)
                    expect(mockRelay.loggedMessages(atLevel: Loglevel.info).last?.message as? String).to(equal("b"))
                    
                    sut.log("c", atLevel: .warning)
                    expect(mockRelay.loggedMessages(atLevel: Loglevel.warning).last?.message as? String).to(equal("c"))
                    
                    sut.log("d", atLevel: .error)
                    expect(mockRelay.loggedMessages(atLevel: Loglevel.error).last?.message as? String).to(equal("d"))
                    
                    sut.log("e", atLevel: .inactive)
                    expect(mockRelay.loggedMessages(atLevel: Loglevel.inactive).last?.message as? String).to(equal("e"))
                    
                    expect(mockRelay.loggedMessages.count).to(equal(6))
                })
            })
            
            context("default loglevel", {
                
                context("verbose", {
                    
                    beforeEach {
                        settings.defaultLogLevel = .verbose
                        sut = SimpleLogger(settings: settings)
                    }
                    
                    it("logs to destination", closure: {
                        sut.log()
                        sut.log("message")
                        
                        expect(mockDestination.loggedMessages[0].message as? String).to(equal("🔍"))
                        expect(mockDestination.loggedMessages[1].message as? String).to(equal("🔍 message"))
                        expect(mockDestination.loggedMessages.count).to(equal(2))
                    })
                })
                
                context("info", {
                    
                    beforeEach {
                        settings.defaultLogLevel = .info
                        sut = SimpleLogger(settings: settings)
                    }
                    
                    it("logs to destination", closure: {
                        sut.log()
                        sut.log("message")
                        
                        expect(mockDestination.loggedMessages[0].message as? String).to(equal("ℹ️"))
                        expect(mockDestination.loggedMessages[1].message as? String).to(equal("ℹ️ message"))
                        expect(mockDestination.loggedMessages.count).to(equal(2))
                    })
                })
                
                context("warning", {
                    
                    beforeEach {
                        settings.defaultLogLevel = .warning
                        sut = SimpleLogger(settings: settings)
                    }
                    
                    it("logs to destination", closure: {
                        sut.log()
                        sut.log("message")
                        
                        expect(mockDestination.loggedMessages[0].message as? String).to(equal("⚠️"))
                        expect(mockDestination.loggedMessages[1].message as? String).to(equal("⚠️ message"))
                        expect(mockDestination.loggedMessages.count).to(equal(2))
                    })
                })
                
                context("error", {
                    
                    beforeEach {
                        settings.defaultLogLevel = .error
                        sut = SimpleLogger(settings: settings)
                    }
                    
                    it("logs to destination", closure: {
                        sut.log()
                        sut.log("message")
                        
                        expect(mockDestination.loggedMessages[0].message as? String).to(equal("⛔️"))
                        expect(mockDestination.loggedMessages[1].message as? String).to(equal("⛔️ message"))
                        expect(mockDestination.loggedMessages.count).to(equal(2))
                    })
                })
                
                context("inactive", {
                    
                    beforeEach {
                        settings.defaultLogLevel = .inactive
                        sut = SimpleLogger(settings: settings)
                    }
                    
                    it("logs to destination", closure: {
                        sut.log()
                        sut.log("message")
                        
                        expect(mockDestination.loggedMessages.count).to(equal(0))
                    })
                })
            })
            
            context("independent of loglevel", {
                
                beforeEach {
                    sut = SimpleLogger(settings: settings)
                }
                
                it("logs to destination", closure: {
                    sut.log(atLevel: Loglevel.verbose)
                    sut.log(atLevel: Loglevel.info)
                    sut.log(atLevel: Loglevel.warning)
                    sut.log(atLevel: Loglevel.error)
                    sut.log(atLevel: Loglevel.inactive)
                    
                    sut.log("message", atLevel: Loglevel.verbose)
                    sut.log("message", atLevel: Loglevel.info)
                    sut.log("message", atLevel: Loglevel.warning)
                    sut.log("message", atLevel: Loglevel.error)
                    sut.log("message", atLevel: Loglevel.inactive)
                    
                    expect(mockDestination.loggedMessages[0].message as? String).to(equal("🔍"))
                    expect(mockDestination.loggedMessages[1].message as? String).to(equal("ℹ️"))
                    expect(mockDestination.loggedMessages[2].message as? String).to(equal("⚠️"))
                    expect(mockDestination.loggedMessages[3].message as? String).to(equal("⛔️"))
                    
                    expect(mockDestination.loggedMessages[4].message as? String).to(equal("🔍 message"))
                    expect(mockDestination.loggedMessages[5].message as? String).to(equal("ℹ️ message"))
                    expect(mockDestination.loggedMessages[6].message as? String).to(equal("⚠️ message"))
                    expect(mockDestination.loggedMessages[7].message as? String).to(equal("⛔️ message"))
                    
                    expect(mockDestination.loggedMessages.count).to(equal(8))
                })
            })
        }
    }
}

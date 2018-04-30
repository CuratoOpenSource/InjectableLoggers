import XCTest
import InjectableLoggers

class LoggerTests: XCTestCase {
    
    var sut: Logger!
    
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
    
        sut = Logger()
        mockLogger = MockLogger()
    }
    
    func testInit() {
        //Act
        sut = Logger()
        
        //Assert
        XCTAssertEqual(sut.settings.activeLogLevel, Loglevel.verbose)
        XCTAssertEqual(sut.settings.defaultLogLevel, Loglevel.info)
        XCTAssert(sut.settings.destination is ConsoleLogger)
    }
    
    func testLog1() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "🔍 ")
    }
    
    func testLog2() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .info
        sut.settings.destination = mockLogger
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "ℹ️ ")
    }
    
    func testLog3() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .warning
        sut.settings.destination = mockLogger
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "⚠️ ")
    }
    
    func testLog4() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .error
        sut.settings.destination = mockLogger
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "⛔️ ")
    }
    
    func testLogMessage1() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        sut.log("pretty random message")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "🔍 pretty random message")
    }
    
    func testLogMessage2() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .info
        sut.settings.destination = mockLogger
        
        //Act
        sut.log("pretty random message")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "ℹ️ pretty random message")
    }
    
    func testLogMessage3() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .warning
        sut.settings.destination = mockLogger
        
        //Act
        sut.log("pretty random message")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "⚠️ pretty random message")
    }
    
    func testLogMessage4() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.defaultLogLevel = .error
        sut.settings.destination = mockLogger
        
        //Act
        sut.log("pretty random message")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "⛔️ pretty random message")
    }
    
    func testLogMessageAtLevel1() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log("pretty random message", at: Loglevel.verbose)
        }
        
        //Assert
        for loggedMesssage in mockLogger.loggedMessages {
            XCTAssertEqual(loggedMesssage.message as? String, "🔍 pretty random message")
        }
        
        XCTAssert(Loglevel.all.count > 0)
        XCTAssertEqual(mockLogger.loggedMessages.count, Loglevel.all.count)
    }

    func testLogMessageAtLevel2() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log("pretty random message", at: Loglevel.info)
        }
        
        //Assert
        for loggedMesssage in mockLogger.loggedMessages {
            XCTAssertEqual(loggedMesssage.message as? String, "ℹ️ pretty random message")
        }
        
        XCTAssert(Loglevel.all.count > 0)
        XCTAssertEqual(mockLogger.loggedMessages.count, Loglevel.all.count)
    }

    func testLogMessageAtLevel3() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log("pretty random message", at: Loglevel.warning)
        }
        
        //Assert
        for loggedMesssage in mockLogger.loggedMessages {
            XCTAssertEqual(loggedMesssage.message as? String, "⚠️ pretty random message")
        }
        
        XCTAssert(Loglevel.all.count > 0)
        XCTAssertEqual(mockLogger.loggedMessages.count, Loglevel.all.count)
    }

    func testLogMessageAtLevel4() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log("pretty random message", at: Loglevel.error)
        }
        
        //Assert
        for loggedMesssage in mockLogger.loggedMessages {
            XCTAssertEqual(loggedMesssage.message as? String, "⛔️ pretty random message")
        }
        
        XCTAssert(Loglevel.all.count > 0)
        XCTAssertEqual(mockLogger.loggedMessages.count, Loglevel.all.count)
    }
    
    func testLogMessageAtLevel5() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        //Act
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log("pretty random message", at: Loglevel.none)
        }
        
        //Assert
        XCTAssert(Loglevel.all.count > 0)
        XCTAssertEqual(mockLogger.loggedMessages.count, 0)
    }

    func testActiveLogLevel1() {
        //Arrange
        sut.settings.activeLogLevel = .none
        sut.settings.destination = mockLogger
        
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log()
            sut.log("random message")
            sut.log("random message", at: logLevel)
        }
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 0)
        XCTAssert(Loglevel.all.count > 0)
    }
    
    func testActiveLogLevel2() {
        //Arrange
        sut.settings.activeLogLevel = .error
        sut.settings.destination = mockLogger
        
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log()
            sut.log("random message")
            sut.log("random message", at: logLevel)
        }
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 3) // .error * 3
    }
    
    func testActiveLogLevel3() {
        //Arrange
        sut.settings.activeLogLevel = .warning
        sut.settings.destination = mockLogger
        
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log()
            sut.log("random message")
            sut.log("random message", at: logLevel)
        }
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 6) // .error * 3 + .warning * 3
    }
    
    func testActiveLogLevel4() {
        //Arrange
        sut.settings.activeLogLevel = .info
        sut.settings.destination = mockLogger
        
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log()
            sut.log("random message")
            sut.log("random message", at: logLevel)
        }
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 9) // .error * 3 + .warning * 3 + .info * 3
    }
    
    func testActiveLogLevel5() {
        //Arrange
        sut.settings.activeLogLevel = .verbose
        sut.settings.destination = mockLogger
        
        for logLevel in Loglevel.all {
            //Arrange
            sut.settings.defaultLogLevel = logLevel
            
            //Act
            sut.log()
            sut.log("random message")
            sut.log("random message", at: logLevel)
        }
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.count, 12) // .error * 3 + .warning * 3 + .info * 3 + .verbose * 3
    }
}

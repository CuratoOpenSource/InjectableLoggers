import XCTest
import InjectableLoggers

class CanLogMessageAtLevelTests: XCTestCase {

    var sut: (CanLogMessageAtLevel & HasDefaultLoglevel)!
    
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
        
        mockLogger = MockLogger()
        sut = mockLogger
    }
    
    func testLog1() {
        //Arrange
        mockLogger.defaultLogLevel = .info
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.info)
    }
    
    func testLog2() {
        //Arrange
        mockLogger.defaultLogLevel = .warning
        
        //Act
        sut.log()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
    
    func testLogMessage1() {
        //Arrange
        mockLogger.defaultLogLevel = .info
        
        //Act
        sut.log("randomMessage")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "randomMessage")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.info)
    }
    
    func testLogMessage2() {
        //Arrange
        mockLogger.defaultLogLevel = .verbose
        
        //Act
        sut.log("randomMessage")
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "randomMessage")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.verbose)
    }
    
    func testLogMessageAtLevel1() {
        //Act
        sut.log("randomMessage", at: Loglevel.info)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "randomMessage")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.info)
    }
    
    func testLogMessageAtLevel2() {
        //Act
        sut.log("randomMessage", at: Loglevel.warning)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "randomMessage")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
}

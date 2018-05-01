import XCTest
import InjectableLoggers

class SharedLoggerViewControllerTests: XCTestCase {
    
    var sut: SharedLoggerViewController!
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
        
        sut = SharedLoggerViewController()
        mockLogger = MockLogger()
    }
    
    // MARK: Single line assertions
    func testViewDidLoad() {
        //Arrange
        logger.relay = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLoad()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.info).last?.message as? String, "0️⃣")
    }
    
    func testViewViewDidLayoutSubviews() {
        //Arrange
        logger.relay = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLayoutSubviews()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.verbose).last?.message as? String, "1️⃣")
    }
    
    // MARK: More verbose assertions
    func testViewDidAppear() {
        //Arrange
        logger.relay = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidAppear(false)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "2️⃣")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.verbose)
    }
    
    func testDidReceiveMemoryWarning() {
        //Arrange
        logger.relay = mockLogger //Inject mockLogger
        
        //Act
        sut.didReceiveMemoryWarning()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "3️⃣")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
}

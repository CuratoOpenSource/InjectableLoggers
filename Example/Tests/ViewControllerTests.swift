import XCTest
import InjectableLoggers

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
        
        sut = ViewController()
        mockLogger = MockLogger()
    }
    
    // MARK: Single line assertions
    func testViewDidLoad() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLoad()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(at: Loglevel.info).last?.message as? String, "viewDidLoad()")
    }
    
    func testViewViewDidLayoutSubviews() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLayoutSubviews()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(at: Loglevel.verbose).last?.message as? String, "viewDidLayoutSubviews()")
    }
    
    // MARK: More verbose assertions
    func testViewDidAppear() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidAppear(false)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "viewDidAppear")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.verbose)
    }
    
    func testDidReceiveMemoryWarning() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.didReceiveMemoryWarning()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "didReceiveMemoryWarning()")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
}

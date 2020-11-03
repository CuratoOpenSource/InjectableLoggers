//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

import XCTest
import InjectableLoggers

class InjectableLoggerViewControllerTests: XCTestCase {
    
    var sut: InjectableLoggerViewController!
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
        
        sut = InjectableLoggerViewController()
        mockLogger = MockLogger()
    }
    
    // MARK: Single line assertions
    func testViewDidLoad() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLoad()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.info).last?.message as? String, "viewDidLoad()")
    }
    
    func testViewViewDidLayoutSubviews() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLayoutSubviews()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(atLevel: Loglevel.verbose).last?.message as? String, "viewDidLayoutSubviews()")
    }
    
    // MARK: More verbose assertions
    func testViewDidAppear() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidAppear(false)
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "viewDidAppear(_:)")
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

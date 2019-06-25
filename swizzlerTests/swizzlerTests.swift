//
//  swizzlerTests.swift
//  swizzlerTests
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import XCTest
@testable import swizzler

class swizzlerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Swizzler.shared.startRecording()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Swizzler.shared.stopRecording()
    }
    
    func testFileCreation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: "https://yahoo.com")!).resume()
        
        XCTAssertTrue(FileManager.default.isReadableFile(atPath: (Swizzler.shared.saver as! FileRecordSaver).filePath))
    }
    
    func testRedirect() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: "https://yahoo.com")!, completionHandler: { data, response, error in
            let result = try! String(contentsOfFile: (Swizzler.shared.saver as! FileRecordSaver).filePath, encoding: .utf8)
            
            XCTAssertTrue(result.contains("https://yahoo.com,") && result.contains("https://www.yahoo.com/, SUCCESS")) // XXX: use regex to make sure this is on the same line
            
            expectation.fulfill()
        }).resume()
        
        XCTAssertTrue(FileManager.default.isReadableFile(atPath: (Swizzler.shared.saver as! FileRecordSaver).filePath))
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

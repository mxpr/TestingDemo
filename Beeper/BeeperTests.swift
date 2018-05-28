//
//  BeeperTests.swift
//  TestingDemoTests
//
//  Created by Kassem Wridan on 28/05/2018.
//  Copyright © 2018 matrixprojects.net. All rights reserved.
//

import XCTest
@testable import TestingDemo

class BeeperTests: XCTestCase {
    var subject: DarwinNotificationCenterBeeper!
    
    override func setUp() {
        super.setUp()
        
        subject = DarwinNotificationCenterBeeper()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testRegisteringNotificationsAreCalled() {
        let e = expectation(description: "test1 called")
        subject.registerBeepHandler(identifier: "test1") {
            e.fulfill()
        }
        
        subject.beep(identifier: "test1")
        
        wait(for: [e], timeout: 2)
    }
    
    func testUnRegisteringNotificationsAreNotCalled() {
        subject.registerBeepHandler(identifier: "test1") {
            XCTFail("handler should not be called")
        }
        
        subject.unregisterBeepHandler(identifier: "test1")
        subject.beep(identifier: "test1")
    }
}

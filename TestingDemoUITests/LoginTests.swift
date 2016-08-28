//
//  LoginTests.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import Foundation
import XCTest

class LoginTests: XCTestCase {
    var app : XCUIApplication!
    let beeper: Beeper = DarwinNotificationCenterBeeper()
    
    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Helpers
    func launch(app: XCUIApplication, useTestingViewModel: Bool = false) {
        app.launchArguments = ["-ui-testing","YES"]
        if useTestingViewModel {
            app.launchArguments += ["-use-testing-view-model","YES"]
        }
        app.launch()
    }
    
    
    
    // MARK: - Tests
    
    func testWelcomePrompt() {
        app = XCUIApplication()
        launch(app, useTestingViewModel: true)
        
        let alert = app.alerts["Welcome"]
        XCTAssertFalse(alert.exists)
        
        beeper.beep(BeeperConstants.TriggerWelcomePrompt)
        waitForElement(alert)
        XCTAssertTrue(alert.exists)
        
        alert.buttons["Close"].tap()
        XCTAssertFalse(alert.exists)
    }
    
}

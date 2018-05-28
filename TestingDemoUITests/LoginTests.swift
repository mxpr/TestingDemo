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
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testWelcomePrompt() {
        launch(usingTestingViewModel: true)
        
        let alert = app.alerts["Welcome"]
        XCTAssertFalse(alert.exists)
        
        beeper.beep(identifier: BeeperConstants.TriggerWelcomePrompt)
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        
        alert.buttons["Close"].tap()
        XCTAssertFalse(alert.exists)
    }
    
    func testLoadingSpinnerDisplayedWhileAuthenticating() {
        launch(usingTestingViewModel: true)
        
        attemptLogin()
  
        // Spinner shopuld appear and fields should be disabled
        XCTAssertTrue(app.staticTexts["Checking Credentials"].exists)
        XCTAssertFalse(usernameTextFiled.isHittable)
        XCTAssertFalse(passwordTextField.isHittable)
        XCTAssertFalse(loginButton.isHittable)
        XCTAssertFalse(signupButton.isHittable)
    }
    
    // MARK: - Helpers
    var usernameTextFiled: XCUIElement {
        return app.textFields["Username"]
    }
    
    var passwordTextField: XCUIElement {
        return app.secureTextFields["Password"]
    }
    
    var loginButton: XCUIElement {
        return app.buttons["Log In"]
    }
    
    var signupButton: XCUIElement {
        return app.buttons["Sign Up"]
    }
    
    func attemptLogin() {
        usernameTextFiled.tap()
        usernameTextFiled.typeText("user")
        
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        loginButton.tap()
    }
    
    func launch(usingTestingViewModel: Bool = false) {
        app.launchArguments = ["-ui-testing", "YES"]
        if usingTestingViewModel {
            app.launchArguments += ["-use-testing-view-model", "YES"]
        }
        app.launch()
    }
}

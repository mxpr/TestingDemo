//
//  LoginViewModelTests.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import XCTest
@testable import TestingDemo

class LoginViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Mocks & Stubs
    
    class InMemoryKeyValueStore: KeyValueStore {
        private var store = [String: Bool]()
        
        func boolForKey(key: String) -> Bool {
            return store[key] ?? false
        }
        
        func setBool(value: Bool, forKey key: String) {
            store[key] = value
        }
    }
    
    // MARK: - Helpers
    
    func verifyEventTriggered(inout event: (() -> Void)?, line: UInt = #line, file: StaticString = #file, when block:() -> Void) {
        
        let e = expectationWithDescription("Event should be triggered")
        event = {
            e.fulfill()
        }
        
        
        block()
        
        waitForExpectationsWithTimeout(1) { (error) in
            if let _ = error {
                XCTFail("Event was not triggered", line: line, file: file)
            }
        }
        
        // Clean up
        event = nil
    }
    
    func verifyEventNotTriggered(inout event: (() -> Void)?, line: UInt = #line, file: StaticString = #file, when block:() -> Void) {
        
        event = {
            XCTFail("Event should not be triggered", line: line, file: file)
        }
        
        block()
        
        // Clean up
        event = nil
    }
    
    // MARK: - Tests
    
    func testWelcomePrompt() {
        
        let store = InMemoryKeyValueStore()
        let viewModel = DefaultLoginViewModel(keyValueStore: store)
        
        // Should be triggered only the first time
        verifyEventTriggered(&viewModel.showWelcomePrompt) { 
            viewModel.wakeup()
        }
        
        // Subsequent calls should not trigger the welcome prompt
        verifyEventNotTriggered(&viewModel.showWelcomePrompt) {
            viewModel.wakeup()
        }
        
        // Even when creating new instances subsequently 
        let anotherViewModel = DefaultLoginViewModel(keyValueStore: store)
        
        verifyEventNotTriggered(&anotherViewModel.showWelcomePrompt) {
            viewModel.wakeup()
        }
    }
    
}

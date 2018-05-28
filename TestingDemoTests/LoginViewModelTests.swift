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
    var store: InMemoryKeyValueStore!
    var subject: DefaultLoginViewModel!
    
    override func setUp() {
        super.setUp()
        store = InMemoryKeyValueStore()
        subject = createViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Mocks & Stubs
    
    class InMemoryKeyValueStore: KeyValueStore {
        private var store = [String: Bool]()
        
        func bool(forKey key: String) -> Bool {
            return store[key] ?? false
        }
        
        func set(_ value: Bool, forKey key: String) {
            store[key] = value
        }
        
    }
    
    // MARK: - Tests
    
    func testWelcomePrompt() {
        // Should be triggered only the first time
        verifyShowWelcomePromptTriggered {
            subject.wakeup()
        }
        
        // Subsequent calls should not trigger the welcome prompt
        verifyShowWelcomePromptNotTriggered {
            subject.wakeup()
        }
        
        // Even when creating new instances subsequently 
        let anotherViewModel = createViewModel()
        
        verifyShowWelcomePromptNotTriggered {
            anotherViewModel.wakeup()
        }
    }
    
    // MARK: - Helpers
    
    func createViewModel() -> DefaultLoginViewModel {
        let viewModel = DefaultLoginViewModel(keyValueStore: store)
        return viewModel
    }
    
    func verifyShowWelcomePromptTriggered(file: StaticString = #file, line: UInt = #line, when block:() -> Void) {
        let e = expectation(description: "Event should be triggered")
        subject.showWelcomePrompt = {
            e.fulfill()
        }
        
        
        block()
        
        waitForExpectations(timeout: 1) { (error) in
            if let _ = error {
                XCTFail("Event was not triggered", file: file, line: line)
            }
        }
        
        // Clean up
        subject.showWelcomePrompt = nil
    }
    
    func verifyShowWelcomePromptNotTriggered(file: StaticString = #file, line: UInt = #line, when block:() -> Void) {
        subject.showWelcomePrompt = {
            XCTFail("Event should not be triggered", file: file, line: line)
        }
        
        block()
        
        // Clean up
        subject.showWelcomePrompt = nil
    }
    
}

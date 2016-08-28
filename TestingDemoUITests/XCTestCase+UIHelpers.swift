//
//  XCTestCase+UIHelpers.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    
    /// Waits for the specified element to exist and appear on screen
    func waitForElement(element: XCUIElement, line: UInt = #line, file: StaticString = #file) {
        expectationForPredicate(
            NSPredicate(format: "exists == 1 && hittable == 1"),
            evaluatedWithObject: element,
            handler: nil)
        
        waitForExpectationsWithTimeout(2) { error in
            if let _ = error {
                XCTFail("Could not detect element \(element)", line: line, file: file)
            }
        }
    }
}

//
//  XCTestCase.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 17.01.2024.
//

import Foundation
import XCTest

extension XCTestCase {
	/// Use this method from the local scope of test function. Using it from tearDown() could lead into unwanted results.
	func trackForMemoryLeaks(object: AnyObject, file: StaticString = #file, line: UInt = #line) {
		addTeardownBlock { [weak object] in
			XCTAssertNil(object, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
		}
	}
}

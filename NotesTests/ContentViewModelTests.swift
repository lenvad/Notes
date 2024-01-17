//
//  ContentViewModelTests.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 11.01.2024.
//

import CoreData
import XCTest
@testable import Notes

final class ContentViewModelTests: XCTestCase {
	func test_signIn_with_existingUsername_rightPassword() {
		let viewModel = makeSut()
		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "Aa111111"

		viewModel.onScreenEvent(.signIn)

		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertTrue(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "")
	}
	
	func test_signIn_with_existingUsername_falsePassword() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}
	
	func test_signIn_with_notExistingUsername_rightPassword() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser1"
		viewModel.passwordInput = "Aa111111"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}
	
	func test_signIn_with_notExistingUsername_falsePassword() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser1"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.signIn)

		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}

	private func makeSut() -> ContentViewModel {
		let sut = ContentViewModel()

		// track for memory leak
		trackForMemoryLeaks(object: sut)

		return sut
	}
}

extension XCTestCase {
	/// Use this method from the local scope of test function. Using it from tearDown() could lead into unwanted results.
	func trackForMemoryLeaks(object: AnyObject, file: StaticString = #file, line: UInt = #line) {
		addTeardownBlock { [weak object] in
			XCTAssertNil(object, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
		}
	}
}

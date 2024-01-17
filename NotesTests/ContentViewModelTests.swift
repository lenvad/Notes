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
		let sut = ContentViewModel(persistenceController: PersistenceController())

		// track for memory leak
		trackForMemoryLeaks(object: sut)

		return sut
	}
}

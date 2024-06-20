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
	func test_signIn_withExistingUsernameandRightPassword() { //memory leak, but the error is on line 122 
		let viewModel = makeSut()
		
		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "Aa111111"

		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertEqual(viewModel.validCode, "")
		
		viewModel.onScreenEvent(.generateCode)

		XCTAssertTrue(viewModel.shouldCodeBeSended)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertNotEqual(viewModel.validCode, "")
	}
	
	func test_signIn_withExistingUsernameAndfalsePassword() {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "1234"
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertEqual(viewModel.validCode, "")
		
		viewModel.onScreenEvent(.generateCode)
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
		XCTAssertEqual(viewModel.validCode, "")

	}
	
	func test_signIn_withNotExistingUsernameAndRightPassword() {
		let viewModel = makeSut()

		viewModel.usernameInput = "NotExixtingTestUser"
		viewModel.passwordInput = "Aa111111"
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertEqual(viewModel.validCode, "")
		
		viewModel.onScreenEvent(.generateCode)
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
		XCTAssertEqual(viewModel.validCode, "")
	}
	
	func test_generateCode_withNotExistingUsernameAndFalsePassword() {
		let viewModel = makeSut()

		viewModel.usernameInput = "NotExixtingTestUser"
		viewModel.passwordInput = "1234"
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertEqual(viewModel.validCode, "")

		viewModel.onScreenEvent(.generateCode)
		
		XCTAssertFalse(viewModel.shouldCodeBeSended)
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
		XCTAssertEqual(viewModel.validCode, "")
	}
	
	func test_signIn_withRightCode() {
		let viewModel = makeSut()

		
		let code = viewModel.generateCodeNumber()
		
		viewModel.onScreenEvent(.signIn)
		XCTAssertTrue(viewModel.isLinkActive)
	}
	
	func test_signIn_withWrongCode() {
		let viewModel = makeSut()

		
		let code = "000000" //wrong code
		
		viewModel.onScreenEvent(.signIn)
		XCTAssertTrue(viewModel.isLinkActive)
	}

	private func makeSut() -> ContentViewModel {
		let sut = ContentViewModel(persistenceController: PersistenceController())

		// track for memory leak
		trackForMemoryLeaks(object: sut)

		return sut
	}
}

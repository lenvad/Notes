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
	private var viewModel = ContentViewModel()
	private var persistenceController = PersistenceController()
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testExample() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		// Any test you write for XCTest can be annotated as throws and async.
		// Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
		// Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
	func test_signIn_with_existingUsername_rightPassword() throws {
		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "Aa111111"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertTrue(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "")
	}
	
	func test_signIn_with_existingUsername_falsePassword() throws {
		viewModel.usernameInput = "TestUser"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}
	
	func test_signIn_with_notExistingUsername_rightPassword() throws {
		viewModel.usernameInput = "TestUser1"
		viewModel.passwordInput = "Aa111111"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}
	
	func test_signIn_with_notExistingUsername_falsePassword() throws {
		viewModel.usernameInput = "TestUser1"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.signIn)
		
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertFalse(viewModel.isLinkActive)
		XCTAssertEqual(viewModel.errorMessage, "no such user found or your password is wrong")
	}

}

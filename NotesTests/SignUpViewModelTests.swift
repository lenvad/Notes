//
//  SignUpViewModelTests.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 11.01.2024.
//

import XCTest
@testable import Notes

final class SignUpViewModelTests: XCTestCase {
	private var viewModel = SignUpViewModel()
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
    func addUserWhenButtonClicked_with_rightPasswordValidation_and_uniqueUsername() throws {
		viewModel.usernameInput = "Test"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "Aa111111"
		viewModel.onScreenEvent(.addUserWhenButtonClicked)
		
		
		
		XCTAssertTrue(viewModel.isUserAdded)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
    }

}

//
//  SignUpViewModelTests.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 11.01.2024.
//
import CoreData
import XCTest
@testable import Notes

final class SignUpViewModelTests: XCTestCase {
    func test_addUserWhenButtonClicked_with_rightPasswordValidation_and_uniqueUsername() throws {
		let viewModel = makeSut()
		
		//viewModel.userDataManager.deleteUser(user: viewModel.userDataManager.fetchUsersByUsername("TestUser")!)
		
		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "Aa111111"
		
		viewModel.onScreenEvent(.addUserWhenButtonClicked)
		
		let newUser = viewModel.userDataManager.fetchUsersByUsernameAndPassword(
			username: viewModel.usernameInput,
			password: viewModel.passwordInput
		)

		XCTAssertTrue(viewModel.isUserAdded)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertNotNil(newUser)
		XCTAssertEqual(viewModel.errorMessage, "")
    }

	func test_addUserWhenButtonClicked_with_falsePasswordValidation_and_notUniqueUsername() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.addUserWhenButtonClicked)
		
		let newUser = viewModel.userDataManager.fetchUsersByUsernameAndPassword(
			username: viewModel.usernameInput,
			password: viewModel.passwordInput
		)
		
		XCTAssertFalse(viewModel.isUserAdded)
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertNil(newUser)
		XCTAssertEqual(viewModel.errorMessage, "username already token\ninvalid password please use at least:\n- one upper case letter\n- one lower case letter\n- one digit\n- 8 characters")
	}

	func test_addUserWhenButtonClicked_with_falsePasswordValidation_and_uniqueUsername() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser1"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "1234"
		
		viewModel.onScreenEvent(.addUserWhenButtonClicked)
		
		let newUser = viewModel.userDataManager.fetchUsersByUsernameAndPassword(
			username: viewModel.usernameInput,
			password: viewModel.passwordInput
		)
		
		XCTAssertFalse(viewModel.isUserAdded)
		XCTAssertTrue(viewModel.passwordInvalid)
		XCTAssertFalse(viewModel.usernameInvalid)
		XCTAssertNil(newUser)
		XCTAssertEqual(viewModel.errorMessage, "invalid password please use at least:\n- one upper case letter\n- one lower case letter\n- one digit\n- 8 characters")
	}

	func test_addUserWhenButtonClicked_with_rightPasswordValidation_and_notUniqueUsername() throws {
		let viewModel = makeSut()

		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "aA123456"
		
		viewModel.onScreenEvent(.addUserWhenButtonClicked)
		
		let newUser = viewModel.userDataManager.fetchUsersByUsernameAndPassword(
			username: viewModel.usernameInput,
			password: viewModel.passwordInput
		)
		
		XCTAssertFalse(viewModel.isUserAdded)
		XCTAssertFalse(viewModel.passwordInvalid)
		XCTAssertTrue(viewModel.usernameInvalid)
		XCTAssertNil(newUser)
		XCTAssertEqual(viewModel.errorMessage, "username already token")
	}
	
	private func makeSut() -> SignUpViewModel {
		let sut = SignUpViewModel(persistenceController: PersistenceController())
		
		// track for memory leak
		trackForMemoryLeaks(object: sut)
		
		return sut
	}
}

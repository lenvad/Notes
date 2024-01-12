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
	private var viewModel = SignUpViewModel()
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
	
    func test_addUserWhenButtonClicked_with_rightPasswordValidation_and_uniqueUsername() throws {
		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "Aa111111"
		
		viewModel.persistenceController = persistenceController
		viewModel.userDataManager = UserDataManager(container: viewModel.persistenceController.container, persistenceController: viewModel.persistenceController)
		
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
		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "1234"
		
		viewModel.persistenceController = persistenceController
		viewModel.userDataManager = UserDataManager(container: viewModel.persistenceController.container, persistenceController: viewModel.persistenceController)
		
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
		viewModel.usernameInput = "TestUser1"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "1234"
		
		viewModel.persistenceController = persistenceController
		viewModel.userDataManager = UserDataManager(container: viewModel.persistenceController.container, persistenceController: viewModel.persistenceController)
		
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
		viewModel.usernameInput = "TestUser"
		viewModel.emailInput = "testMail"
		viewModel.passwordInput = "aA123456"
		
		viewModel.persistenceController = persistenceController
		viewModel.userDataManager = UserDataManager(container: viewModel.persistenceController.container, persistenceController: viewModel.persistenceController)
		
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
}

//
//  SignUpViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import Foundation
import SwiftUI

final class SignUpViewModel: ObservableObject {
	enum ScreenEvent {
		case addUserWhenButtonClicked
	}
	
    @Published var usernameInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    @Published var errorMessage: String = ""
    @Published var isUserAdded: Bool = false
	@Published var usernameInvalid = false
	@Published var passwordInvalid = false

    var users: [User] = []
    var min: Int32 = 1
    var max: Int32 = 1000
	
	var persistenceController : PersistenceController
	var userDataManager: UserDataManager
	
	init() {
		self.persistenceController = PersistenceController.shared
		self.userDataManager = UserDataManager(persistenceController: persistenceController)
		fetchAllUsers()
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .addUserWhenButtonClicked:
				addUser()
		}
	}
	
    func addUser() {
		switch(uniqueUsernameChecker(),passwordChecker()) {
		case (true, true):
			userDataManager.createUser(username: usernameInput,
									   email: emailInput,
									   password: passwordInput,
									   id: generateRandomNumber(min: min, max: max))
			errorMessage = ""
			isUserAdded = true
			usernameInvalid = false
			passwordInvalid = false
		case (false, false):
			errorMessage = 	"""
							username already token
							invalid password please use at least:
							- one upper case letter
							- one lower case letter
							- one digit
							- 8 characters
							"""
			usernameInvalid = true
			passwordInvalid = true
		case (true, false):
			errorMessage = 	"""
							invalid password please use at least:
							- one upper case letter
							- one lower case letter
							- one digit
							- 8 characters
							"""
			passwordInvalid = true
			usernameInvalid = false
		case (false, true):
			errorMessage = "username already token"
			usernameInvalid = true
			passwordInvalid = false
		}

    }
    
	func passwordChecker() -> Bool {
		if(passwordInput.range(of: "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$", options: .regularExpression) == nil) {
			return false
		}
		return true
	}
	
    func uniqueUsernameChecker() -> Bool {
        var allUsernames: [String] = []
		
        fetchAllUsers()
        
        for user in users {
            allUsernames.append(user.username) 
			print(user.username)
        }
        
        if !allUsernames.contains(usernameInput) {
            return true
        }

        return false
    }
	
    func generateRandomNumber(min: Int32, max: Int32) -> Int32 {
        var idNumbers: [Int] = []
        var num: Int32
        
        fetchAllUsers()
		
        for user in users {
            idNumbers.append(Int(user.id))
        }
        
        repeat {
            num = Int32.random(in: min..<max)
        } while idNumbers.contains(Int(num))
        
        return num
    }
    
    func fetchAllUsers() {
        users = userDataManager.fetchAllUsers()
    }
}

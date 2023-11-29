//
//  SignUpViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    @Published var errorMessage: String = ""
    @Published var isUserAdded: Bool = false
<<<<<<< HEAD:Notes/SignUpViewModel.swift
	@Published var usernameInvalid = false
	@Published var passwordInvalid = false

=======
    
	let footnoteFont = Font.system(.footnote, design: .monospaced)
	
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/ViewModels/SignUpViewModel.swift
    var users: [User] = []
    var min: Int32 = 1
    var max: Int32 = 1000
        
    init() {
        isUserAdded = false
        fetchAllUsers()
    }
    
	enum ScreenEvent {
		case addUserWhenButtonClicked
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .addUserWhenButtonClicked:
				addUser()
		}
	}
	
    func addUser() {
<<<<<<< HEAD:Notes/SignUpViewModel.swift
        if(uniqueUsernameChecker() && passwordChecker()) {
			PersistenceController.shared.createUser(username: usernameInput,
=======
        if(uniqueUsernameChecker()) {
            let user = PersistenceController.shared.createUser(username: usernameInput,
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/ViewModels/SignUpViewModel.swift
                                                     email: emailInput,
                                                     password: passwordInput,
                                                     id: generateRandomNumber(min: min, max: max))
            errorMessage = ""
            isUserAdded = true
			usernameInvalid = false
			passwordInvalid = false
		}
		else if (!uniqueUsernameChecker() && !passwordChecker()) {
			errorMessage = 	"""
 username already token
 email invalid
 invalid password please use at least:
  - one upper case letter
  - one lower case letter
  - one digit
 """
			usernameInvalid = true
			passwordInvalid = true
		}
		else if (!uniqueUsernameChecker() && !passwordChecker()) {
			errorMessage = 	"""
 username already token
 invalid password please use at least:
  - one upper case letter
  - one lower case letter
  - one digit
 """
			usernameInvalid = true
			passwordInvalid = true
		}
		else if (!uniqueUsernameChecker()){
			errorMessage = "username already token"
			usernameInvalid = true
			passwordInvalid = false
		}
		else if(!passwordChecker()) {
			errorMessage = 	"""
 invalid password please use at least:
  - one upper case letter
  - one lower case letter
  - one digit
 """
			passwordInvalid = true
			usernameInvalid = false
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
        }
        
        if(!allUsernames.contains(usernameInput)) {
            return true
        }

        return false
    }
	
    func generateRandomNumber(min: Int32, max: Int32) -> Int32 {
        var idNumbers: [Int] = []
        var num: Int32
        
        fetchAllUsers()
        
        for (user) in users {
            idNumbers.append(Int(user.id))
        }
        
        repeat {
            num = Int32.random(in: min..<max)
        } while idNumbers.contains(Int(num))
        
        return num
    }
    
    func fetchAllUsers() {
        users = PersistenceController.shared.fetchAllUsers()
    }
}

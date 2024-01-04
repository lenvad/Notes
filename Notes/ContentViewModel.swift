//
//  ContentViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var errorMessage = ""
    @Published var usernameInvalid = false
    @Published var passwordInvalid = false
    @Published var isLinkActive = false
        
	enum ScreenEvent {
		case signIn
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .signIn:
				valiateInput()
		}
	}
	
    func valiateInput() {
        let user = fetchUserByUsername(inputUsername: usernameInput)
		
        if user != nil && user?.password == passwordInput {
            isLinkActive = true
            errorMessage = ""
			usernameInvalid = false
			passwordInvalid = false
        }
		else if user?.password != passwordInput && user != nil {
			errorMessage = "password is wrong"
			usernameInvalid = false
			passwordInvalid = true
		}
		else {
			errorMessage = "no such user found"
			usernameInvalid = true
			passwordInvalid = false
			
		}
    }
    
    private func fetchUserByUsername(inputUsername: String) -> User? {
		let user = PersistenceController.shared.fetchUsersByUsername(username: usernameInput)
        return user
    }
    
}

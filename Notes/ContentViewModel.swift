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
        let user = PersistenceController.shared.fetchUsersByUsernameAndPassword(username: usernameInput, password: passwordInput)
		
        if user != nil {
            isLinkActive = true
            errorMessage = ""
			usernameInvalid = false
			passwordInvalid = false
        }
		else {
			errorMessage = "no such user found or your password is wrong"
			usernameInvalid = true
			passwordInvalid = true
		}
    }
}
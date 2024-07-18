//
//  ContentViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
	enum ScreenEvent {
		case signIn
		case generateCode
	}
	
	@Published var usernameInput: String = ""
	@Published var codeInput: String = ""
	@Published var passwordInput: String = ""
	@Published var errorMessage = ""
	@Published var errorMessageMFAView = ""
	@Published var usernameInvalid = false
	@Published var passwordInvalid = false
	@Published var isLinkActive = false
	@Published var shouldCodeBeSended = false
	var isCodegenerated = false
	var validCode : String = ""
	
	private let userDataManager: UserDataManager
	
	init(persistenceController: PersistenceController) {
		self.userDataManager = UserDataManager(persistenceController: persistenceController)
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .signIn:
				compairUserInputAndGeneratedCode()
			case .generateCode:
				valiateInput()
				if shouldCodeBeSended {
					validCode = generateCodeNumber()
					sendCode()
					Timer.scheduledTimer(withTimeInterval: 300.0, repeats: !isLinkActive) { [weak self] _ in
						self?.validCode = self?.generateCodeNumber() ?? ""
						self?.sendCode()
					}
				}
		}
	}
	
	func generateCodeNumber() -> String {
		var num = ""
		for _ in 0...5 {
			num += "\(Int.random(in: 0..<10))"
		}
		
		return num
	}
	
	func sendCode() {
		print("Generated Code: " + validCode)
	}
	
	func compairUserInputAndGeneratedCode() {
		if validCode == codeInput {
			isLinkActive = true
			errorMessageMFAView = ""
		} else {
			errorMessageMFAView = "Not correct code, please enter again."
		}
	}
	
	func valiateInput() {
		let user = userDataManager.fetchUsersByUsernameAndPassword(username: usernameInput, password: passwordInput)
		
		if user != nil {
			shouldCodeBeSended = true
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

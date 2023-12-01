//
//  UserSystemViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//

import Foundation

final class UserSystemViewModel: ObservableObject {
	@Published var usernameInput: String = ""
	@Published var passwordInput: String = ""
	@Published var emailInput: String = ""
}

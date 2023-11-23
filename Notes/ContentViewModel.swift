//
//  ContentViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var errorMessage = ""
    @Published var isLinkActive = false
    
    let footnoteFont = Font.system(.footnote, design: .monospaced)
    //let presistenceController = PersistenceController()
    
    func usernameEqualToInput() {
        let user = fetchUserByUsername(inputUsername: usernameInput)
        if(user != nil && user?.password == passwordInput) {
            isLinkActive = true
            errorMessage = ""
        }
        else {
            errorMessage = "no such user found"
        }
    }
    
    func fetchUserByUsername(inputUsername: String) -> User? {
		let user = PersistenceController.shared.fetchUsersByUsername(username: usernameInput)
        return user
    }
    
}

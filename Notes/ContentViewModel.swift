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
    @Published var errorMessage = ""
    @Published var isLinkActive = false
    
    let footnoteFont = Font.system(.footnote, design: .monospaced)
    
    func usernameEqualToInput() {
        let user = fetchUserByUsername(inputUsername: usernameInput)
        if(!user.isEmpty) {
            isLinkActive = true
            errorMessage = ""
        }
        else {
            errorMessage = "not such user found"
        }
    }
    
    func fetchUserByUsername(inputUsername: String) -> [User] {
        let user = DataManager.shared.fetchUsersByUsername(username: inputUsername)
        return user
    }
    
}

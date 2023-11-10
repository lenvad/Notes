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
    @Published var errorMessage: String = ""
    @Published var isUserAdded: Bool = false
    
    var loggedinUser: User = User()
    let footnoteFont = Font.system(.footnote, design: .monospaced)
    var users: [User] = []
    var min: Int32 = 1
    var max: Int32 = 1000
        
    init() {
        isUserAdded = false
        fetchAllUsers()
    }
    
    func addUser() {
        if(uniqueUsernameChecker()) {
            let user = DataManager.shared.createUser(username: usernameInput,
                                                     email: emailInput,
                                                     id: generateRandomNumber(min: min, max: max))
            DataManager.shared.save()
            loggedinUser = user
            errorMessage = ""
            isUserAdded = true
        } else {
            errorMessage = "username already token"
        }
    }
    
    func uniqueUsernameChecker() -> Bool {
        var allUsernames: [String] = []
        var username: String
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
        var idNumbers: [Int32] = []
        var num: Int32
        
        fetchAllUsers()
        
        for (user) in users {
            idNumbers.append(user.id)
        }
        
        repeat {
            num = Int32.random(in: min..<max)
        } while (!idNumbers.contains(num))
        
        return num
    }
    
    func fetchAllUsers() {
        users = DataManager.shared.fetchAllUsers()
    }
}

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
        print(1)
        if(uniqueUsernameChecker()) {
            let user = DataManager.shared.createUser(username: usernameInput,
                                                     email: emailInput,
                                                     password: passwordInput,
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
        fetchAllUsers()
        
        for user in users {
            allUsernames.append(user.username!)
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
        users = DataManager.shared.fetchAllUsers()
    }
}

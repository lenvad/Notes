//
//  ContentViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var allNotesOfUser: [Note] = []
    @Published var users: [User] = []
    @Published var usernameInput: String = ""
    @Published var errorMessage = ""
    @Published var isLinkActive = false
    
    
    let footnoteFont = Font.system(.footnote, design: .monospaced)
    
    init() {
        fetchAllUser()
        var notes = fetchAllNotes()
        
        for(note) in notes {
            print("note: \(note.user?.username)")
        }
    }
    
    func usernameEqualToInput() {
        fetchAllUser()
        for(user) in users {
            if(usernameInput == user.username) {
                isLinkActive = true
                errorMessage = ""
            }
        }
        
        if(!isLinkActive) {
            errorMessage = "not such user found"
        }
    }
    
    func fetchAllUser() {
        users = DataManager.shared.fetchAllUsers()
    }
    
    func addUser(username: String, email: String, id: Int32) {
        let user = DataManager.shared.createUser(username: username, email: email, id: id)
        print(user.username ?? "not work")
        DataManager.shared.save()
    }
    
    func addNote(inputTitle: String, inputContaint: String, inputTimestamp: Date, inputId: Int32, inputUser: User) {
        let note = DataManager.shared.createNote(title: inputTitle, containt: inputContaint, timestamp: inputTimestamp, id: inputId, user: inputUser)
        print(note.containt ?? "not work")
        DataManager.shared.save()
    }
    
    func fetchUserByUsername(inputUsername: String) -> [User] {
        let user = DataManager.shared.fetchUsersByUsername(username: inputUsername)
        return user
    }
    
    func fetchAllNotes() -> [Note] {
        let notes = DataManager.shared.fetchAllNotes()
        return notes
    }
    
    func fetchNotes(inputUser: User) -> [Note] {
        let notes = DataManager.shared.fetchNotes(user: inputUser)
        return notes
    }
    
    func deleteNote(inputNote: Note) {
        DataManager.shared.deleteNote(note: inputNote)
    }
    
    func deleteUser(inputUser: User) {
        DataManager.shared.deleteUser(user: inputUser)
        print("deleted")
    }
}

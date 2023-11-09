//
//  ContentViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var allNotesOfUser: [Note] = []
    @Published var users: [User] = []
    
    
    
    func addUser(username: String, email: String, id: Int32) {
        let user = DataManager.shared.createUser(username: username, email: email, id: id)
        users.append(user)
        print(user.username ?? "not work")
        DataManager.shared.save()
    }
    
    func addNote(inputTitle: String, inputContaint: String, inputTimestamp: Date, inputId: Int32, inputUser: User) {
        let note = DataManager.shared.createNote(title: inputTitle, containt: inputContaint, timestamp: inputTimestamp, id: inputId, user: inputUser)
        allNotesOfUser.append(note)
        print(note.containt ?? "not work")
        DataManager.shared.save()
    }
    
    func fetchUser(inputUsername: String) -> [User] {
        let user = DataManager.shared.fetchUsers(username: inputUsername)
        return user
    }
    
    func fetchNotes(inputUser: User) -> [Note] {
        let notes = DataManager.shared.fetchNotes(user: inputUser)
        return notes
    }
}

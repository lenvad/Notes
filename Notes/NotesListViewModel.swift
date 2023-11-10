//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation

class NotesListViewModel: ObservableObject {
    @Published var allNotesOfUser: [Note] = []
    @Published var users: [User] = []
    
    func fetchAllUser() {
        users = DataManager.shared.fetchAllUsers()
    }
    
    func addNote(inputTitle: String, inputContaint: String, inputTimestamp: Date, inputId: Int32, inputUser: User) {
        let note = DataManager.shared.createNote(title: inputTitle, containt: inputContaint, timestamp: inputTimestamp, id: inputId, user: inputUser)
        DataManager.shared.save()
    }
    
    func fetchUserByUsername(inputUsername: String) -> User? {
        let user = DataManager.shared.fetchUsersByUsername(username: inputUsername)
        return user
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

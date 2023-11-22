//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation

class NotesListViewModel: ObservableObject {
    @Published var allNotesFromUser: [Note] = []
    @Published var user: User = User()
    let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
    
    func onAppearance(inputUsername: String) {
        user = fetchUserByUsername(inputUsername: inputUsername)!
        fetchNotes(inputUser: user)
    }
    
    func fetchUserByUsername(inputUsername: String) -> User? {
        let user = DataManager.shared.fetchUsersByUsername(username: inputUsername)
        return user
    }
    
    func fetchNotes(inputUser: User) {
        let notes = DataManager.shared.fetchNotesByUser(user: inputUser)
        allNotesFromUser = notes
    }
    
    func deleteNote(inputNote: Note) {
        DataManager.shared.deleteNote(note: inputNote)
    }
    
    func deleteUser(inputUser: User) {
        DataManager.shared.deleteUser(user: inputUser)
        print("deleted")
    }
}

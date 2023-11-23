//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation

class NotesListViewModel: ObservableObject {
    @Published var allNotesFromUser: [Note] = []
    let dateFormatter: DateFormatter
	//let presistenceController = PersistenceController()
	
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
    /*
    func onAppearanceOrRefresh(inputUsername: String) {
        let user = fetchUserByUsername(inputUsername: inputUsername)
        fetchNotes(inputUser: user)
    }
    
    func fetchUserByUsername(inputUsername: String) -> User {
        let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)!
        return user
    }
    
    func fetchNotes(inputUser: User) {
        let notes = PersistenceController.shared.fetchNotesByUser(user: inputUser)
        allNotesFromUser = notes
    }
    */
    func deleteNote(inputNote: Note) {
		PersistenceController.shared.deleteNote(note: inputNote)
    }
    
    func deleteUser(inputUser: User) {
		PersistenceController.shared.deleteUser(user: inputUser)
        print("deleted")
    }
}

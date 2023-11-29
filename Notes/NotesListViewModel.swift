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
	
	enum ScreenEvent {
		case deleteNoteWhenSwipe(note: Note)
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .deleteNoteWhenSwipe(let note):
				deleteNote(inputNote: note)
		}
	}

    func deleteNote(inputNote: Note) {
		PersistenceController.shared.deleteNote(note: inputNote)
    }
    
    func deleteUser(inputUser: User) {
		PersistenceController.shared.deleteUser(user: inputUser)
        print("deleted")
    }
}

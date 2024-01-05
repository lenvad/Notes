//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation
import SwiftUI

final class NotesListViewModel: ObservableObject {
    let dateFormatter: DateFormatter
	var username: String
	@FetchRequest var notesList: FetchedResults<Note>
	
	enum ScreenEvent {
		case onAppear
		case deleteNoteWhenSwipe(note: Note)
	}
	
	init(username: String) {
		self.username = username
		_notesList = FetchRequest(entity: Note.entity(), sortDescriptors: [], predicate: NSPredicate(format: "user.username = %@", username))

        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
		case .deleteNoteWhenSwipe(let note):
			deleteNote(inputNote: note)
		case .onAppear:
			_notesList = FetchRequest(entity: Note.entity(), sortDescriptors: [], predicate: NSPredicate(format: "user.username = %@", username))
		}
	}
	


    func deleteNote(inputNote: Note) {
		PersistenceController.shared.deleteNote(note: inputNote)
    }
}

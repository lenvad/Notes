//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation
import SwiftUI
import CoreData

final class NotesListViewModel: ObservableObject {
	enum ScreenEvent {
		case deleteNoteWhenSwipe(note: Note)
	}
	
    let dateFormatter: DateFormatter
	var username: String
	
	private var persistenceController : PersistenceController
	private var noteDataManager: NoteDataManager
	
	
	init(username: String) {
		self.persistenceController = PersistenceController.shared
		self.noteDataManager = NoteDataManager(container: persistenceController.container, persistenceController: persistenceController)
		
		self.username = username
		
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
		case .deleteNoteWhenSwipe(let note):
			deleteNote(inputNote: note)
		}
	}
	
    func deleteNote(inputNote: Note) {
		noteDataManager.deleteNote(note: inputNote)
    }
}

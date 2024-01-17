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
	let username: String
	
	private var noteDataManager: NoteDataManager
	
	init(username: String, persistenceController: PersistenceController) {
		self.noteDataManager = NoteDataManager(persistenceController: persistenceController)
		
		self.username = username
		
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
		case .deleteNoteWhenSwipe(let note):
			noteDataManager.deleteNote(note)
		}
	}
}

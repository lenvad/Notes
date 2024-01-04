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
	
	enum ScreenEvent {
		case deleteNoteWhenSwipe(note: Note)
	}
	
    init() {
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
		PersistenceController.shared.deleteNote(note: inputNote)
    }
}

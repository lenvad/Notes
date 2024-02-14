//
//  NoteDataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 12.01.2024.
//

import Foundation
import CoreData

struct NoteDataManager {
	private let persistenceController: PersistenceController
	var dbContext: NSManagedObjectContext {
		persistenceController.container.viewContext
	}

	init(persistenceController: PersistenceController) {
		self.persistenceController = persistenceController
	}
	
	func fetchAllNotes() -> [Note] {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		let fetchedNotes: [Note]
		do {
			fetchedNotes = try dbContext.fetch(request)
		} catch let error {
			print("Error fetching singers \(error)")
			fetchedNotes = []
		}
		return fetchedNotes
	}
	
	func fetchNotesById(id: Int32) -> Note? {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		request.predicate = NSPredicate(format: "id = %d", id as Int32)
		request.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false)]
		var fetchedNote: Note?
		do {
			fetchedNote = try dbContext.fetch(request).first
		} catch let error {
			print("Error fetching notes \(error)")
		}
		return fetchedNote
	}
	
	func updateOrCreateNote(title: String, modifiedDate: Date, id: Int32, data: Data, user: User) -> Note {
		let note: Note!
		
		let existingNote = fetchNotesById(id: id)

		if let existingNote {
			// here you are updating
			note = existingNote
		} else {
			// here you are inserting
			note = Note(context: dbContext)
		}

		note.id = id
		note.modifiedDate = modifiedDate
		note.title = title
		note.noteData = data
		note.user = user
		user.addToNotes(note)
		
		persistenceController.save()
		
		return note
	}
	
	func deleteNote(_ note: Note?) -> Bool {
		if note == nil {
			return false
		}
		dbContext.delete(note!)
		persistenceController.save()
		return true
	}
}

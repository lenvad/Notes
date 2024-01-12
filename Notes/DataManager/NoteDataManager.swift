//
//  NoteDataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 12.01.2024.
//

import Foundation
import CoreData

struct NoteDataManager {
	private let container: NSPersistentContainer
	private var persistenceController : PersistenceController
	
	init(container: NSPersistentContainer, persistenceController: PersistenceController) {
		self.container = container
		self.persistenceController = persistenceController
	}
	
	
	func createNote(title: String, timestamp: Date, id: Int32, user: User) -> Note {
		let note = Note(context: container.viewContext)
		note.id = id
		note.timestamp = timestamp
		note.title = title
		note.user = user
		user.addToNote(note)
		persistenceController.save(container: container)
		return note
	}
	
	func fetchAllNotes() -> [Note] {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		var fetchedNotes: [Note] = []
		do {
			fetchedNotes = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching singers \(error)")
		}
		return fetchedNotes
	}
	
	func fetchNotesByUser(user: User) -> [Note] {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		request.predicate = NSPredicate(format: "user = %@", user)
		request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		var fetchedNotes: [Note] = []
		do {
			fetchedNotes = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching notes \(error)")
		}
		return fetchedNotes
	}
	
	func fetchNotesById(id: Int32) -> Note? {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		request.predicate = NSPredicate(format: "id = %@", id as Int32)
		request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		var fetchedNote: Note?
		do {
			fetchedNote = try container.viewContext.fetch(request).first
		} catch let error {
			print("Error fetching notes \(error)")
		}
		return fetchedNote
	}
	
	func updateNote(title: String, timestamp: Date, id: Int32, data: Data, user: User) -> Note {
		let context = container.viewContext
		let note: Note!
		
		let fetchNote: NSFetchRequest<Note> = Note.fetchRequest()
		fetchNote.predicate = NSPredicate(format: "id = %i", id)
		
		let results = try? context.fetch(fetchNote)
		
		if results?.count == 0 {
			// here you are inserting
			note = Note(context: context)
		} else {
			// here you are updating
			note = (results?.first)
		}
		note.id = id
		note.timestamp = timestamp
		note.title = title
		note.noteData = data
		note.user = user
		user.addToNote(note)
		
		persistenceController.save(container: container)
		
		return note
	}
	
	func deleteNote(note: Note) {
		let context = container.viewContext
		context.delete(note)
		persistenceController.save(container: container)
	}
}

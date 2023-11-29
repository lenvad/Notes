//
//  Persistence.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
			let newUser = User(context: viewContext)
			newUser.username = "alex"
			newUser.password = "1234"
			newUser.id = 1
			newUser.email = "alex@mail.com"
			
            let newNote = Note(context: viewContext)
            newNote.title = "title"
            newNote.content = "content"
			newNote.timestamp = Date.now
			newNote.id = 1
			newNote.user = newUser
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Notes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
	
	//Core Data Saving support
	func save() {
		let context = container.viewContext
		if context.hasChanges {
			do {
				try context.save()
				
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func createUser(username: String, email: String, password: String, id: Int32) {
		let user = User(context: container.viewContext)
		user.username = username
		user.email = email
		user.id = id
		user.userId = UUID()
		user.password = password
		save()
	}
	
	func createNote(title: String, content: String, timestamp: Date, id: Int32, user: User) -> Note {
		let note = Note(context: container.viewContext)
		note.id = id
		note.timestamp = timestamp
		note.title = title
		note.content = content
		note.user = user
		user.addToNote(note)
		save()
		return note
	}
	
	func fetchAllUsers() -> [User] {
		let request: NSFetchRequest<User> = User.fetchRequest()
		var fetchedUsers: [User] = []
		do {
			fetchedUsers = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching singers \(error)")
		}
		return fetchedUsers
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
	
	func fetchUsersByUsername(username: String) -> User? {
		let request: NSFetchRequest<User> = User.fetchRequest()
		request.predicate = NSPredicate(format: "username = %@", username)
		var fetchedUser: User?
		do {
			fetchedUser = try container.viewContext.fetch(request).first
		} catch let error {
			print("Error fetching users \(error)")
		}
		return fetchedUser
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
	
	
	func updateNote(title: String, content: String, timestamp: Date, id: Int32, user: User) {
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
		note.content = content
		note.user = user
		user.addToNote(note)
		
		save()
	}
	
	func deleteUser(user: User) {
		let context = container.viewContext
		context.delete(user)
		save()
	}
	
	func deleteNote(note: Note) {
		let context = container.viewContext
		context.delete(note)
		save()
	}
}

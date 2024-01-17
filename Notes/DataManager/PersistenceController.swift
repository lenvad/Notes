//
//  PersistenceController.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

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
		if container.viewContext.hasChanges {
			do {
				try container.viewContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}

extension PersistenceController {
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
			newNote.noteData = "content".data(using: .utf8)
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
}
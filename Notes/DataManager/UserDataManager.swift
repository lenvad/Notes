//
//  UserDataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 11.01.2024.
//

import Foundation
import CoreData

struct UserDataManager {
	let container: NSPersistentContainer
	private var persistenceController : PersistenceController
	
	init(inMemory: Bool = false, persistenceController: PersistenceController) {
		self.persistenceController = persistenceController
		
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
	
	func createUser(username: String, email: String, password: String, id: Int32) {
		let user = User(context: container.viewContext)
		user.username = username
		user.email = email
		user.id = id
		user.userId = UUID()
		user.password = password
		persistenceController.save(container: container)
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
	
	func fetchUsersByUsernameAndPassword(username: String, password: String) -> User? {
		let request: NSFetchRequest<User> = User.fetchRequest()
		let predicate1 = NSPredicate(format: "username = %@", username)
		let predicate2 = NSPredicate(format: "password = %@", password)
		let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
		request.predicate = compound
		var fetchedUser: User?
		do {
			fetchedUser = try container.viewContext.fetch(request).first
		} catch let error {
			print("Error fetching users \(error)")
		}
		return fetchedUser
	}
	
	func deleteUser(user: User) {
		let context = container.viewContext
		context.delete(user)
		persistenceController.save(container: container)
	}
}

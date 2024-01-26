//
//  UserDataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 11.01.2024.
//

import Foundation
import CoreData

struct UserDataManager {
	private let persistenceController: PersistenceController
	var dbContext: NSManagedObjectContext {
		persistenceController.container.viewContext
	}

	init(persistenceController: PersistenceController) {
		self.persistenceController = persistenceController
	}
	
	func createUser(username: String, email: String, password: String) {
		let user = User(context: dbContext)
		user.username = username
		user.email = email
		user.password = password
		persistenceController.save()
	}
	
	func fetchAllUsers() -> [User] {
		let request: NSFetchRequest<User> = User.fetchRequest()
		let fetchedUsers: [User]
		do {
			fetchedUsers = try dbContext.fetch(request)
		} catch let error {
			print("Error fetching singers \(error)")
			fetchedUsers = []
		}
		return fetchedUsers
	}
	
	func fetchUsersByUsername(_ username: String) -> User? {
		let request: NSFetchRequest<User> = User.fetchRequest()
		request.predicate = NSPredicate(format: "username = %@", username)
		let fetchedUser: User?
		do {
			fetchedUser = try dbContext.fetch(request).first
		} catch let error {
			print("Error fetching users \(error)")
			fetchedUser = nil
		}
		return fetchedUser
	}
	
	func fetchUsersByUsernameAndPassword(username: String, password: String) -> User? {
		let request: NSFetchRequest<User> = User.fetchRequest()
		let predicateByUsername = NSPredicate(format: "username = %@", username)
		let predicatedByPassword = NSPredicate(format: "password = %@", password)
		let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateByUsername, predicatedByPassword])
		request.predicate = compound
		let fetchedUser: User? = (try? dbContext.fetch(request))?.first
		return fetchedUser
	}
	
	func deleteUser(user: User) {
		dbContext.delete(user)
		persistenceController.save()
	}
}


//
//  UserDataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 11.01.2024.
//

import Foundation
import CoreData

struct UserDataManager {
	private let container: NSPersistentContainer
	private var persistenceController : PersistenceController
	
	init(container: NSPersistentContainer, persistenceController: PersistenceController) {
		self.container = container
		self.persistenceController = persistenceController
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


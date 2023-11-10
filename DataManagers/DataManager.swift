//
//  DataManager.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
    
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Notes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
    
  //Core Data Saving support
  func save () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
          try context.save()
          
      } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
    
    func createUser(username: String, email: String, id: Int32) -> User {
      let user = User(context: persistentContainer.viewContext)
        user.username = username
        user.email = email
        user.id = id
        //save() //if needed, not in the tutorial
      return user
    }
    
    func createNote(title: String, containt: String, timestamp: Date, id: Int32, user: User) -> Note {
      let note = Note(context: persistentContainer.viewContext)
        note.id = id
        note.timestamp = timestamp
        note.title = title
        note.containt = containt
        note.id = id
        note.user = user
        user.addToNote(note)
        //save() //if needed, not in the tutorial
      return note
    }
    
    func fetchAllUsers() -> [User] {
      let request: NSFetchRequest<User> = User.fetchRequest()
      var fetchedUsers: [User] = []
      do {
          fetchedUsers = try persistentContainer.viewContext.fetch(request)
      } catch let error {
         print("Error fetching singers \(error)")
      }
      return fetchedUsers
    }
    
    func fetchAllNotes() -> [Note] {
      let request: NSFetchRequest<Note> = Note.fetchRequest()
      var fetchedNotes: [Note] = []
      do {
          fetchedNotes = try persistentContainer.viewContext.fetch(request)
      } catch let error {
         print("Error fetching singers \(error)")
      }
      return fetchedNotes
    }
    
    func fetchUsersByUsername(username: String) -> User? {
      let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username = %@", username)
      var fetchedUsers: User? = User()
      do {
          fetchedUsers = try persistentContainer.viewContext.fetch(request).first
      } catch let error {
         print("Error fetching users \(error)")
      }
      return fetchedUsers
    }
    
    
    func fetchNotes(user: User) -> [Note] {
      let request: NSFetchRequest<Note> = Note.fetchRequest()
      request.predicate = NSPredicate(format: "user = %@", user)
      request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
      var fetchedNotes: [Note] = []
      do {
          fetchedNotes = try persistentContainer.viewContext.fetch(request)
      } catch let error {
        print("Error fetching notes \(error)")
      }
      return fetchedNotes
    }
    
    func deleteUser(user: User) {
      let context = persistentContainer.viewContext
      context.delete(user)
      save()
    }
    
    func deleteNote(note: Note) {
      let context = persistentContainer.viewContext
      context.delete(note)
      save()
    }
}

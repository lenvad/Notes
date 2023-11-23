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
    
    func createUser(username: String, email: String, password: String, id: Int32) -> User {
      let user = User(context: persistentContainer.viewContext)
        user.username = username
        user.email = email
        user.id = id
        user.password = password
      return user
    }
    
    func createNote(title: String, content: String, timestamp: Date, id: Int32, user: User) -> Note {
      let note = Note(context: persistentContainer.viewContext)
        note.id = id
        note.timestamp = timestamp
        note.title = title
        note.content = content
        note.user = user
        user.addToNote(note)
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
      var fetchedUser: User? = User()
      do {
          fetchedUser = try persistentContainer.viewContext.fetch(request).first
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
          fetchedNotes = try persistentContainer.viewContext.fetch(request)
      } catch let error {
        print("Error fetching notes \(error)")
      }
      return fetchedNotes
    }
    
    func fetchNotesById(id: Int32) -> Note? {
      let request: NSFetchRequest<Note> = Note.fetchRequest()
      request.predicate = NSPredicate(format: "id = %@", id as Int32)
      request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
      var fetchedNote: Note? = Note()
      do {
          fetchedNote = try persistentContainer.viewContext.fetch(request).first
      } catch let error {
        print("Error fetching notes \(error)")
      }
      return fetchedNote
    }

    
    func updateNote(title: String, content: String, timestamp: Date, id: Int32, user: User) {
        let context = persistentContainer.viewContext
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

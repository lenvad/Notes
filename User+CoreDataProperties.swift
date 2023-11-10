//
//  User+CoreDataProperties.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var userId: UUID?
    @NSManaged public var username: String
    @NSManaged public var note: NSOrderedSet?

}

// MARK: Generated accessors for note
extension User {

    @objc(insertObject:inNoteAtIndex:)
    @NSManaged public func insertIntoNote(_ value: Note, at idx: Int)

    @objc(removeObjectFromNoteAtIndex:)
    @NSManaged public func removeFromNote(at idx: Int)

    @objc(insertNote:atIndexes:)
    @NSManaged public func insertIntoNote(_ values: [Note], at indexes: NSIndexSet)

    @objc(removeNoteAtIndexes:)
    @NSManaged public func removeFromNote(at indexes: NSIndexSet)

    @objc(replaceObjectInNoteAtIndex:withObject:)
    @NSManaged public func replaceNote(at idx: Int, with value: Note)

    @objc(replaceNoteAtIndexes:withNote:)
    @NSManaged public func replaceNote(at indexes: NSIndexSet, with values: [Note])

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSOrderedSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSOrderedSet)

}

extension User : Identifiable {

}

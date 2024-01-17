//
//  User+CoreDataProperties.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 17.01.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String
    @NSManaged public var notes: NSOrderedSet?

}

// MARK: Generated accessors for notes
extension User {

    @objc(insertObject:inNotesAtIndex:)
    @NSManaged public func insertIntoNotes(_ value: Note, at idx: Int)

    @objc(removeObjectFromNotesAtIndex:)
    @NSManaged public func removeFromNotes(at idx: Int)

    @objc(insertNotes:atIndexes:)
    @NSManaged public func insertIntoNotes(_ values: [Note], at indexes: NSIndexSet)

    @objc(removeNotesAtIndexes:)
    @NSManaged public func removeFromNotes(at indexes: NSIndexSet)

    @objc(replaceObjectInNotesAtIndex:withObject:)
    @NSManaged public func replaceNotes(at idx: Int, with value: Note)

    @objc(replaceNotesAtIndexes:withNotes:)
    @NSManaged public func replaceNotes(at indexes: NSIndexSet, with values: [Note])

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSOrderedSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSOrderedSet)

}

extension User : Identifiable {

}

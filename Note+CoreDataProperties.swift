//
//  Note+CoreDataProperties.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 17.01.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int32
    @NSManaged public var noteData: Data?
    @NSManaged public var noteId: UUID
    @NSManaged public var modifiedDate: Date
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}

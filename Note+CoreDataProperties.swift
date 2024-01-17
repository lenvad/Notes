//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Lena Vadakkel on 08.12.23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int32 // remove this
    @NSManaged public var noteId: UUID? // TODO: keep that one. Further, it must not be optional
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String?
    @NSManaged public var noteData: Data?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}

//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var containt: String?
    @NSManaged public var id: Int32
    @NSManaged public var noteId: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}

//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Lena Vadakkel on 16.11.23.
//
//

import Foundation
import CoreData
import UIKit
import Combine

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: Int32
    @NSManaged public var noteId: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}


final class NotesCollectionViewCell: UICollectionViewCell {
    let contentLabel = UILabel()
    let titleLabel = UILabel()
    
    private var contentSubscription: AnyCancellable?
    private var titleSubscription: AnyCancellable?
    
    func setup(with note: Note) {
        contentSubscription = note.publisher(for: \.content)
            .assign(to: \.text, on: contentLabel)
        titleSubscription = note.publisher(for: \.title)
            .assign(to: \.text, on: titleLabel)
        
    }
}

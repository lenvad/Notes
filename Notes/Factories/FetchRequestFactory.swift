//
//  FetchRequestFactory.swift
//  Notes
//
//  Created by Duyen-Hoa Ha on 05.01.24.
//

import SwiftUI

final class FetchRequestFactory {
	func makeNotesListFetchRequest(username: String) -> FetchRequest<Note> {
		FetchRequest(
			entity: Note.entity(),
			sortDescriptors: [],
			predicate: NSPredicate(format: "user.username = %@", username)
		)

	}
}

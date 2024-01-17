//
//  NotesListViewModelTests.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 12.01.2024.
//

import CoreData
import XCTest
@testable import Notes

final class NotesListViewModelTests: XCTestCase {
	func test_deleteNote() {
		let viewModel = makeSut()
		let note = viewModel.noteDataManager.fetchNotesById(id: 7)
		
		XCTAssertNotNil(note)

		let notesBeforDelete = viewModel.noteDataManager.fetchAllNotes()
		
		viewModel.onScreenEvent(.deleteNoteWhenSwipe(note: note!))
		
		let notesAfterDelete = viewModel.noteDataManager.fetchAllNotes()
		
		let deletedNote = viewModel.noteDataManager.fetchNotesById(id: 7)
		
		XCTAssertNotEqual(notesBeforDelete, notesAfterDelete)
		XCTAssertNil(deletedNote)
	}
	
	private func makeSut() -> NotesListViewModel {
		let sut = NotesListViewModel(
			username: "TestUser",
			persistenceController: PersistenceController()
		)
		
		// track for memory leak
		trackForMemoryLeaks(object: sut)
		
		return sut
	}
}

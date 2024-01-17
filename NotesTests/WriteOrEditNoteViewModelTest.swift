//
//  WriteOrEditNoteViewModelTest.swift
//  NotesTests
//
//  Created by Lena Vadakkel on 12.01.2024.
//

import CoreData
import XCTest
@testable import Notes

final class WriteOrEditNoteViewModelTest: XCTestCase {
	func test_addNewNote_toUser() throws {
		let viewModel = makeSut()
		
		viewModel.onScreenEvent(.onAppearance)
		XCTAssertFalse(viewModel.contentDisabled)
		
		viewModel.noteText = NSAttributedString(string: "hello world, test input")
		viewModel.onScreenEvent(.addOrUpdateNote)
		
		let note = viewModel.noteDataManager.fetchNotesById(id: (viewModel.note?.id)!)
	}
	
	private func makeSut() -> WriteOrEditNoteViewModel {
		let persistenceController = PersistenceController()
		let sut = WriteOrEditNoteViewModel(
			username: "TestUser", persistenceController: persistenceController,
			note: nil
		)
		
		// track for memory leak
		trackForMemoryLeaks(object: sut)
		
		return sut
	}
}

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
	static var noteId: Int32 = 1
	
	func test_addNewNote_toUser() throws {
		let viewModel = makeSut()
		
		viewModel.onScreenEvent(.onAppearance)
		XCTAssertFalse(viewModel.contentDisabled)
		
		let text = "hello world, test input add note to user\nText Content: blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n"
		viewModel.noteText = NSAttributedString(string: text)
		viewModel.onScreenEvent(.addOrUpdateNote)
		
		let note = viewModel.noteDataManager.fetchNotesById(id: (viewModel.note?.id)!)
		WriteOrEditNoteViewModelTest.noteId = note?.id ?? 1
		
		let noteAsData = try NSKeyedArchiver.archivedData(withRootObject: viewModel.noteText, requiringSecureCoding: false) // noteText is NSAttributedString

		XCTAssertNotNil(note)
		XCTAssertEqual(note?.title, "hello world, test input add note to user")
		XCTAssertEqual(note?.noteData, noteAsData)
	}
	
	func test_updateNote_fromUser() throws {
		let viewModel = makeSut()
		
		viewModel.onScreenEvent(.onAppearance)

		let noteForUpdate = viewModel.noteDataManager.fetchNotesById(id: WriteOrEditNoteViewModelTest.noteId) 
		viewModel.note = noteForUpdate
		
		XCTAssertFalse(viewModel.contentDisabled)
		XCTAssertEqual(viewModel.note?.title, "hello world, test input add note to user")

		let text = "hello world, test input update note to user\nText Content: blalaalabjalbjljlalblablabjalblbjljlalblablabjalbla\nblalaalabjalbjljlalblablabjalbla\n\n\nblalaalabjalbjljlalblablabjalbla\nalblablabjalbla"
		viewModel.noteText = NSAttributedString(string: text)
		viewModel.onScreenEvent(.addOrUpdateNote)
		
		let note = viewModel.noteDataManager.fetchNotesById(id: (viewModel.note?.id)!)
		
		let noteAsData = try NSKeyedArchiver.archivedData(withRootObject: viewModel.noteText, requiringSecureCoding: false) // noteText is NSAttributedString

		XCTAssertNotNil(note)
		XCTAssertEqual(note?.title, "hello world, test input update note to user")
		XCTAssertEqual(note?.noteData, noteAsData)
	}
	
	private func makeSut() -> WriteOrEditNoteViewModel {
		let sut = WriteOrEditNoteViewModel(
			username: "TestUser", persistenceController: PersistenceController(),
			note: nil
		)
		
		// track for memory leak
		trackForMemoryLeaks(object: sut)
		
		return sut
	}
}

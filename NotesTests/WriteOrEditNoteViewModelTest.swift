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
		
		let text = "hello world, test input\nText Content: blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n"
		viewModel.noteText = NSAttributedString(string: "hello world, test input\nText Content: blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n blalaalabjalbjljlalblablabjalbla\n")
		viewModel.onScreenEvent(.addOrUpdateNote)
		
		let note = viewModel.noteDataManager.fetchNotesById(id: (viewModel.note?.id)!)
		print(note?.id)
		
		let noteAsData = try NSKeyedArchiver.archivedData(withRootObject: viewModel.noteText, requiringSecureCoding: false) // noteText is NSAttributedString

		XCTAssertNotNil(note)
		XCTAssertEqual(note?.title, "hello world, test input")
		XCTAssertEqual(note?.noteData, noteAsData)
	}
	
	func test_updateNote_fromUser() throws {
		let viewModel = makeSut()
		
		viewModel.onScreenEvent(.onAppearance)
		XCTAssertFalse(viewModel.contentDisabled)
		
		let noteForUpdate = viewModel.noteDataManager.fetchNotesById(id: 1)
		viewModel.note = noteForUpdate

		let text = "hello world, test input\nText Content: blalaalabjalbjljlalblablabjalblbjljlalblablabjalbla\nblalaalabjalbjljlalblablabjalbla\n\n\nblalaalabjalbjljlalblablabjalbla\nalblablabjalbla"
		viewModel.noteText = NSAttributedString(string: text)
		viewModel.onScreenEvent(.addOrUpdateNote)
		
		let note = viewModel.noteDataManager.fetchNotesById(id: (viewModel.note?.id)!)
		
		let noteAsData = try NSKeyedArchiver.archivedData(withRootObject: viewModel.noteText, requiringSecureCoding: false) // noteText is NSAttributedString

		XCTAssertNotNil(note)
		XCTAssertEqual(note?.title, "hello world, test input")
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

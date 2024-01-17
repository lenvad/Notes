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
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	func test_deleteNote() {
		
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

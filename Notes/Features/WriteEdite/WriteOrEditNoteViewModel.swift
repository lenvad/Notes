//
//  WriteOrEditNoteViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation
import Combine

final class WriteOrEditNoteViewModel: ObservableObject {
	enum ScreenEvent {
		case onAppearance
		case addOrUpdateNote
		case toolbarButtons(event: ToolKinds)
		case fontSizeChanged
	}

	enum ToolKinds {
		case bold
		case italic
		case underlined
		case checklist
	}

	enum Colors: String, CaseIterable {
		case standard
		case green
		case red
		case blue
		case yellow
		case pink
		case purple
		case orange
	}

	@Published var isBold: Bool = false
	@Published var isItalic: Bool = false
	@Published var isUnderlined: Bool = false
	@Published var checklistActivated: Bool = false
	@Published var formattingCurrentlyChanged: Bool = false
	@Published var selectedColor = "standard"
	@Published var selectedRange: NSRange = NSRange(location: 0, length: 0)
	@Published var contentDisabled = true
	@Published var fontSize: Int = 12
	@Published var errorMessage = ""
	//@MainActor @Published var fontSizeDouble: Double = 12.0
	
	var noteText: NSAttributedString = NSAttributedString(string: "")
	let colorList: [String] = Colors.allCases.map { $0.rawValue }
	let fontSizeList: [Int] = [8, 10, 12, 14, 16, 18, 20, 24, 26, 30, 32, 36]

	var counter: Int32 = 0
	var isLinkActive = false
	var username: String
	var note: Note?
	
	private let userDataManager: UserDataManager
	private let noteDataManager: NoteDataManager

	init(username: String, userDataManager: UserDataManager, noteDataManager: NoteDataManager, note: Note? = nil) {
		self.userDataManager = userDataManager
		self.noteDataManager = noteDataManager
		self.username = username
		self.note = note


		DispatchQueue.global(qos: .background).async {
			self.contentDisabled = false
		}
	}
	
	@MainActor func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .onAppearance:
				counter = getBiggestId() ?? 0
				if (note != nil ) {
					decodeAndSetNote()
					contentDisabled = true
				} else {
					contentDisabled = false
				}
			case .addOrUpdateNote:
				let user = fetchUserByUsername(inputUsername: username)
				if (user != nil) {
					addOrUpdateNote(inputUser: user!)
				} else {
					errorMessage = "Error: Please close the app and log in again"
				}
			case .toolbarButtons(let fontEvent):
				toolbarButtons(fontEvent)
			case .fontSizeChanged:
				formattingCurrentlyChanged = true
		}
	}
	
	@MainActor func toolbarButtons(_ event: ToolKinds) {
		switch event {
			case .bold:
				isBold = switchBool(boolValue: &isBold)
			case .italic:
				isItalic = switchBool(boolValue: &isItalic)
			case .underlined:
				isUnderlined = switchBool(boolValue: &isUnderlined)
			case .checklist:
				checklistActivated = switchBool(boolValue: &checklistActivated)
		}
		formattingCurrentlyChanged = true
	}
	
	func switchBool(boolValue: inout Bool) -> Bool {
		if !boolValue {
			return true
		}
		return false
	}
	
	func fetchUserByUsername(inputUsername: String) -> User? {
		let user = userDataManager.fetchUsersByUsername(inputUsername)
		return user
	}
	
	@MainActor func addOrUpdateNote(inputUser: User) {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: noteText, requiringSecureCoding: false) // noteText is NSAttributedString
			
			let inputTitle = noteText.string.components(separatedBy: CharacterSet.newlines).first!
			let inputTimestamp = Date.now
			let inputdata = data
			if(note == nil) {
				counter += 1
			}
			
			note = noteDataManager.updateOrCreateNote(title: inputTitle, timestamp: inputTimestamp, id: note?.id ?? counter, data: inputdata, user: inputUser)

			isLinkActive = true
			
		} catch {
			print("error encoding")
		}
	}
	
	func getBiggestId() -> Int32? {
		let notes: [Note] = noteDataManager.fetchAllNotes()
		let biggestNum = notes.max{ i, j in i.id < j.id }
		return biggestNum?.id
	}

	@MainActor func decodeAndSetNote() {
		do {
			let unarchiver = try NSKeyedUnarchiver(forReadingFrom: note?.noteData ?? Data("error".utf8))
			unarchiver.requiresSecureCoding = false
			let decodedAttributedString = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! NSAttributedString
			
			noteText = decodedAttributedString
			contentDisabled = true
		} catch {
			print("error decoding")
		}
	}
}

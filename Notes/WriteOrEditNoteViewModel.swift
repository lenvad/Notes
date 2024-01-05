//
//  WriteOrEditNoteViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation
import Combine

final class WriteOrEditNoteViewModel: ObservableObject {
	var noteText: NSAttributedString = NSAttributedString(string: "")
	@MainActor @Published var isBold: Bool = false
	@MainActor @Published var isItalic: Bool = false
	@MainActor @Published var isUnderlined: Bool = false
	@MainActor @Published var checklistActivated: Bool = false
	@MainActor @Published var formattingCurrentlyChanged: Bool = false
	@MainActor @Published var selectedColor = "standard"
	@MainActor @Published var fontSizeDouble: Double = 12.0
	
	@Published var errorMessage = ""
	@Published var selectedRange: NSRange = NSRange(location: 0, length: 0)
	@Published var colorList: [String] = ["standard", "red", "blue", "green", "yellow", "pink", "purple", "orange"]
	@Published var contentDisabled = true
	@Published var fontSizeString: String = "12"
	
	var counter: Int32 = 0
	var isLinkActive = false
	var username: String
	var note: Note?
	
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
	
	init(username: String, note: Note? = nil) {
		self.username = username
		self.note = note
	}
	
	@MainActor func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .onAppearance:
				counter = getBiggestId() ?? 0
				if (note != nil ) {
					setNote()
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
				fontSizeStringToDouble()
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
		let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)
		return user
	}
	
	@MainActor func addOrUpdateNote(inputUser: User) {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: noteText, requiringSecureCoding: false) // attributedString is NSAttributedString
			
			let inputTitle = noteText.string.components(separatedBy: CharacterSet.newlines).first!
			let inputTimestamp = Date.now
			let inputdata = data
			if(note == nil) {
				counter += 1
			}
			
			note = PersistenceController.shared.updateNote(title: inputTitle, timestamp: inputTimestamp, id: note?.id ?? counter, data: inputdata, user: inputUser)
			
			isLinkActive = true
			
		} catch {
			print("error encoding")
		}
	}
	
	func getBiggestId() -> Int32? {
		let notes: [Note] = PersistenceController.shared.fetchAllNotes()
		let biggestNum = notes.max{ i, j in i.id < j.id }
		return biggestNum?.id
	}
	
	@MainActor func setNote() {
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
	
	@MainActor func fontSizeStringToDouble() {
		print(fontSizeString)
		if fontSizeString.range(of: "^[0-9.]*$", options: .regularExpression) != nil {
			errorMessage = ""
			fontSizeDouble = Double(fontSizeString) ?? 12
		} else {
			errorMessage = "only numbers allowed"
		}
	}
}

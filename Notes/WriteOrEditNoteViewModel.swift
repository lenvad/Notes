//
//  WriteOrEditNoteViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation
import Combine

final class WriteOrEditNoteViewModel: ObservableObject {
	@Published var errorMessage = ""
	@Published var noteText: NSAttributedString = NSAttributedString(string: "")
	@Published var selectedRange: NSRange = NSRange(location: 0, length: 0)
	@Published var colorList: [String] = ["standard", "red", "blue", "green", "yellow", "pink", "purple", "orange"]
	@Published var selectedColor = "standard"
	@Published var contentDisabled = true
	@Published var isBold: Bool = false
	@Published var isItalic: Bool = false
	@Published var isUnderlined: Bool = false
	@Published var fontSizeString: String = "12"
	
	var fontSizeDouble: Double = 12.0
	var counter: Int32 = 0
	var note: Note? = nil
	var isLinkActive = false
	
	enum ScreenEvent {
		case onAppearance(note: Note?)
		case addOrUpdateNote(inputUsername: String)
		case fontAdjustment(event: FontKind)
		case fontSizeChanged
	}
	
	enum FontKind {
		case bold
		case italic
		case underlined
	}
	
	func onScreenEvent(_ event: ScreenEvent) {
		switch event {
			case .onAppearance(let note):
				counter = getBiggestId() ?? 0
				if (note != nil ) {
					setNote(note)
					contentDisabled = true
				} else {
					contentDisabled = false
				}
			case .addOrUpdateNote(inputUsername: let username):
				let user = fetchUserByUsername(inputUsername: username)
				if (user != nil) {
					addOrUpdateNote(inputUser: user!)
				} else {
					errorMessage = "Error: Please close the app and log in again"
				}
			case .fontAdjustment(let fontEvent):
				fontAdjustment(fontEvent)
			case .fontSizeChanged:
				fontSizeStringToDouble()
		}
	}
	
	func fontAdjustment(_ event: FontKind) {
		switch event {
			case .bold:
				isBold = switchBool(boolValue: &isBold)
			case .italic:
				isItalic = switchBool(boolValue: &isItalic)
			case .underlined:
				isUnderlined = switchBool(boolValue: &isUnderlined)
		}
	}
	
	func switchBool(boolValue: inout Bool) -> Bool {
		if(!boolValue) {
			return true
		}
		return false
	}
	
	func fetchUserByUsername(inputUsername: String) -> User? {
		let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)
		return user
	}
	
	func addOrUpdateNote(inputUser: User) {
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
	
	func setNote(_ note: Note?) {
		do {
			let unarchiver = try NSKeyedUnarchiver(forReadingFrom: note?.noteData ?? Data("error".utf8))
			unarchiver.requiresSecureCoding = false
			let decodedAttributedString = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! NSAttributedString
			
			noteText = decodedAttributedString
			self.note = note
			contentDisabled = true
		} catch {
			print("error decoding")
		}
	}
	
	func fontSizeStringToDouble() {
		print(fontSizeString)
		if (fontSizeString.range(of: "^[0-9.]*$", options: .regularExpression) != nil) {
			errorMessage = ""
			fontSizeDouble = Double(fontSizeString) ?? 12
		} else {
			errorMessage = "only numbers allowed"
		}
	}
}

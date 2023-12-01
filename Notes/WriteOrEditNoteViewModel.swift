//
//  WriteOrEditNoteViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation

final class WriteOrEditNoteViewModel: ObservableObject {
    @Published var contentDisabled = true
    @Published var content = ""
    @Published var errorMessage = ""
	
    var counter: Int32 = 0
    var note: Note? = nil
    var isLinkActive = false
	@Published var isBold: Bool = false
	@Published var isItalic: Bool = false
	var isUnderlined: Bool = false
	
    enum ScreenEvent {
        case onAppearance(note: Note?)
        case addOrUpdateNote(inputUsername: String)
		case fontAdjustment(event: FontKind)
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
					addOrUpdateNote(inputUser: user!) // ! (find a way without it)
				} else {
					errorMessage = "Error: Please close the app and log in again"
				}
			case .fontAdjustment(let fontEvent):
				fontAdjustment(fontEvent)
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
        let inputTitle = content.components(separatedBy: CharacterSet.newlines).first!
        let inputContent = content
        let inputTimestamp = Date.now
        
        if(note == nil) {
            counter += 1
        }
        
		PersistenceController.shared.updateNote(title: inputTitle, content: inputContent, timestamp: inputTimestamp, id: note?.id ?? counter, user: inputUser)
        
        isLinkActive = true
    }
    
    func getBiggestId() -> Int32? {
		let notes: [Note] = PersistenceController.shared.fetchAllNotes()
        let biggestNum = notes.max{ i, j in i.id < j.id }
        return biggestNum?.id
    }
    
    func setNote(_ note: Note?) {
        content = note?.content ?? ""
        self.note = note
        contentDisabled = true
    }
}

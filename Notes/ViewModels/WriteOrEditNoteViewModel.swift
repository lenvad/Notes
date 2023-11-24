//
//  WriteOrEditNoteViewModel.swift
//  Notes
//
//  Created by Lena Vadakkel on 10.11.23.
//

import Foundation

class WriteOrEditNoteViewModel: ObservableObject {
    @Published var contentDisabled = true
    @Published var content = ""
	
	//let PresistenceController = PersistenceController()

    var counter: Int32 = 0
    var note: Note?
    var isLinkActive = false
	
	init() {
		note = nil
	}
    
    enum ScreenEvent {
        case onAppearance(note: Note?)
        case addOrUpdateNote(inputUsername: String)
    }
    
	func fetchUserByUsername(inputUsername: String) -> User {
		let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)!
		return user
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
            addOrUpdateNote(inputUser: fetchUserByUsername(inputUsername: username))
        }
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

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
<<<<<<< HEAD:Notes/WriteOrEditNoteViewModel.swift
    @Published var errorMessage = ""
	
=======
	
	//let PresistenceController = PersistenceController()

>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/ViewModels/WriteOrEditNoteViewModel.swift
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
    
<<<<<<< HEAD:Notes/WriteOrEditNoteViewModel.swift
	func fetchUserByUsername(inputUsername: String) -> User? {
		let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)
=======
	func fetchUserByUsername(inputUsername: String) -> User {
		let user = PersistenceController.shared.fetchUsersByUsername(username: inputUsername)!
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/ViewModels/WriteOrEditNoteViewModel.swift
		return user
	}
	
    func onScreenEvent(_ event: ScreenEvent) {
<<<<<<< HEAD:Notes/WriteOrEditNoteViewModel.swift
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
		}
=======
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
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/ViewModels/WriteOrEditNoteViewModel.swift
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

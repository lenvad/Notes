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
    var counter: Int32 = 0
    var note: Note? = nil
    var user: User = User()
    var isLinkActive = false
    
    enum ScreenEvent {
        case onAppearance(note: Note?, user: User)
        case addOrUpdateNote(inputUser: User)
    }
    
    func onScreenEvent(_ event: ScreenEvent) {
        switch event {
        case .onAppearance(let note, let user):
            counter = getBiggestId() ?? 0
            setUser(user)
            if (note != nil ) {
                setNote(note)
                contentDisabled = true
            } else {
                contentDisabled = false
            }
        case .addOrUpdateNote(inputUser: let user):
            addOrUpdateNote(inputUser: user)
        }
    }
    
    func addOrUpdateNote(inputUser: User) {
        let inputTitle = content.components(separatedBy: CharacterSet.newlines).first!
        let inputContent = content
        let inputTimestamp = Date.now
        
        if(note == nil) {
            counter += 1
        }
        
        DataManager.shared.updateNote(title: inputTitle, content: inputContent, timestamp: inputTimestamp, id: note?.id ?? counter, user: inputUser)
        
        isLinkActive = true
    }
    
    func getBiggestId() -> Int32? {
        let notes: [Note] = DataManager.shared.fetchAllNotes()
        let biggestNum = notes.max{ i, j in i.id < j.id }
        return biggestNum?.id
    }
    
    func setNote(_ note: Note?) {
        content = note?.content ?? ""
        self.note = note
        contentDisabled = true
    }
    
    func setUser(_ inputUser: User) {
        user = inputUser
    }
}

//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                /*
                ForEach(0..<viewModel.users.count) { index in
                    Text(viewModel.users[index].username!)
                }
                //.onDelete(perform: deleteItems)
                 */
            }
            .toolbar {
                ToolbarItem {
                    Button( action: {
                        addNote()
                        fetchAll()
                        
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
                ToolbarItem {
                    EditButton()
                }
            }
        }
    }
    private func addNote() {
         viewModel.addUser(username: "tim", email: "m@j.com", id: 1)
        viewModel.addNote(inputTitle: "title", inputContaint: "conaint", inputTimestamp: Date.now, inputId: 2, inputUser: viewModel.users[0])
    }
    
    private func fetchAll() {
        let users = viewModel.fetchUserByUsername(inputUsername: "Max")
        let users2 = viewModel.fetchUserByUsername(inputUsername: "lena")
        let notes2 = viewModel.fetchNotes(inputUser: users[0])
        let notes1 = viewModel.fetchNotes(inputUser: viewModel.users[0])
        let notes3 = viewModel.fetchNotes(inputUser: users2[0])
    }
}

#Preview {
    NotesListView()
}

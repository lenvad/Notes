//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel = NotesListViewModel()
    var username = ""
    
    var body: some View {
        NavigationView {
            List(viewModel.allNotesOfUser, id: \.self) { note in
                    HStack {
                        NavigationLink(destination: WriteOrEditNoteView(user: note.user!, note: note).navigationBarBackButtonHidden(true)) {
                            Text(note.title!)
                                .foregroundColor(Color("AccentColor"))
                            Spacer()
                            Text("\(note.timestamp!, formatter: viewModel.dateFormatter)")
                                .foregroundColor(.secondary)
                                .font(.system(size: 10))
                        }.padding(10)
                    }
                    .listRowBackground(Color("Orange").opacity(0.4))
            }
            /*
            .onDelete { indexSet in
                viewModel.deleteNote(inputNote: indexSet)
            }
             */
            .toolbar {
                ToolbarItem {
                    NavigationLink(
                        destination: WriteOrEditNoteView(user: viewModel.user).navigationBarBackButtonHidden(true)
                    ) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
        } 
        .onAppear {
            viewModel.onAppearance(inputUsername: username)
        }
    }
}

#Preview {
    NotesListView()
}

//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel = NotesListViewModel()
    //@FetchRequest var fetchRequest: FetchedResults<Note>
    let username: String
    
    init(username: String) {
        self.username = username
        //_fetchRequest = FetchRequest(entity: Note.entity(), sortDescriptors: [], predicate: NSPredicate(format: "user.username = %@", username))
    }

    var body: some View {
        NavigationView {
            List(viewModel.allNotesFromUser, id: \.self) { note in
                    HStack {
                        NavigationLink(destination: WriteOrEditNoteView(username: username, note: note)//.navigationBarBackButtonHidden(true)
                        ) {
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
                        destination: WriteOrEditNoteView(username: username)//.navigationBarBackButtonHidden(true)
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
            viewModel.onAppearanceOrRefresh(inputUsername: username)
        }
		.refreshable {
			viewModel.onAppearanceOrRefresh(inputUsername: username)
		}
		/*
        .onReceive(fetchRequest.publisher) { _ in
            viewModel.onAppearance(inputUsername: username)
        }
		 */
    }
}

/*
#Preview {
    NotesListView()
}
*/

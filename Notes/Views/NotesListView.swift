//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel = NotesListViewModel()
    @FetchRequest var notesList: FetchedResults<Note>
    let username: String
    
    init(username: String) {
        self.username = username
        _notesList = FetchRequest(entity: Note.entity(), sortDescriptors: [], predicate: NSPredicate(format: "user.username = %@", username))
    }

    var body: some View {
        NavigationView {
			List {
				ForEach(notesList, id: \.self, content:  { note in
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
					.swipeActions {
						Button(action: {
							viewModel.deleteNote(inputNote: note)
						}, label: {
							Text("Delete")
						})
						.tint(.red)
					}
				})
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
            }
        }
    }
	func delete(at note: Note) {
		viewModel.deleteNote(inputNote: note)
	}
}

#Preview {
	NotesListView(username: "Lena")
}


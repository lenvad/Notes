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
    var username: String
    
    init(username: String) {
        self.username = username
        _notesList = FetchRequest(entity: Note.entity(), sortDescriptors: [], predicate: NSPredicate(format: "user.username = %@", username))
    }

	var body: some View {
		NavigationView {
			List {
				ForEach(notesList, id: \.self, content:  { note in
					generateNoteItem(note: note)
				})
				.listRowBackground(Color("OrangeMain").opacity(0.4))
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar ) {
					NavigationLink(
						destination: WriteOrEditNoteView(username: username)
					) {
						Image(systemName: "plus.circle.fill")
							.foregroundColor(Color("AccentColor"))
							.font(.system(size: 35))
							.shadow(color: .gray, radius: 5)
					}.frame(maxWidth: .infinity, alignment: .center)
				}
				
				ToolbarItem(placement: .topBarLeading) {
					NavigationLink(
						destination: ContentView().navigationBarBackButtonHidden(true)
					) {
						Text("Logout")
					}
				}
			}
		}
	}
	
	private func generateNoteItem(note: Note) -> some View {
		return HStack {
			NavigationLink(destination: WriteOrEditNoteView(username: username, note: note)
			) {
				Text(note.title ?? "Untitled")
					.foregroundColor(Color("AccentColor"))
				Spacer()
				Text("\(note.timestamp, formatter: viewModel.dateFormatter)")
					.foregroundColor(.secondary)
					.font(.system(size: 10))
			}.padding(10)
		}
		.swipeActions {
			Button(action: {
				viewModel.onScreenEvent(.deleteNoteWhenSwipe(note: note))
			}, label: {
				Text("Delete")
			})
			.tint(.red)
		}
	}
}

#Preview {
	NotesListView(username: "Lena")
}


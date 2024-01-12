//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
	@StateObject var viewModel: NotesListViewModel
	@FetchRequest(sortDescriptors: [SortDescriptor(\Note.noteId, order: .reverse)]) var notesList: FetchedResults<Note>

	var body: some View {
		NavigationView {
			List {
				ForEach(notesList, id: \.self, content:  { note in
					generateNoteItem(note: note)
				})
				.listRowBackground((Color.orangeMain).opacity(0.4))
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar ) {
					NavigationLink(
						destination: WriteOrEditNoteView(
							viewModel: WriteOrEditNoteViewModel(
								username: viewModel.username,
								userDataManager: UserDataManager(persistenceController: .shared),
								noteDataManager: NoteDataManager(persistenceController: .shared)
							)
						).navigationBarBackButtonHidden(true)
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
		.onAppear {
			print("view is appearing")
			//viewModel.onScreenEvent(.onAppear)
		}
	}
	
	private func generateNoteItem(note: Note) -> some View {
		return HStack {
			NavigationLink(
				destination: WriteOrEditNoteView(
					viewModel: WriteOrEditNoteViewModel(
						username: viewModel.username,
						userDataManager: UserDataManager(persistenceController: .shared),
						noteDataManager: NoteDataManager(persistenceController: .shared),
						note: note
					)
				).navigationBarBackButtonHidden(true)
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

struct NotesListView_Previews: PreviewProvider {
	static var previews: some View {
		NotesListView(
			viewModel: NotesListViewModel(username: "l"),
			notesList: FetchRequest(
				entity: Note.entity(),
				sortDescriptors: [],
				predicate: NSPredicate(format: "user.username = %@", "1")
			)
		)
	}
}


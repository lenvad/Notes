//
//  ContentView.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var notes: [Note] = []
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                /*
                ForEach(0..<notes.count) { index in
                    Text(notes[index].title!)
                }
                //.onDelete(perform: deleteItems)
                 */
            }
            .toolbar {
                ToolbarItem {
                    Button( action: {
                        //addNote()
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
        let users = viewModel.fetchUser(inputUsername: "max")
        let users2 = viewModel.fetchUser(inputUsername: "tim")
        let notes1 = viewModel.fetchNotes(inputUser: viewModel.users[0])
        let notes2 = viewModel.fetchNotes(inputUser: users[0])
    }
    
/*
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
 */
}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}




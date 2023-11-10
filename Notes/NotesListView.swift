//
//  NotesListView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct NotesListView: View {
    @StateObject var viewModel = NotesListViewModel()
    
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
                        //
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
}

#Preview {
    NotesListView()
}

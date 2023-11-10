//
//  ContentView.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView() {
            VStack(alignment: .center, spacing: 15) {
                Text(viewModel.errorMessage)
                    .font(viewModel.footnoteFont)
                    .gridCellColumns(4)
                    .padding()
                    .background(viewModel.errorMessage == "" ? .clear : .red.opacity(0.2))
                    .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(viewModel.errorMessage == "" ? .clear : Color.red), alignment: .leading)
                
                TextField("Username", text: $viewModel.usernameInput)
                    .padding()
                    .cornerRadius(20.0)
                
                HStack {
                    Button(action: {
                        viewModel.usernameEqualToInput()
                    }) {
                      Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15.0)
                    }.frame(alignment: .bottom)
                        .background(
                            NavigationLink("", destination: NotesListView(), isActive: $viewModel.isLinkActive)
                                .opacity(0)
                        )

                    NavigationLink(
                        destination: SignUpView()
                    ) {
                        Text("Sign Up")
                    }.font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

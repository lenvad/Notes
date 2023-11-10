//
//  SignUpView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.errorMessage)
                .font(viewModel.footnoteFont)
                .gridCellColumns(4)
                .padding()
                .background(viewModel.errorMessage == "" ? .clear : .red.opacity(0.2))
                .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(viewModel.errorMessage == "" ? .clear : Color.red), alignment: .leading)
            
            TextField("Username", text: $viewModel.usernameInput)
                .padding()
                .cornerRadius(20.0)
            
            TextField("Email", text: $viewModel.emailInput)
                .padding()
                .cornerRadius(20.0)
                
            
            Button(action: {
                viewModel.addUser()
            }) {
              Text("Sign Up")
                .font(.headline)
                .foregroundColor(.blue)
                .frame(width: 300, height: 30)
                .padding()
                .background(Color.clear)
                .cornerRadius(15.0)
            }.background(
                NavigationLink("", destination: NotesListView(), isActive: $viewModel.isUserAdded)
                    .opacity(0)
            )
        }
    }
}

#Preview {
    SignUpView()
}

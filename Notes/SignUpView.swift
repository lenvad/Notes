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
                .underlineTextField()
                .padding()
            
            SecureField("Password", text: $viewModel.passwordInput)
                .underlineTextField()
                .padding()
            
            TextField("Email", text: $viewModel.emailInput)
                .underlineTextField()
                .padding()
                
            
            Button(action: {
                viewModel.addUser()
            }) {
              Text("Sign Up")
                .font(.headline)
                .foregroundColor(Color("AccentColor"))
                .background(Color.clear)
                .cornerRadius(15.0)
                .padding()
            }
            .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("AccentColor"), lineWidth: 2)
                    )
            .background(
                NavigationLink("", destination: NotesListView(username: viewModel.usernameInput).navigationBarBackButtonHidden(true), isActive: $viewModel.isUserAdded)
                    .opacity(0)
            )
        }
    }
}

#Preview {
    SignUpView()
}

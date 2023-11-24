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
            VStack(alignment: .center, spacing: 10) {
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
                
                HStack {
                    Button(action: {
                        viewModel.usernameEqualToInput()
                    }) {
                        Text("Sign In")
							.signUpButton()
                    }.frame(alignment: .bottom)
                        .background(
                            NavigationLink("", 
                                           destination: NotesListView(username: viewModel.usernameInput).navigationBarBackButtonHidden(true),
                                           isActive: $viewModel.isLinkActive).opacity(0)
                        )
                    
                    Spacer()
                        .frame(width: 30)
                    
                    NavigationLink(
                        destination: SignUpView()
                    ) {
                        Text("Sign Up")
                    }.font(.headline)
                        .padding(15)
                        .foregroundColor(Color("AccentColor"))
                        .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("AccentColor"), lineWidth: 2)
                                )
                }
            }.padding()
        }
    }
}

extension View {
    func underlineTextField() -> some View {
		modifier(UnderlineTextField())
    }
	
	func signUpButton() -> some View {
		modifier(SignUpButton())
	}
}

#Preview {
	ContentView()
}

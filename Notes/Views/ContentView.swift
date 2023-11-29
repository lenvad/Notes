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
				if(viewModel.errorMessage != "") {
					Text(viewModel.errorMessage)
						.errorMessageText(errorMessage: viewModel.errorMessage)
				}
                TextField("Username", text: $viewModel.usernameInput)
					.underlineTextField(errorMessageActive: viewModel.usernameInvalid)
                    
				SecureField("Password", text: $viewModel.passwordInput)
					.underlineTextField(errorMessageActive: viewModel.passwordInvalid)
                HStack {
                    Button(action: {
						viewModel.onScreenEvent(.signIn)
                    }) {
                        Text("Sign In")
<<<<<<< HEAD:Notes/ContentView.swift
							.font(.headline)
							.foregroundColor(.white)
							.padding()
							.background(Color("AccentColor"))
							.cornerRadius(15.0)
=======
							.signUpButton()
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/Views/ContentView.swift
                    }.frame(alignment: .bottom)
                        .background(
                            NavigationLink("", 
                                           destination: NotesListView(username: viewModel.usernameInput).navigationBarBackButtonHidden(true),
                                           isActive: $viewModel.isLinkActive).opacity(0))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    NavigationLink(
                        destination: SignUpView()
                    ) {
                        Text("Sign Up")
					}.signUpButtonText()
                }
            }.padding()
        }
    }
}

<<<<<<< HEAD:Notes/ContentView.swift
#Preview {
    ContentView()
=======
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
>>>>>>> parent of e5af394 (Revert "Fetch request"):Notes/Views/ContentView.swift
}

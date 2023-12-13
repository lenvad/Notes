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
			ZStack {
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
								.font(.headline)
								.foregroundColor(.white)
								.padding()
								.background(Color("AccentColor"))
								.cornerRadius(15.0)
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
				}
				.disabled(viewModel.isLinkActive)
				.padding()
				
				VStack {
					if viewModel.isLinkActive {
						ProgressView()
					}
				}.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(viewModel.isLinkActive ? .black.opacity(0.3):.clear)
			}
		}
	}
}

#Preview {
	ContentView()
}


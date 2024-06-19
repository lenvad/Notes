//
//  ContentView.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = ContentViewModel(persistenceController: PersistenceController.shared)
	
	var body: some View {
		NavigationView() {
			ZStack {
				VStack(alignment: .center, spacing: 10) {
					if !viewModel.errorMessage.isEmpty {
						Text(viewModel.errorMessage)
							.errorMessageText(errorMessage: viewModel.errorMessage)
					}
					
					TextField("Username", text: $viewModel.usernameInput)
						.underlineTextField(errorMessageActive: viewModel.usernameInvalid)
					
					SecureField("Password", text: $viewModel.passwordInput)
						.underlineTextField(errorMessageActive: viewModel.passwordInvalid)
					
					HStack {
						Button(action: {
							viewModel.onScreenEvent(.generateCode)
						}) {
							Text("Send code")
								.font(.headline)
								.foregroundColor(.white)
								.padding()
								.background(Color.accentColor)
								.cornerRadius(15.0)
						}
						.frame(alignment: .bottom)
						
						Spacer()
							.frame(width: 30)
						
						NavigationLink(
							destination: SignUpView()
						) {
							Text("Sign Up")
						}.signUpButtonText()
					}
				}
				.disabled(viewModel.isCodeSended)
				.padding()
				
				if viewModel.isCodeSended {
					mfaView.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(viewModel.isCodeSended ? .black.opacity(0.3):.clear)
					/*
					 ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
					 .background(viewModel.isLinkActive ? .black.opacity(0.3):.clear)
					 */
				}
			}
		}
	}
	
	private var mfaView : some View {
		VStack {
			Text("MFACodeText")
			if !viewModel.errorMessageMFAView.isEmpty {
				Text(viewModel.errorMessageMFAView)
					.errorMessageText(errorMessage: viewModel.errorMessageMFAView)
			}
			
			TextField("Code", text: $viewModel.codeInput)
				.background(Color.accentColor.opacity(0.3))
				.underlineTextField(errorMessageActive: viewModel.passwordInvalid)
			
			Button(action: {
				viewModel.onScreenEvent(.signIn)
			}) {
				Text("Sign In")
					.font(.headline)
					.foregroundColor(.white)
					.padding()
					.background(Color.accentColor)
					.cornerRadius(15.0)
			}
			.frame(alignment: .bottom)
			.background(
				NavigationLink(
					"",
					destination: NotesListView(
						viewModel: NotesListViewModel(username: viewModel.usernameInput, persistenceController: PersistenceController.shared),
						notesList: FetchRequestFactory().makeNotesListFetchRequest(username: viewModel.usernameInput)
					).navigationBarBackButtonHidden(true),
					isActive: $viewModel.isLinkActive).opacity(0).disabled(true)
			)
		}
		.frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.5, alignment: .center)
		.cornerRadius(3.0)
		.background(.white)
	}
}

/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */

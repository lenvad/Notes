//
//  SignUpView.swift
//  Notes
//
//  Created by Lena Vadakkel on 09.11.23.
//

import SwiftUI

struct SignUpView: View {
	@StateObject var viewModel = SignUpViewModel(persistenceController: PersistenceController.shared)
	
	var body: some View {
		ZStack {
			VStack {
				Text(viewModel.errorMessage)
					.errorMessageText(errorMessage: viewModel.errorMessage)
				
				TextField("Username", text: $viewModel.usernameInput)
					.underlineTextField(errorMessageActive: viewModel.usernameInvalid)
				
				SecureField("Password", text: $viewModel.passwordInput)
					.underlineTextField(errorMessageActive: viewModel.passwordInvalid)
				
				TextField("Email", text: $viewModel.emailInput)
					.underlineTextField(errorMessageActive: false)
				
				Button(action: {
					viewModel.onScreenEvent(.addUserWhenButtonClicked)
				}) {
					Text("Sign Up")
				}
				.signUpButtonText()
				.background(
					NavigationLink("", destination: NotesListView(
						viewModel: NotesListViewModel(username: viewModel.usernameInput, persistenceController: PersistenceController.shared),
						notesList: FetchRequestFactory().makeNotesListFetchRequest(username: viewModel.usernameInput)
					).navigationBarBackButtonHidden(true), isActive: $viewModel.isUserAdded)
					.opacity(0)
				)
			}.padding()

			if viewModel.isUserAdded {
				ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(viewModel.isUserAdded ? .black.opacity(0.3):.clear)
			}
		}
	}
}

struct SignUpView_Previews: PreviewProvider {
	static var previews: some View {
		SignUpView()
	}
}


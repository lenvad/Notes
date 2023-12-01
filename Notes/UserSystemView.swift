//
//  UserSystem.swift
//  Notes
//
//  Created by Lena Vadakkel on 29.11.23.
//

import SwiftUI

struct UserSystemView: View {
	@StateObject var viewModel = UserSystemViewModel()
    var body: some View {
		VStack {
			TextField("Username", text: $viewModel.usernameInput)
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 10.0)
					.fill(Color("Orange").opacity(0.3)))
				.disabled(true)
			
			TextField("Passord", text: $viewModel.passwordInput)
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 10.0)
					.fill(Color("Orange").opacity(0.3)))
				.disabled(true)

			TextField("Email", text: $viewModel.emailInput)
				.padding()
				.overlay(RoundedRectangle(cornerRadius: 10.0)
					.fill(Color("Orange").opacity(0.3)))
				.disabled(true)
		}.padding()
        
    }
}

#Preview {
    UserSystemView()
}

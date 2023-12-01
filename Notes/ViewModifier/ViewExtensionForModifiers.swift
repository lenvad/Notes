//
//  ViewExtensionForModifiers.swift
//  Notes
//
//  Created by Lena Vadakkel on 24.11.23.
//

import SwiftUI

extension View {
	func underlineTextField(errorMessageActive: Bool) -> some View {
		modifier(UnderliedTextField(redUnderline: errorMessageActive))
	}
	
	func signUpButtonText() -> some View {
		modifier(SignUpButtonText())
	}
	
	func errorMessageText(errorMessage: String) -> some View {
		modifier(ErrorMessageText(errorMessage: errorMessage))
	}
}

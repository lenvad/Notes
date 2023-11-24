//
//  SignUpButton.swift
//  Notes
//
//  Created by Lena Vadakkel on 24.11.23.
//

import SwiftUI

struct SignUpButtonText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.headline)
			.foregroundColor(.white)
			.padding()
			.background(Color("AccentColor"))
			.cornerRadius(15.0)
	}
}


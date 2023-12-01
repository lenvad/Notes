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
			.padding(15)
			.foregroundColor(Color("AccentColor"))
			.overlay(RoundedRectangle(cornerRadius: 15)
			.stroke(Color("AccentColor"), lineWidth: 2))
	}
}


//
//  UnderliedTextField.swift
//  Notes
//
//  Created by Lena Vadakkel on 24.11.23.
//

import SwiftUI

struct UnderliedTextField: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 10)
			.overlay(Rectangle().frame(height: 2).padding(.top, 35))
			.foregroundColor(Color("AccentColor"))
			.padding(10)
	}
}

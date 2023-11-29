//
//  UnderliedTextField.swift
//  Notes
//
//  Created by Lena Vadakkel on 24.11.23.
//

import SwiftUI

struct UnderliedTextField: ViewModifier {
	var redUnderline: Bool
	
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 10)
			.overlay(Rectangle().frame(height: 2).padding(.top, 35))
			.foregroundColor(redUnderline == true ? .red : Color("AccentColor"))
			.padding(20)
	}
}

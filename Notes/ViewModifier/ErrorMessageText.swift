//
//  ErrorMessageText.swift
//  Notes
//
//  Created by Lena Vadakkel on 24.11.23.
//

import SwiftUI

struct ErrorMessageText: ViewModifier {
	let errorMessage: String
	
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: .infinity, alignment: .leading)
			.font(Font.system(.footnote, design: .monospaced))
			.padding()
			.background(errorMessage == "" ? .clear : .red.opacity(0.2))
			.overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading)
				.foregroundColor(errorMessage == "" ? .clear : Color.red),
					 alignment: .leading)
	}
}

//
//  UITextViewRepresentable.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//

import SwiftUI

struct UITextViewRepresentable: UIViewRepresentable {
	let textView = UITextView()
	@Binding var text: String
	@Binding var isBold: Bool
	@Binding var isItalic: Bool
	
	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		// SwiftUI -> UIKit
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text, isBold: $isBold, isItalic: $isItalic)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		@Binding var text: String
		@Binding var isBold: Bool
		@Binding var isItalic: Bool
		
		init(text: Binding<String>, isBold: Binding<Bool>, isItalic: Binding<Bool>) {
			self._text = text
			self._isBold = isBold
			self._isItalic = isItalic
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// UIKit -> SwiftUI
			_text.wrappedValue = textView.text
		}
		
		func textViewDidChangeSelection(_ textView: UITextView) {
			// Fires off every time the user changes the selection.
			if let font = UIFont(name: "Avenir", size: 12) {
				// Fires off every time the user changes the selection.
				let range = textView.selectedRange
				let string = NSMutableAttributedString(attributedString:
														textView.attributedText)

				if(isBold || isItalic) {
					var attributes = [NSAttributedString.Key.font : font]
					if(isBold) {
						attributes = [NSAttributedString.Key.font : font.bold()]
					}
					if(isItalic) {
						attributes = [NSAttributedString.Key.font : font.italics()]
					}
					
					string.addAttributes(attributes, range: textView.selectedRange)
					textView.attributedText = string
					textView.selectedRange = range
				}
			}
			print(textView.selectedRange)
		}
	}
}

extension UIFont {
	
	func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
		
		// create a new font descriptor with the given traits
		guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
			// the given traits couldn't be applied, return self
			return self
		}
		
		// return a new font with the created font descriptor
		return UIFont(descriptor: fd, size: pointSize)
	}
	
	func italics() -> UIFont {
		return withTraits(.traitItalic)
	}
	
	func bold() -> UIFont {
		return withTraits(.traitBold)
	}
	
	func boldItalics() -> UIFont {
		return withTraits([ .traitBold, .traitItalic ])
	}
}

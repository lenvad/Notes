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
			if let font = UIFont(name: "Helvetica", size: 16) {
				// Fires off every time the user changes the selection.
				let range = textView.selectedRange
				let string = NSMutableAttributedString(attributedString:
														textView.attributedText)

				var attributes = [NSAttributedString.Key.font : font]
				if(isBold) {
					attributes = [NSAttributedString.Key.font : font.bold()]
				}
				if(isItalic) {
					attributes = [NSAttributedString.Key.font : font.italics()]
				}
				
				string.addAttributes(attributes, range: range)
				
				textView.attributedText = string
				}
			
			if let textData = textView.attributedText?.text {
				let text = String(data: textData, encoding: .utf8) ?? ""
				print(text)  // abc
			}
			if let htmlData = textView.attributedText?.html {
				let html = String(data: htmlData, encoding: .utf8) ?? ""
				print(html)  // /* <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" ...
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

extension NSAttributedString {
	
	convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
		try self.init(attributedString: .init(data: data, options: [.documentType: documentType, .characterEncoding: encoding.rawValue], documentAttributes: nil))
	}
	
	func data(_ documentType: DocumentType) -> Data {
		// Discussion
		// Raises an rangeException if any part of range lies beyond the end of the receiver’s characters.
		// Therefore passing a valid range allow us to force unwrap the result
		try! data(from: .init(location: 0, length: length),
				  documentAttributes: [.documentType: documentType])
	}
	
	var text: Data { data(.plain) }
	var html: Data { data(.html)  }
	var rtf:  Data { data(.rtf)   }
	var rtfd: Data { data(.rtfd)  }
}

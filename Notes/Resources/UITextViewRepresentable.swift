//
//  UITextViewRepresentable.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//

import SwiftUI

struct UITextViewRepresentable: UIViewRepresentable {
	let textView = UITextView()
	@Binding var text: NSAttributedString
	@Binding var isBold: Bool
	@Binding var isItalic: Bool
	@Binding var isUnderlined: Bool 
	@Binding var fontSize: Double
	@Binding var selectedRange: NSRange
	@Binding var color: String
	
	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		// SwiftUI -> UIKit
		uiView.attributedText = text
		uiView.selectedRange = selectedRange		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text, isBold: $isBold, isItalic: $isItalic, isUnderlined: $isUnderlined, fontSize: $fontSize, selectedRange: $selectedRange, color: $color)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		@Binding var text: NSAttributedString
		@Binding var isBold: Bool
		@Binding var isItalic: Bool
		@Binding var isUnderlined: Bool
		@Binding var fontSize: Double
		@Binding var selectedRange: NSRange
		@Binding var color: String

		init(text: Binding<NSAttributedString>, isBold: Binding<Bool>, isItalic: Binding<Bool>, isUnderlined: Binding<Bool>, fontSize: Binding<Double>, selectedRange: Binding<NSRange>, color: Binding<String>) {
			self._text = text
			self._isBold = isBold
			self._isItalic = isItalic
			self._isUnderlined = isUnderlined
			self._fontSize = fontSize
			self._selectedRange = selectedRange
			self._color = color
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// UIKit -> SwiftUI
			print("did change text to \(textView.text)")
			_text.wrappedValue = textView.attributedText
		}

		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			print("update with new text: \(text), in range: \(range)")
			if text.isEmpty {
				return true
			}
			
			let font = UIFont.systemFont(ofSize: fontSize)

			let string = NSMutableAttributedString(attributedString: textView.attributedText)
			
			let addedString = NSMutableAttributedString(string: text)
			string.insert(addedString, at: range.location)

			if isBold && isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.boldItalics(),
					range: NSRange(location: range.location, length: text.count)
				)
			} else if isBold && !isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.bold(),
					range: NSRange(location: range.location, length: text.count)
				)
			} else if isItalic && !isBold && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.italics(),
					range: NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && isBold && isItalic {
				string.addAttributes([.font: font.boldItalics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range:NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && isBold && !isItalic {
				string.addAttributes([.font: font.bold(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range:NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && !isBold && isItalic {
				string.addAttributes([.font: font.italics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range:NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && !isBold && !isItalic {
				string.addAttributes([.font: font,
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: NSRange(location: range.location, length: text.count)
				)
			} else {
				string.addAttribute(
					.font,
					value: font,
					range: NSRange(location: range.location, length: text.count)
				)
			}
			//	@Published var colorList: [String] = ["standard", "red", "blue", "green", "yellow", "pink", "purple", "orange"]

			switch color {
				case "standard":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: range.location, length: text.count))
				case "red":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: range.location, length: text.count))
				case "orange":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location: range.location, length: text.count))
				case "yellow":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.yellow, range: NSRange(location: range.location, length: text.count))
				case "green":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: range.location, length: text.count))
				case "blue":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: range.location, length: text.count))
				case "pink":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: NSRange(location: range.location, length: text.count))
				case "purple":
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(location: range.location, length: text.count))
				default:
					string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: range.location, length: text.count))

			}
			
			_text.wrappedValue = string
			_selectedRange.wrappedValue = NSRange(location: range.location + text.count, length: 0)
			
			return false
		}
		
		
		func textViewDidChangeSelection(_ textView: UITextView) {
			let range = textView.selectedRange
			if _selectedRange.wrappedValue != range {
				_selectedRange.wrappedValue =  range
			}
			/*
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
				print(html)  // /<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" ...
			}
			print(textView.selectedRange)
			*/
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

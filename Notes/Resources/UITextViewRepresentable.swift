//
//  UITextViewRepresentable.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//
import Combine
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
	@Binding var formattingCurrentlyChanged: Bool

	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {

		context.coordinator.setBindings(text: $text, isBold: isBold, isItalic: isItalic, isUnderlined: isUnderlined, fontSize: fontSize, selectedRange: $selectedRange, color: color, formattingCurrentlyChanged: $formattingCurrentlyChanged)

		uiView.attributedText = text
		uiView.selectedRange = selectedRange
		
		print("update view with \(selectedRange), \(context.coordinator) \(context.coordinator.isBold) \(isBold)")
		print("formattingCurrentlyChanged: \(formattingCurrentlyChanged)")
		
		if (formattingCurrentlyChanged && selectedRange.length >= 1) {
			print("formating going to be changed")
			let coordinator = context.coordinator
			coordinator.applyStyleToCurrentSelectedTextIfNeed(selectedRange: uiView.selectedRange, attributedText: uiView.attributedText)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text, isBold: isBold, isItalic: isItalic, isUnderlined: isUnderlined, fontSize: fontSize, selectedRange: $selectedRange, color: color, formattingCurrentlyChanged: $formattingCurrentlyChanged)
	}

	class Coordinator: NSObject, UITextViewDelegate {
		@Binding var text: NSAttributedString
		var isBold: Bool
		var isItalic: Bool
		var isUnderlined: Bool
		var fontSize: Double
		@Binding var selectedRange: NSRange
		var color: String
		@Binding var formattingCurrentlyChanged: Bool

		private var currentSelectedRange: NSRange?

		init(text: Binding<NSAttributedString>, 
			 isBold: Bool,
			 isItalic: Bool,
			 isUnderlined: Bool,
			 fontSize: Double,
			 selectedRange: Binding<NSRange>,
			 color: String,
			 formattingCurrentlyChanged: Binding<Bool>
		) {
			self._text = text
			self.isBold = isBold
			self.isItalic = isItalic
			self.isUnderlined = isUnderlined
			self.fontSize = fontSize
			self._selectedRange = selectedRange
			self.color = color
			self._formattingCurrentlyChanged = formattingCurrentlyChanged
		}

		
		func setBindings(text: Binding<NSAttributedString>,
						 isBold: Bool,
						 isItalic: Bool,
						 isUnderlined: Bool,
						 fontSize: Double,
						 selectedRange: Binding<NSRange>,
						 color: String,
						 formattingCurrentlyChanged: Binding<Bool>
		) {
			self._text = text
			self.isBold = isBold
			self.isItalic = isItalic
			self.isUnderlined = isUnderlined
			self.fontSize = fontSize
			self._selectedRange = selectedRange
			self.color = color
			self._formattingCurrentlyChanged = formattingCurrentlyChanged
		}
		
		func debugPrint() {
			print()
			print("\(self) bold: \(self.isBold)")
			print("italic: \(isItalic)")
			print("underlined: \(isUnderlined)")
			print("color: \(color)")
			print("fontsize: \(fontSize)")
			print()
		}
		
		func applyStyleToCurrentSelectedTextIfNeed(selectedRange: NSRange, attributedText: NSAttributedString) {
			debugPrint()
			let font = UIFont.systemFont(ofSize: fontSize)
			
			let range = selectedRange
			currentSelectedRange = range
			let string = NSMutableAttributedString(attributedString: attributedText)
			
			if isBold && isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.boldItalics(),
					range: range
				)
				print("bold and italic")
			} else if isBold && !isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.bold(),
					range: range
				)
				print("bold only")
			} else if isItalic && !isBold && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.italics(),
					range: range
				)
				print("italic only")
			} else if isUnderlined && isBold && isItalic {
				string.addAttributes([.font: font.boldItalics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("bold, italic, underlined")
			} else if isUnderlined && isBold && !isItalic {
				string.addAttributes([.font: font.bold(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("bold and underlined")
				
			} else if isUnderlined && !isBold && isItalic {
				string.addAttributes([.font: font.italics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("italic and underlined")
			} else if isUnderlined && !isBold && !isItalic {
				string.addAttributes([.font: font,
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("underlined only")
			} else {
				string.addAttribute(
					.font,
					value: font,
					range: range
				)
				print("standardFont")
			}
			
			switch color {
				case "standard":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont"),
										range: range)
				case "red":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "redFont"),
										range: range)
				case "orange":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "orangeFont"),
										range: range)
				case "yellow":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "yellowFont"),
										range: range)
				case "green":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "greenFont"),
										range: range)
				case "blue":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "blueFont"),
										range: range)
				case "pink":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "pinkFont"),
										range: range)
				case "purple":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "purpleFont"),
										range: range)
				default:
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont") ,
										range: range)
			}
			
			_text.wrappedValue = string
			_selectedRange.wrappedValue = range
			formattingCurrentlyChanged = false
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// UIKit -> SwiftUI
			print("did change text to \(textView.text)")
			// _text.wrappedValue = textView.attributedText
		}
		
		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			//print("update with new text: \(text), in range: \(range)")
			if text.isEmpty {
				return true
			}
			
			
			debugPrint()

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
									 range: NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && isBold && !isItalic {
				string.addAttributes([.font: font.bold(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: NSRange(location: range.location, length: text.count)
				)
			} else if isUnderlined && !isBold && isItalic {
				string.addAttributes([.font: font.italics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: NSRange(location: range.location, length: text.count)
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
			
			switch color {
				case "standard":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont"),
										range: NSRange(location: range.location, length: text.count))
				case "red":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "redFont"),
										range: NSRange(location: range.location, length: text.count))
				case "orange":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "orangeFont"),
										range: NSRange(location: range.location, length: text.count))
				case "yellow":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "yellowFont"),
										range: NSRange(location: range.location, length: text.count))
				case "green":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "greenFont"),
										range: NSRange(location: range.location, length: text.count))
				case "blue":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "blueFont"),
										range: NSRange(location: range.location, length: text.count))
				case "pink":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "pinkFont"),
										range: NSRange(location: range.location, length: text.count))
				case "purple":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "purpleFont"),
										range: NSRange(location: range.location, length: text.count))
				default:
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont"),
										range: NSRange(location: range.location, length: text.count))
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
			 let range = textView.selectedRange
			 if _selectedRange.wrappedValue != range {
			 _selectedRange.wrappedValue =  range
			 }
			 
			let font = UIFont.systemFont(ofSize: fontSize)
			
			let range = textView.selectedRange
			currentSelectedRange = range
			let string = NSMutableAttributedString(attributedString:
													textView.attributedText)
			
			//print(isBold)
			//print(isItalic)
			//print(isUnderlined)
			
			if isBold && isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.boldItalics(),
					range: range
				)
				print("bold and italic")
			} else if isBold && !isItalic && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.bold(),
					range: range
				)
				print("bold only")
			} else if isItalic && !isBold && !isUnderlined {
				string.addAttribute(
					.font,
					value: font.italics(),
					range: range
				)
				print("italic only")
			} else if isUnderlined && isBold && isItalic {
				string.addAttributes([.font: font.boldItalics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("bold, italic, underlined")
			} else if isUnderlined && isBold && !isItalic {
				string.addAttributes([.font: font.bold(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("bold and underlined")

			} else if isUnderlined && !isBold && isItalic {
				string.addAttributes([.font: font.italics(),
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("italic and underlined")
			} else if isUnderlined && !isBold && !isItalic {
				string.addAttributes([.font: font,
									  .underlineStyle: NSUnderlineStyle.single.rawValue],
									 range: range
				)
				print("underlined only")
			} else {
				string.addAttribute(
					.font,
					value: font,
					range: range
				)
				print("standard")
			}
			
			switch color {
				case "standard":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont"),
										range: range)
				case "red":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "redFont"),
										range: range)
				case "orange":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "orangeFont"),
										range: range)
				case "yellow":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "yellowFont"),
										range: range)
				case "green":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "greenFont"),
										range: range)
				case "blue":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "blueFont"),
										range: range)
				case "pink":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "pinkFont"),
										range: range)
				case "purple":
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "purpleFont"),
										range: range)
				default:
					string.addAttribute(NSAttributedString.Key.foregroundColor,
										value: UIColor(named: "strandardFont") ,
										range: range)
			}
			
			_text.wrappedValue = string
			_selectedRange.wrappedValue = range
			
			print(textView.selectedRange)
			*/
			/*
			 
			 let range = textView.selectedRange
			 if _selectedRange.wrappedValue != range {
			 _selectedRange.wrappedValue =  range
			 }
			 
			 let font = UIFont.systemFont(ofSize: fontSize)
			 
			 let string = NSMutableAttributedString(attributedString: textView.attributedText)
			 
			 let addedString = NSMutableAttributedString(attributedString:
			 textView.attributedText)
			 
			 string.insert(addedString, at: range.location)
			 
			 if isBold && isItalic && !isUnderlined {
			 string.addAttribute(
			 .font,
			 value: font.boldItalics(),
			 range: range
			 )
			 } else if isBold && !isItalic && !isUnderlined {
			 string.addAttribute(
			 .font,
			 value: font.bold(),
			 range: range
			 )
			 } else if isItalic && !isBold && !isUnderlined {
			 string.addAttribute(
			 .font,
			 value: font.italics(),
			 range: range
			 )
			 } else if isUnderlined && isBold && isItalic {
			 string.addAttributes([.font: font.boldItalics(),
			 .underlineStyle: NSUnderlineStyle.single.rawValue],
			 range: range
			 )
			 } else if isUnderlined && isBold && !isItalic {
			 string.addAttributes([.font: font.bold(),
			 .underlineStyle: NSUnderlineStyle.single.rawValue],
			 range: range
			 )
			 } else if isUnderlined && !isBold && isItalic {
			 string.addAttributes([.font: font.italics(),
			 .underlineStyle: NSUnderlineStyle.single.rawValue],
			 range: range
			 )
			 } else if isUnderlined && !isBold && !isItalic {
			 string.addAttributes([.font: font,
			 .underlineStyle: NSUnderlineStyle.single.rawValue],
			 range: range
			 )
			 } else {
			 string.addAttribute(
			 .font,
			 value: font,
			 range: range
			 )
			 }
			 
			 switch color {
			 case "standard":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "strandardFont"),
			 range: range)
			 case "red":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "redFont"),
			 range: range)
			 case "orange":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "orangeFont"),
			 range: range)
			 case "yellow":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "yellowFont"),
			 range: range)
			 case "green":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "greenFont"),
			 range: range)
			 case "blue":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "blueFont"),
			 range: range)
			 case "pink":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "pinkFont"),
			 range: range)
			 case "purple":
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "purpleFont"),
			 range: range)
			 default:
			 string.addAttribute(NSAttributedString.Key.foregroundColor,
			 value: UIColor(named: "strandardFont") ,
			 range: range)
			 }
			 
			 _text.wrappedValue = string
			 
			 
			 
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



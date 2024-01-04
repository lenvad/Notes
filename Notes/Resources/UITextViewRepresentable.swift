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
	@Binding var checklistActivated: Bool
	@Binding var fontSizeDouble: Double
	@Binding var fontSizeString: String
	@Binding var selectedRange: NSRange
	@Binding var color: String
	@Binding var formattingCurrentlyChanged: Bool
	
	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		
		context.coordinator.setAttributes(isBold: $isBold,
										  isItalic: $isItalic,
										  isUnderlined: $isUnderlined,
										  fontSize: $fontSizeDouble,
										  color: $color)
		
		uiView.attributedText = text
		uiView.selectedRange = selectedRange
		
		print("update view with \(selectedRange), \(context.coordinator) \(context.coordinator.isBold) \(isBold)")
		print("formattingCurrentlyChanged: \(formattingCurrentlyChanged)")
		let coordinator = context.coordinator
		coordinator.debugPrint()
		
		if (formattingCurrentlyChanged && selectedRange.length >= 1) {
			print("formating going to be changed")
			coordinator.applyStyleToCurrentSelectedTextIfNeed(selectedRange: uiView.selectedRange, attributedText: uiView.attributedText)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text,
					isBold: $isBold,
					isItalic: $isItalic,
					isUnderlined: $isUnderlined,
					checklistActivated: $checklistActivated,
					fontSize: $fontSizeDouble,
					fontSizeString: $fontSizeString,
					selectedRange: $selectedRange,
					color: $color,
					formattingCurrentlyChanged: $formattingCurrentlyChanged)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		@Binding var text: NSAttributedString
		@Binding var isBold: Bool
		@Binding var isItalic: Bool
		@Binding var isUnderlined: Bool
		@Binding var checklistActivated: Bool
		@Binding var fontSize: Double
		@Binding var fontSizeString: String
		@Binding var selectedRange: NSRange
		@Binding var color: String
		@Binding var formattingCurrentlyChanged: Bool
		
		private var currentSelectedRange: NSRange?
		
		init(text: Binding<NSAttributedString>,
			 isBold:  Binding<Bool>,
			 isItalic:  Binding<Bool>,
			 isUnderlined: Binding<Bool>,
			 checklistActivated: Binding<Bool>,
			 fontSize: Binding<Double>,
			 fontSizeString: Binding<String>,
			 selectedRange: Binding<NSRange>,
			 color: Binding<String>,
			 formattingCurrentlyChanged: Binding<Bool>
		) {
			self._text = text
			self._isBold = isBold
			self._isItalic = isItalic
			self._isUnderlined = isUnderlined
			self._checklistActivated = checklistActivated
			self._fontSize = fontSize
			self._selectedRange = selectedRange
			self._color = color
			self._formattingCurrentlyChanged = formattingCurrentlyChanged
			self._fontSizeString = fontSizeString
		}
		
		func setAttributes(isBold:  Binding<Bool>,
						   isItalic:  Binding<Bool>,
						   isUnderlined: Binding<Bool>,
						   fontSize: Binding<Double>,
						   color: Binding<String>
		) {
			self._isBold = isBold
			self._isItalic = isItalic
			self._isUnderlined = isUnderlined
			self._fontSize = fontSize
			self._color = color
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
		
		func getAllAttributesFromRangeAndSelectThem(selectedRange: NSRange, attributedText: NSAttributedString) {
			//Create Empty Dictionaries for storing results
			var attributedFontRanges = [UIFont?]()
			var attributedColorRanges = [UIColor?]()
			var hasUnderline = false
			
			//Find all attributes in the text.
			attributedText.enumerateAttributes(in: selectedRange) { attributes, range, stop in
				attributes.forEach { (key, value) in
					switch key {
						case NSAttributedString.Key.font:
							attributedFontRanges.append(value as? UIFont)
						case NSAttributedString.Key.foregroundColor:
							attributedColorRanges.append(value as? UIColor)
						case NSAttributedString.Key.underlineStyle:
							hasUnderline = true
						default:
							assert(key == NSAttributedString.Key.paragraphStyle, "Unknown attribute found in the attributed string")
					}
				}
			}
			
			attributedFontRanges.forEach { value in
				let fontStyle = "\(value)"
				if fontStyle.contains("italic") {
					isItalic = true
				} else {
					isItalic = false
				}
				
				if fontStyle.contains("bold") {
					isBold = true
				} else {
					isBold = false
				}
				
				if (value != nil) {
					fontSize = Double(value?.pointSize ?? 12)
					fontSizeString = String(format: "%.2f", Double(value?.pointSize ?? 12))
				}
			}
			
			if hasUnderline {
				isUnderlined = true
			} else {
				isUnderlined = false
			}
			
			attributedColorRanges.forEach { value in
				let fontColor = value?.accessibilityName
				
				switch fontColor {
					case "black":
						color = "standard"
					case "magenta":
						color = "pink"
					case "dark cyan blue":
						color = "blue"
					case "dark red":
						color = "red"
					case "dark green":
						color = "green"
					case "dark purple":
						color = "purple"
					case "vibrant yellow":
						color = "yellow"
					case "orange":
						color = "orange"
					default:
						color = "standard"
				}
			}
		}
		
		func applyStyleToCurrentSelectedTextIfNeed(selectedRange: NSRange, attributedText: NSAttributedString, doesItComeFromTextView: Bool = false, replacementText: String = "") {
			debugPrint()
			let font = UIFont.systemFont(ofSize: fontSize)
			
			var range = selectedRange
			currentSelectedRange = range
			let string = NSMutableAttributedString(attributedString: attributedText)
			
			if doesItComeFromTextView {
				let addedString = NSMutableAttributedString(string: replacementText)
				string.insert(addedString, at: range.location)
				
				if replacementText.isEmpty {
					string.deleteCharacters(in: range)
				}
				range = NSRange(location: range.location, length: replacementText.count)
			}
			
			if !isUnderlined {
				string.removeAttribute(.underlineStyle, range: range)
			}
			
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
			if doesItComeFromTextView {
				_selectedRange.wrappedValue = NSRange(location: range.location + replacementText.count, length: 0)
				
			} else {
				_selectedRange.wrappedValue = range
				print("NS Range: \(NSRange(location: range.location + text.length, length: 0))")
			}
			formattingCurrentlyChanged = false
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// UIKit -> SwiftUI
			print("did change text to \(textView.text)")
			// _text.wrappedValue = textView.attributedText
		}
		
		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			applyStyleToCurrentSelectedTextIfNeed(selectedRange: range, attributedText: textView.attributedText, doesItComeFromTextView: true, replacementText: text)
			return false
		}
		
		func textViewDidChangeSelection(_ textView: UITextView) {
			let range = textView.selectedRange
			if _selectedRange.wrappedValue != range {
				_selectedRange.wrappedValue =  range
			}
			
			if range.length >= 1 {
				getAllAttributesFromRangeAndSelectThem(selectedRange: range, attributedText: textView.attributedText)
			}
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

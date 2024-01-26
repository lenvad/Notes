//  UITextViewRepresentable.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//
import Combine
import SwiftUI

struct UITextViewRepresentable: UIViewRepresentable {
	enum TextViewEvent {
		case text(NSAttributedString)
		case isBold(Bool)
		case isItalic(Bool)
	}
	
	let textView = UITextView()
	@State var text: NSAttributedString
	@Binding var isBold: Bool
	@Binding var isItalic: Bool
	@Binding var isUnderlined: Bool
	@Binding var checklistActivated: Bool
	@Binding var fontSize: Int
	@Binding var selectedRange: NSRange
	@Binding var color: String
	@Binding var formattingCurrentlyChanged: Bool
	let onUpdate: (TextViewEvent) -> Void
	
	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		print("checklist 1: \(checklistActivated)")
		context.coordinator.setAttributes(isBold: $isBold,
										  isItalic: $isItalic,
										  isUnderlined: $isUnderlined,
										  fontSize: $fontSize,
										  color: $color,
										  checklistActivated: $checklistActivated)
		
		uiView.attributedText = text
		uiView.selectedRange = selectedRange
		
		let coordinator = context.coordinator
		coordinator.debugPrint()
		
		if checklistActivated {
			coordinator.displayUncheckedCheckBox(range: uiView.selectedRange, attributedText: uiView.attributedText)
		}
		
		if (formattingCurrentlyChanged && selectedRange.length >= 1) {
			print("1")
			coordinator.applyStyleToCurrentSelectedTextIfNeed(selectedRange: uiView.selectedRange, attributedText: uiView.attributedText)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text,
					isBold: $isBold,
					isItalic: $isItalic,
					isUnderlined: $isUnderlined,
					checklistActivated: $checklistActivated,
					fontSize: $fontSize,
					selectedRange: $selectedRange,
					color: $color,
					formattingCurrentlyChanged: $formattingCurrentlyChanged,
					onUpdate: onUpdate
		)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		enum Colors: String, CaseIterable {
			case standard = "standard"
			case red = "red"
			case blue = "blue"
			case green = "green"
			case yellow  = "yellow"
			case pink = "pink"
			case purple = "purple"
			case orange = "orange"
		}
		
		@Binding var text: NSAttributedString
		@Binding var isBold: Bool
		@Binding var isItalic: Bool
		@Binding var isUnderlined: Bool
		@Binding var checklistActivated: Bool
		@Binding var fontSize: Int
		@Binding var selectedRange: NSRange
		@Binding var color: String
		@Binding var formattingCurrentlyChanged: Bool
		let onUpdate: (TextViewEvent) -> Void
		
		private var currentSelectedRange: NSRange?
		
		init(text: Binding<NSAttributedString>,
			 isBold:  Binding<Bool>,
			 isItalic:  Binding<Bool>,
			 isUnderlined: Binding<Bool>,
			 checklistActivated: Binding<Bool>,
			 fontSize: Binding<Int>,
			 selectedRange: Binding<NSRange>,
			 color: Binding<String>,
			 formattingCurrentlyChanged: Binding<Bool>,
			 onUpdate: @escaping (TextViewEvent) -> Void
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
			self.onUpdate = onUpdate
		}
		
		func setAttributes(isBold:  Binding<Bool>,
						   isItalic:  Binding<Bool>,
						   isUnderlined: Binding<Bool>,
						   fontSize: Binding<Int>,
						   color: Binding<String>,
						   checklistActivated: Binding<Bool>
		) {
			self._isBold = isBold
			self._isItalic = isItalic
			self._isUnderlined = isUnderlined
			self._fontSize = fontSize
			self._color = color
			self._checklistActivated = checklistActivated
		}
		
		func debugPrint() {
			print()
			print("\(self)")
			print("bold: \(self.isBold)")
			print("italic: \(isItalic)")
			print("underlined: \(isUnderlined)")
			print("color: \(color)")
			print("fontsize: \(fontSize)")
			print("checklist: \(checklistActivated)")
			print()
		}

		func getCurrentColerAsValidColor(selectedColor: String) -> String {
			switch selectedColor {
				case "gray":
					return "standard"
				case "magenta":
					return "pink"
				case "yellow orange":
					return "yellow"
				default:
					return "standard"
			}
		}
		
		func getAllAttributesFromRangeAndSelectThem(selectedRange: NSRange, attributedText: NSAttributedString) {
			//Create Empty Dictionaries for storing results
			var attributedFontRanges = [UIFont?]()
			var attributedColorRanges = [UIColor?]()
			var hasUnderline = false
			
			//Find all attributes in the text.
			attributedText.enumerateAttributes(in: selectedRange) { attributes, range, stop in
				print("Attributes: \(attributes)")
				attributes.forEach { (key, value) in
					switch key {
						case NSAttributedString.Key.font:
							attributedFontRanges.append(value as? UIFont)
						case NSAttributedString.Key.foregroundColor:
							attributedColorRanges.append(value as? UIColor)
						case NSAttributedString.Key.underlineStyle:
							hasUnderline = true
						case NSAttributedString.Key.attachment:
							displayCheckedCheckBox(range: selectedRange, attributedText: attributedText)
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
				//onUpdate(.isItalic(isItalic))
				
				if fontStyle.contains("bold") {
					isBold = true
					//onUpdate(.isBold(isBold))
				} else {
					isBold = false
					//onUpdate(.isBold(isBold))
				}
				
				if value != nil {
					fontSize = Int(value?.pointSize ?? 12)
				}
			}
			
			if hasUnderline {
				isUnderlined = true
			} else {
				isUnderlined = false
			}
			
			attributedColorRanges.forEach { value in
				let fontColor = value?.accessibilityName
				
				var colorSet: Colors
				
				if fontColor == "gray" || fontColor == "magenta" || fontColor == "yellow orange" {
					color = getCurrentColerAsValidColor(selectedColor: fontColor ?? "standard") ?? "standard"
				} else {
					color = fontColor ?? "standard"

				}
			}
		}
		
		func applyStyleToCurrentSelectedTextIfNeed(selectedRange: NSRange, attributedText: NSAttributedString, doesItComeFromTextView: Bool = false, replacementText: String = "") {
			debugPrint()
			let font = UIFont.systemFont(ofSize: CGFloat(fontSize))
			
			var range = selectedRange
			currentSelectedRange = range
			let attributedString = NSMutableAttributedString(attributedString: attributedText)
			
			if doesItComeFromTextView {
				let addedString = NSMutableAttributedString(string: replacementText)
				attributedString.insert(addedString, at: range.location)
				
				if replacementText.isEmpty {
					attributedString.deleteCharacters(in: range)
				}
				range = NSRange(location: range.location, length: replacementText.count)
			}
			
			if !isUnderlined {
				attributedString.removeAttribute(.underlineStyle, range: range)
			}
			
			switch(isBold, isItalic, isUnderlined) {
				case (true, true, false):
					attributedString.addAttribute(
						.font,
						value: font.boldItalics(),
						range: range
					)
					print("bold and italic")
				case (true, false, false):
					attributedString.addAttribute(
						.font,
						value: font.bold(),
						range: range
					)
					print("bold only")
				case (false, true, false):
					attributedString.addAttribute(
						.font,
						value: font.italics(),
						range: range
					)
					print("italic only")
				case (true, true, true):
					attributedString.addAttributes([.font: font.boldItalics(),
													.underlineStyle: NSUnderlineStyle.single.rawValue],
												   range: range
					)
					print("bold, italic, underlined")
				case (true, false, true):
					attributedString.addAttributes([.font: font.bold(),
													.underlineStyle: NSUnderlineStyle.single.rawValue],
												   range: range
					)
					print("bold and underlined")
				case (false, true, true):
					attributedString.addAttributes([.font: font.italics(),
													.underlineStyle: NSUnderlineStyle.single.rawValue],
												   range: range
					)
					print("italic and underlined")
				case (false, false, true):
					attributedString.addAttributes([.font: font,
													.underlineStyle: NSUnderlineStyle.single.rawValue],
												   range: range
					)
					print("underlined only")
				default :
					attributedString.addAttribute(
						.font,
						value: font,
						range: range
					)
					print("standard")
			}
			
			//let colorSet = getCurrentColerAsEnumColor(selectedColor: color)
			
			switch Colors(rawValue: color) {
			case .standard:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.standardFont,
											  range: range)
			case .red:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.redFont,
											  range: range)
			case .orange:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.orangeFont,
											  range: range)
			case .yellow:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.yellowFont,
											  range: range)
			case .green:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.greenFont,
											  range: range)
			case .blue:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.blueFont,
											  range: range)
			case .pink:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.pinkFont,
											  range: range)
			case .purple:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.purpleFont,
											  range: range)
			default:
				attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
											  value: UIColor.standardFont ,
											  range: range)
			}
			
			//get range of current line and make it to string
			let rangeOfCurrentLine = attributedString.mutableString.lineRange(for: range)
			let attributedStringOfCurrentLine = attributedString.attributedSubstring(from: rangeOfCurrentLine)
			let stringOfCurrentLine = attributedStringOfCurrentLine.string
			
			//make a UIImage and convert it to String
			let imageAttacament = NSTextAttachment()
			imageAttacament.image = UIImage(systemName: "circlebadge")
			let attributedStringImage = NSAttributedString(attachment: imageAttacament)
			let stringImage = attributedStringImage.string
			
			updateText(attributedString)
			print("2")
			
			if doesItComeFromTextView {
				if stringOfCurrentLine.contains(stringImage) && replacementText == "\n" {
					attributedString.insert(attributedStringImage, at: range.location + 1)
					
					updateText(attributedString)
					
					_selectedRange.wrappedValue = NSRange(location: range.location + replacementText.count + 1, length: 0)
				} else {
					_selectedRange.wrappedValue = NSRange(location: range.location + replacementText.count, length: 0)
				}
			} else {
				print("2")
				_selectedRange.wrappedValue = range
				print("NS Range: \(NSRange(location: range.location + text.length, length: 0))")
			}
			formattingCurrentlyChanged = false
		}
		
		func displayUncheckedCheckBox(range: NSRange, attributedText: NSAttributedString) {
			//converting UIImage to NSAttributedString
			let imageAttacament = NSTextAttachment()
			imageAttacament.image = UIImage(systemName: "circlebadge")
			let imageString = NSAttributedString(attachment: imageAttacament)
			
			let string = NSMutableAttributedString(attributedString: attributedText)
			
			let rangeOfCurrentLine = string.mutableString.lineRange(for: range)
			
			string.insert(imageString, at: rangeOfCurrentLine.location)
			
			checklistActivated = false
			
			updateText(string)
			_selectedRange.wrappedValue = NSRange(location: range.location + 1, length: 0)
		}
		
		func displayCheckedCheckBox(range: NSRange, attributedText: NSAttributedString) {
			//converting UIImage to NSAttributedString
			let imageAttacament = NSTextAttachment()
			imageAttacament.image = UIImage(systemName: "checkmark.circle")?.imageWith(newSize: CGSize(width: 14, height: 14))
			let imageString = NSAttributedString(attachment: imageAttacament)
			
			let string = NSMutableAttributedString(attributedString: attributedText)
			
			//let rangeOfCurrentLine = string.mutableString.lineRange(for: range)
			
			string.replaceCharacters(in: range, with: imageString)
			//string.insert(imageString, at: rangeOfCurrentLine.location)
			
			checklistActivated = false
			
			updateText(string)
			_selectedRange.wrappedValue = NSRange(location: range.location + 1, length: 0)
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
		
		private func updateText(_ newValue: NSAttributedString) {
			_text.wrappedValue = newValue
			onUpdate(.text(newValue))
		}
	}
}


extension UIImage {
	func imageWith(newSize: CGSize) -> UIImage {
		let image = UIGraphicsImageRenderer(size: newSize).image { _ in
			draw(in: CGRect(origin: .zero, size: newSize))
		}
		
		return image.withRenderingMode(renderingMode)
	}
}

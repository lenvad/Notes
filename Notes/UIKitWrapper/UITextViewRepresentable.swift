//  UITextViewRepresentable.swift
//  Notes
//
//  Created by Lena Vadakkel on 30.11.23.
//
import Foundation
import Combine
import SwiftUI

struct UITextViewRepresentable: UIViewRepresentable {

	enum TextViewEvent {
		case text(NSAttributedString)
		case isBold(Bool)
		case isItalic(Bool)
		case isUnderlined(Bool)
		case color(String)
		case fontSize(Int)
		case checklistActivated(Bool)
		case formattingCurrentlyChanged(Bool)
        case selectionChanged(NSRange)
	}
	
	private(set) var text: NSAttributedString
    private(set) var isBold: Bool
    private(set) var isItalic: Bool
    private(set) var isUnderlined: Bool
	private(set) var checklistActivated: Bool
	private(set) var fontSize: Int
    private(set) var selectedRange: NSRange
	private(set) var color: String
	private(set) var formattingCurrentlyChanged: Bool
		
	let onUpdate: (TextViewEvent) -> Void
	let tapGesture = AttachmentTapGestureRecognizer()

    let textView = UITextView()

	func makeUIView(context: Context) -> UITextView {
		textView.delegate = context.coordinator
		//textView.addGestureRecognizer(tapGesture)
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		context.coordinator.setAttributes(isBold: isBold,
										  isItalic: isItalic,
										  isUnderlined: isUnderlined,
										  fontSize: fontSize,
										  color: color,
										  checklistActivated: checklistActivated)
		
		uiView.attributedText = text
		uiView.selectedRange = selectedRange
		
		let coordinator = context.coordinator
		coordinator.debugPrint()
				
		if checklistActivated {
			coordinator.displayUncheckedCheckBox(range: uiView.selectedRange, attributedText: uiView.attributedText)
		}
		
		if formattingCurrentlyChanged && selectedRange.length >= 1  {
			coordinator.applyStyleToCurrentSelectedTextIfNeeded(selectedRange: uiView.selectedRange, attributedText: uiView.attributedText)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: text,
					isBold: isBold,
					isItalic: isItalic,
					isUnderlined: isUnderlined,
					checklistActivated: checklistActivated,
					fontSize: fontSize,
					selectedRange: selectedRange,
					color: color,
					formattingCurrentlyChanged: formattingCurrentlyChanged) { textEvent in
			if case .text(let newAttributedText) = textEvent {
				textView.attributedText = newAttributedText
			}
			onUpdate(textEvent)
		}
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
			
			static func fromString(_ value: String) -> String {
				for color in Colors.allCases {
					if value.contains(color.rawValue) {
						return color.rawValue
					}
				}
				return getCurrentColorAsValidColor(selectedColor: value)
			}
			
			static func getCurrentColorAsValidColor(selectedColor: String) -> String {
				if selectedColor.contains("gray") {
					return self.standard.rawValue
				} else if selectedColor.contains("magenta") {
					return self.pink.rawValue
				} else if selectedColor.contains("brown") {
					return self.orange.rawValue
				} else if selectedColor.contains("black") {
					return self.standard.rawValue
				} else {
					return self.standard.rawValue
				}
			}
		}
		
		private(set) var text: NSAttributedString
        private(set) var isBold: Bool
        private(set) var isItalic: Bool
        private(set) var isUnderlined: Bool
		private(set) var checklistActivated: Bool
		private(set) var fontSize: Int
        private(set) var selectedRange: NSRange
		private(set) var color: String
		private(set) var formattingCurrentlyChanged: Bool

		let onUpdate: (TextViewEvent) -> Void
		
		private var currentSelectedRange: NSRange?
		
		init(text: NSAttributedString,
			 isBold: Bool,
			 isItalic: Bool,
			 isUnderlined: Bool,
			 checklistActivated: Bool,
			 fontSize: Int,
			 selectedRange: NSRange,
			 color: String,
			 formattingCurrentlyChanged: Bool,
			 onUpdate: @escaping (TextViewEvent) -> Void
		) {
			self.text = text
			self.isBold = isBold
			self.isItalic = isItalic
			self.isUnderlined = isUnderlined
			self.checklistActivated = checklistActivated
			self.fontSize = fontSize
			self.selectedRange = selectedRange
			self.color = color
			self.formattingCurrentlyChanged = formattingCurrentlyChanged
			self.onUpdate = onUpdate
		}
		
		func setAttributes(isBold: Bool,
						   isItalic: Bool,
						   isUnderlined: Bool,
						   fontSize: Int,
						   color: String,
						   checklistActivated: Bool
		) {
			self.isBold = isBold
			self.isItalic = isItalic
			self.isUnderlined = isUnderlined
			self.fontSize = fontSize
			self.color = color
			self.checklistActivated = checklistActivated
		}
		
		func debugPrint() {
			print()
			print("\(self)")
			print("bold: \(isBold)")
			print("italic: \(isItalic)")
			print("underlined: \(isUnderlined)")
			print("color: \(color)")
			print("fontsize: \(fontSize)")
			print("checklist: \(checklistActivated)")
			print()
		}


		
		func getAllAttributesFromRangeAndSelectThem(selectedRange: NSRange, attributedText: NSAttributedString) {
			//Create Empty Dictionaries for storing results
			var attributedFontRanges = [UIFont?]()
			var attributedColorRanges = [UIColor?]()
			var hasUnderline = false
			
			//Find all attributes in the text.
			attributedText.enumerateAttributes(in: selectedRange) { attributes, range, _ in
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
							break
						default:
							assert(key == NSAttributedString.Key.paragraphStyle, "Unknown attribute found in the attributed string")
					}
				}
			}
			
			attributedFontRanges.forEach { value in
				let fontStyle = "\(value)"
				if fontStyle.contains("italic") {
					updateItalic(true)
				} else {
					updateItalic(false)
				}
				
				if fontStyle.contains("bold") {
					updateBold(true)
				} else {
					updateBold(false)
				}
				
				if value != nil {
					updateFontSize(Int(value?.pointSize ?? 12))
				}
			}
			
			if hasUnderline {
				updateUnderline(true)
			} else {
				updateUnderline(false)
			}
			
			attributedColorRanges.forEach { value in
				let fontColor = value?.accessibilityName
				updateColor(Colors.fromString(fontColor ?? "standard") )
			}
		}
		
		func applyStyleToCurrentSelectedTextIfNeeded(
			selectedRange: NSRange,
			attributedText: NSAttributedString,
			doesItComeFromTextView: Bool = false,
			replacementText: String = ""
		) {
			debugPrint()
			let font = UIFont.systemFont(ofSize: CGFloat(fontSize))
			
			var range = selectedRange
			
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
			
			let imageAttachment = NSTextAttachment()
			let attributedStringImage = makeUncheckedCheckBox()
			let stringImage = attributedStringImage.string
			
			updateText(attributedString)
			
			if doesItComeFromTextView {
				if stringOfCurrentLine.contains(stringImage) && replacementText == "\n" {
					attributedString.insert(attributedStringImage, at: range.location + 1)
					attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
												  value: UIColor.gray,
												  range: NSRange(location: range.location, length: 1))
					updateText(attributedString)
					
                    updateSelection(
                        NSRange(location: range.location + replacementText.count + 1, length: 0)
                    )
				} else {
                    updateSelection(
                        NSRange(location: range.location + replacementText.count, length: 0)
                    )
				}
			} else {
                updateSelection(range)
			}

			updateformattingChanged(formattingCurrentlyChanged)
		}
		
		func makeUncheckedCheckBox() -> NSAttributedString {
			//converting UIImage to NSAttributedString
			let imageAttachament = NSTextAttachment()
			imageAttachament.image = UIImage(systemName: "circlebadge")?.imageWidth(newSize: CGSize(width: 14, height: 14))
			return NSAttributedString(attachment: imageAttachament)
		}
		
		func displayUncheckedCheckBox(range: NSRange, attributedText: NSAttributedString) {
			let imageString = makeUncheckedCheckBox()
			
			let string = NSMutableAttributedString(attributedString: attributedText)
			
			let rangeOfCurrentLine = string.mutableString.lineRange(for: range)
			
			string.insert(imageString, at: rangeOfCurrentLine.location)

			updateChecklist(false)
			
			updateText(string)
			updateSelection(NSRange(location: range.location + 1, length: 0))
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// UIKit -> SwiftUI
			print("did change text to \(textView.text)")
			if textView.attributedText != text {
				text = textView.attributedText
			}
		}
		
		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			applyStyleToCurrentSelectedTextIfNeeded(selectedRange: range, attributedText: textView.attributedText, doesItComeFromTextView: true, replacementText: text)
			return false
		}
		
		func textViewDidChangeSelection(_ textView: UITextView) {
			let range = textView.selectedRange
			if selectedRange != range {
                updateSelection(range)
			}
			
			if range.length >= 1 {
				getAllAttributesFromRangeAndSelectThem(selectedRange: range, attributedText: textView.attributedText)
			}
		}
		
		private func updateText(_ newValue: NSAttributedString) {
			text = newValue
			onUpdate(.text(newValue))
		}

        private func updateSelection(_ newSelection: NSRange) {
            selectedRange = newSelection
            onUpdate(.selectionChanged(newSelection))
        }
		
        private func updateBold(_ newBoolValue: Bool) {
            isBold = newBoolValue
			onUpdate(.isBold(newBoolValue))
        }
		
        private func updateItalic(_ newBoolValue: Bool) {
            isItalic = newBoolValue
			onUpdate(.isItalic(newBoolValue))
        }
		
        private func updateUnderline(_ newBoolValue: Bool) {
            isUnderlined = newBoolValue
			onUpdate(.isUnderlined(newBoolValue))
        }
		
		private func updateChecklist(_ newBoolValue: Bool) {
            checklistActivated = newBoolValue
			onUpdate(.checklistActivated(newBoolValue))
        }
		
        private func updateformattingChanged(_ newBoolValue: Bool) {
            formattingCurrentlyChanged = newBoolValue
			onUpdate(.formattingCurrentlyChanged(newBoolValue))
        }
		
        private func updateColor(_ newColorValue: String) {
            color = newColorValue
			onUpdate(.color(newColorValue))
        }
		
        private func updateFontSize(_ newFontSizeValue: Int) {
            fontSize = newFontSizeValue
			onUpdate(.fontSize(newFontSizeValue))
        }
	}
}

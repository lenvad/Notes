//
//  AttachmentTapGestureRecognizer.swift
//  Notes
//
//  Created by Lena Vadakkel on 31.01.2024.
//
import Foundation
import UIKit
import SwiftUI

class AttachmentTapGestureRecognizer: UITapGestureRecognizer {
	
	typealias TappedAttachment = (attachment: NSTextAttachment, characterIndex: Int)
	
	private(set) var tappedState: TappedAttachment?
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		tappedState = nil
		
		guard let textView = view as? UITextView else {
			state = .failed
			return
		}
		
		if let touch = touches.first {
			tappedState = evaluateTouch(touch, on: textView)
		}
		
		if tappedState != nil {
			// UITapGestureRecognizer can accurately differentiate discrete taps from scrolling
			// Therefore, let the super view evaluate the correct state.
			super.touchesBegan(touches, with: event)
			
		} else {
			// User didn't initiate a touch (tap or otherwise) on an attachment.
			// Force the gesture to fail.
			state = .failed
		}
	}
	
	/// Tests to see if the user has tapped on a text attachment in the target text view.
	private func evaluateTouch(_ touch: UITouch, on textView: UITextView) -> TappedAttachment? {
		let point = touch.location(in: textView)
		let glyphIndex: Int? = textView.layoutManager.glyphIndex(for: point, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
		let index: Int? = textView.layoutManager.characterIndexForGlyph(at: glyphIndex ?? 0)
		guard let characterIndex = index, characterIndex < textView.textStorage.length else {
			return nil
		}
		guard NSTextAttachment.character == (textView.textStorage.string as NSString).character(at: characterIndex) else {
			return nil
		}
		guard let attachment = textView.textStorage.attribute(.attachment, at: characterIndex, effectiveRange: nil) as? NSTextAttachment else {
			return nil
		}
		var image: UIImage?
		if attachment.image?.accessibilityIdentifier == "2" {
			image = UIImage(systemName: "circlebadge")?.imageWidth(newSize: CGSize(width: 14, height: 14))
			image?.accessibilityIdentifier = "1"
		} else {
			image =  UIImage(systemName: "checkmark.circle")?.imageWidth(newSize: CGSize(width: 14, height: 14))
			image?.accessibilityIdentifier = "2"
		}
		attachment.image = image
		
		return (attachment, characterIndex)
	}
}

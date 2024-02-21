//
//  UIImage.swift
//  Notes
//
//  Created by Lena Vadakkel on 16.02.2024.
//

import Foundation
import SwiftUI

extension UIImage {
	func imageWidth(newSize: CGSize) -> UIImage {
		let image = UIGraphicsImageRenderer(size: newSize).image { _ in
			draw(in: CGRect(origin: .zero, size: newSize))
		}
		
		return image.withRenderingMode(renderingMode)
	}
}

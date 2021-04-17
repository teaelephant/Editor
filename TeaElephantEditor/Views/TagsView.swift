//
// Created by Andrew Khasanov on 08.02.2021.
//

import SwiftUI

struct TagsView: View {
	var tags: [Tag]
	var remove: (Tag) -> Void
	var body: some View {
		ForEach(tags, id: \.self.id) { tag in
			HStack {
				Text(tag.category.name)
				Text(tag.name)
				Button(action: { remove(tag) }, label: {
					Image(systemName: "trash.fill").foregroundColor(.red)
				})
			}.foregroundColor(Color(hex: tag.color))
		}
	}
}

extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
						.sRGB,
						red: Double(r) / 255,
						green: Double(g) / 255,
						blue: Double(b) / 255,
						opacity: Double(a) / 255
		)
	}

	func hex() -> String {
		guard let components = cgColor?.components else {
			return "#FFFFFFFF"
		}
		let rgba: Int = (Int)(round(components[3] * 255)) << 24 |
						(Int)(round(components[0] * 255)) << 16 |
						(Int)(round(components[1] * 255)) << 8 |
						(Int)(round(components[2] * 255)) << 0
		return String(format: "#%06X", rgba)
	}
}

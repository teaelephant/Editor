//
// Created by Andrew Khasanov on 08.02.2021.
//

import SwiftUI
import AppKit

@available(macOS 12.0, *)
struct TagsView: View {
	var tags: [Tag]
	var remove: (Tag) async -> Void
	var body: some View {
		ForEach(tags, id: \.self.id) { tag in
			HStack {
				Text(tag.category.name)
				Text(tag.name)
				Button(action: { Task {
					await remove(tag)
				} }, label: {
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
        guard let color = NSColor(self).usingColorSpace(.sRGB) else {
            return "#FFFFFFFF"
        }
        let components = [color.alphaComponent, color.redComponent, color.greenComponent, color.blueComponent]
        let argb = components.reduce(UInt32(0)) { value, component in
            (value << 8) | UInt32((min(1, max(0, component)) * 255).rounded())
        }
        return String(format: "#%08X", argb)
    }
}

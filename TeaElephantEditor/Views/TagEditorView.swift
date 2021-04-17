//
//  TagEditorView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 11.02.2021.
//
//

import SwiftUI

struct TagEditorView: View {
	@ObservedObject var manager: TagsManager
	@State private var name = ""
	@State private var color: Color = .red
	var body: some View {
		VStack {
			HStack(alignment: .top) {
				TextField("Имя", text: $name).onChange(of: name){ newValue in
					name = newValue
				}
				ColorPicker("Select color", selection: $color)
				Button {
					manager.setColor(color)
					manager.createTag(name)
				} label: {
					Image(systemName: "plus.circle.fill").foregroundColor(.green)
				}
			}
			List(manager.tags, id: \.self.id) { tag in
				HStack {
					Text(tag.name)
					Circle().foregroundColor(Color(hex: tag.color))
				}
			}
		}
	}
}

struct TagEditorView_Previews: PreviewProvider {
	static var previews: some View {
		TagEditorView(manager: TagsManager())
	}
}

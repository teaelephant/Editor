//
//  TagCategoryView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 11.02.2021.
//
//

import SwiftUI

struct TagCategoryView: View {
	@State private var name = ""
	@Binding var selected: TagCategory?
	@ObservedObject var manager = TagsCategoryManager()
	var body: some View {
		VStack {
			HStack(alignment: .top) {
				TextField("Имя", text: $name).onChange(of: name) { newValue in
					manager.setName(name)
				}
				Button {
					manager.createCategory(name)
				} label: {
					Image(systemName: "plus.circle.fill").foregroundColor(.green)
				}
			}
			List {
				ForEach(manager.categories, id: \.self.id) { category in
					if category.id == selected?.id {
						Button {
							selected = nil
						} label: {
							Text(category.name)
						}.foregroundColor(.green)
					} else {
						Button {
							selected = category
						} label: {
							Text(category.name)
						}
					}
				}
			}
		}
	}
}

struct TagCategoryView_Previews: PreviewProvider {
	static var previews: some View {
		TagCategoryView(selected: .constant(TagCategory(id: "", name: "Категория")))
	}
}

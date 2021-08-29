//
//  TagSelector.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 07.02.2021.
//

import SwiftUI

@available(macOS 12.0.0, *)
struct TagSelector: View {
	@ObservedObject var manager: TagsSelectManager
	@State private var selectedTag: Tag?
	@State private var selectedCategory: TagCategory?

	var body: some View {
		HStack {
			Menu {
				ForEach(manager.categories, id: \.self.id) { category in
					Button(action: {
						selectedCategory = category
						selectedTag = nil
					}, label: {
						Text(category.name)
					})
				}
			} label: {
				Text(selectedCategory != nil ? selectedCategory!.name : "Select category")
				Image(systemName: "tag.circle")
			}
			Menu {
				ForEach(manager.tags.filter { tag in
					selectedCategory != nil && tag.category.id == selectedCategory!.id
				}, id: \.self.id) { tag in
					Button {
						selectedTag = tag
					} label: {
						Text(tag.name)
					}
				}
			} label: {
				Text(selectedTag != nil ? selectedTag!.name : "Select tag")
				Image(systemName: "tag.circle")
			}
			Button(action: {
				if selectedTag != nil {
					manager.addTag(selectedTag!)
				}
			}, label: {
				Image(systemName: "plus.circle.fill").foregroundColor(.green)
			}).disabled(selectedTag == nil)
        }.task {
            await manager.loadData()
        }.alert(item: $manager.error)  { err in
			Alert(title: Text("load data error"), message: Text(err), dismissButton: .cancel())
		}
	}
}

@available(macOS 12.0.0, *)
struct TagSelector_Previews: PreviewProvider {
	static var previews: some View {
		TagSelector(manager: TagsSelectManager(""))
	}
}

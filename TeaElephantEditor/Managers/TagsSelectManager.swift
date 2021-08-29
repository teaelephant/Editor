//
//  TagsSelectManager.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 07.02.2021.
//

import Foundation
import Apollo

@available(macOS 12.0.0, *)
class TagsSelectManager: ObservableObject {
	@Published var categories = [TagCategory]()
	@Published var tags = [Tag]()
	@Published var error: String?
	var tea: String

	init(_ tea: String) {
		self.tea = tea
	}

    @MainActor
	func loadData(forceReload: Bool = false) async {
		let cachePolicy: CachePolicy = forceReload ? .returnCacheDataAndFetch : .returnCacheDataElseFetch
		let result = await Network.shared.apollo.fetchAsync(query: TagsMetaQuery(), cachePolicy: cachePolicy)
        switch result {
        case .success(let graphQLResult):
            guard let data = graphQLResult.data else {
                return
            }
            self.categories = data.getTagsCategories.map { category in
                TagCategory(id: category.id, name: category.name)
            }
            self.tags = data.getTags.map { tag in
                Tag(id: tag.id, name: tag.name, color: tag.color, category: TagCategory(id: tag.category.id, name: tag.category.name))
            }
            print(self.categories)
        case .failure(let error):
            self.error = error.localizedDescription
            print("Failure! Error: \(error)")
        }
	}

	func addTag(_ tag: Tag) {
		Network.shared.apollo.perform(mutation: AddTagMutation(tea: tea, tag: tag.id))
	}

	func removeTag(_ tag: Tag) {
		Network.shared.apollo.perform(mutation: RemoveTagMutation(tea: tea, tag: tag.id))
	}
}

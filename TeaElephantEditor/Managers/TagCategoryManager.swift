//
// Created by Andrew Khasanov on 11.02.2021.
//

import Foundation
import Apollo

class TagsCategoryManager: ObservableObject {
	@Published var categories = [TagCategory]()
	@Published var name = ""

	init() {
		loadData()
	}

	func loadData(forceReload: Bool = false) {
		let cachePolicy: CachePolicy
		if forceReload {
			cachePolicy = .returnCacheDataAndFetch
		} else {
			cachePolicy = .returnCacheDataElseFetch
		}
		Network.shared.apollo.fetch(query: TagCategoriesQuery(name: name), cachePolicy: cachePolicy, resultHandler: { result in
			switch result {
			case .success(let graphQLResult):
				guard let data = graphQLResult.data else {
					return
				}
				self.categories = data.getTagsCategories.map { category in
					TagCategory(id: category.id, name: category.name)
				}
			case .failure(let error):
				print("Failure! Error: \(error)")
			}
		})
	}

	func createCategory(_ name: String) {
		Network.shared.apollo.perform(mutation: CreateTagCategoryMutation(name: name))
	}

	func setName(_ name: String) {
		self.name = name
		loadData()
	}
}

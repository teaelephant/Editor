//
// Created by Andrew Khasanov on 18.04.2021.
//

import Foundation
import Apollo
import SwiftUI
import TeaElephantSchema

extension TagsEditor {
	class Manager: ObservableObject {
		@Published var tags = [Tag]()
		@Published var category: TagCategory?
		@Published var model = Model()
		@Published var color: Color = .red
		@Published var error: String?

		init() {
			loadData()
		}

		func loadData(forceReload: Bool = false) {
			guard let cat = category else {
				return
			}
			let cachePolicy: CachePolicy
			if forceReload {
				cachePolicy = .fetchIgnoringCacheData
			} else {
				cachePolicy = .returnCacheDataElseFetch
			}
			print("running category \(cat.name)")
			Network.shared.apollo.fetch(query: TagsQuery(name: .some(model.name), category: cat.id), cachePolicy: cachePolicy, resultHandler: { [self] result in
				switch result {
				case .success(let graphQLResult):
					guard let data = graphQLResult.data else {
						return
					}
					print("category \(cat.name)")
					tags = data.getTags.map { tag in
						Tag(id: tag.id, name: tag.name, color: tag.color, category: TagCategory(id: "", name: ""))
					}
				case .failure(let error):
					self.error = error.localizedDescription
					print("Failure! Error: \(error)")
				}
			})
		}

		func setColor(_ color: Color) {
			self.color = color
		}

		func createTag(_ name: String) {
			guard let cat = category else {
				error = "category is empty"
				return
			}
			Network.shared.apollo.perform(mutation: CreateTagMutation(name: name, color: color.hex(), category: cat.id))
			loadData(forceReload: true)
		}

		func setCategory(_ cat: TagCategory) {
			category = cat
			model.category = cat.name
			loadData()
		}
	}

	class CategoryManager: ObservableObject {
		@Published var categories = [TagCategory]()
		@Published var name = ""
		@Published var error: String?

		init() {
			loadData()
		}

		func loadData(forceReload: Bool = false) {
			let cachePolicy: CachePolicy = forceReload ? .returnCacheDataAndFetch : .returnCacheDataElseFetch
			Network.shared.apollo.fetch(query: TagCategoriesQuery(name: name), cachePolicy: cachePolicy, resultHandler: { result in
				switch result {
				case .success(let graphQLResult):
					guard let data = graphQLResult.data else {
						return
					}
					self.categories = data.tagsCategories.map { category in
						TagCategory(id: category.id, name: category.name)
					}
				case .failure(let error):
					self.error = error.localizedDescription
					print("Failure! Error: \(error)")
				}
			})
		}

		func createCategory(_ name: String) {
			Network.shared.apollo.perform(mutation: CreateTagCategoryMutation(name: name))
			setName(name)
		}

		func setName(_ name: String) {
			self.name = name
			loadData(forceReload: true)
		}
	}
}
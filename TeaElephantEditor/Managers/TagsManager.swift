//
// Created by Andrew Khasanov on 11.02.2021.
//

import Foundation
import Apollo
import SwiftUI

class TagsManager: ObservableObject {
	@Published var tags = [Tag]()
	@Published var category: TagCategory?
	@Published var name = ""
	@Published var color: Color = .red

	init() {
		loadData()
	}

	func loadData(forceReload: Bool = false) {
		guard let cat = category else {
			return
		}
		let cachePolicy: CachePolicy
		if forceReload {
			cachePolicy = .returnCacheDataAndFetch
		} else {
			cachePolicy = .returnCacheDataElseFetch
		}
		print("running category \(cat.name)")
		Network.shared.apollo.fetch(query: TagsQuery(name: name, category: cat.id), cachePolicy: cachePolicy, resultHandler: { [self] result in
			switch result {
			case .success(let graphQLResult):
				guard let data = graphQLResult.data else {
					return
				}
				print("category \(cat.name)")
				self.tags = data.getTags.map { tag in
					Tag(id: tag.id, name: tag.name, color: tag.color, category: TagCategory(id: "", name: ""))
				}
			case .failure(let error):
				print("Failure! Error: \(error)")
			}
		})
	}

	func setColor(_ color: Color) {
		self.color = color
	}

	func setName(_ name: String) {
		self.name = name
	}

	func createTag(_ name: String) {
		guard let cat = category else {
			return
		}
		Network.shared.apollo.perform(mutation: CreateTagMutation(name: name, color: color.hex(), category: cat.id))
	}

	func setCategory(_ cat: TagCategory?) {
		category = cat
		loadData()
	}
}

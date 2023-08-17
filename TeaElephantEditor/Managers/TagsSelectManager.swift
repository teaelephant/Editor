//
//  TagsSelectManager.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 07.02.2021.
//

import Foundation
import Apollo
import TeaElephantSchema

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
        do {
            for try await result in Network.shared.apollo.fetchAsync(query: TagsMetaQuery(), cachePolicy: cachePolicy) {
                guard let data = result.data else {
                    return
                }
                tags.removeAll()
                categories = data.tagsCategories.map { category in
                    let cat = TagCategory(id: category.id, name: category.name)
                    for tag in category.tags {
                        tags.append(Tag(id: tag.id, name: tag.name, color: tag.color, category: cat))
                    }
                    return cat
                }
            }
        } catch {
            self.error = error.localizedDescription
            print("Failure! Error: \(error)")
        }
	}

	func addTag(_ tag: Tag) async {
		_ = await Network.shared.apollo.performAsync(mutation: AddTagMutation(tea: tea, tag: tag.id))
	}

	func removeTag(_ tag: Tag) async {
		_ = await Network.shared.apollo.performAsync(mutation: RemoveTagMutation(tea: tea, tag: tag.id))
        await loadData(forceReload: true)
	}
    
    func generateDescription(name: String) async -> String {
        do {
            for try await result in Network.shared.apollo.fetchAsync(query: DescGenQuery(name:name)) {
                guard let data = result.data?.generateDescription else {
                    return ""
                }
                return data
            }
        } catch {
            self.error = error.localizedDescription
            print("Failure! Error: \(error)")
        }
        return ""
    }
}

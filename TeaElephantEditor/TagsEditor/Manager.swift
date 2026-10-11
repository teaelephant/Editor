//
// Created by Andrew Khasanov on 18.04.2021.
//

import Foundation
import Apollo
import SwiftUI
import TeaElephantSchema

extension TagsEditor {
    @MainActor
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
            guard let cat = category else { return }
            let fetchBehavior: FetchBehavior = forceReload ? .NetworkOnly : .CacheFirst
            let query = TagsQuery(name: .some(model.name), category: .some(cat.name))
            Task {
                do {
                    for try await response in Network.shared.apollo.fetchAsync(query: query, fetchBehavior: fetchBehavior) {
                        guard let data = response.data else {
                            error = response.errors?.first?.localizedDescription
                            return
                        }
                        tags = data.tagsCategories.flatMap { category in
                            category.tags.map { tag in
                                Tag(id: tag.id, name: tag.name, color: tag.color, category: TagCategory(id: category.id, name: category.name))
                            }
                        }
                    }
                } catch {
                    self.error = error.localizedDescription
                }
            }
        }

        func setColor(_ color: Color) {
            self.color = color
        }

        func createTag(_ name: String) {
            guard let cat = category else {
                error = "category is empty"
                return
            }
            let mutation = CreateTagMutation(name: name, color: color.hex(), category: cat.id)
            Task {
                switch await Network.shared.apollo.performAsync(mutation: mutation) {
                case .success(let response):
                    if let error = response.errors?.first {
                        self.error = error.localizedDescription
                        return
                    }
                    loadData(forceReload: true)
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }

        func setCategory(_ cat: TagCategory) {
            category = cat
            model.category = cat.name
            loadData()
        }
    }

    @MainActor
    class CategoryManager: ObservableObject {
        @Published var categories = [TagCategory]()
        @Published var name = ""
        @Published var error: String?

        init() {
            loadData()
        }

        func loadData(forceReload: Bool = false) {
            let fetchBehavior: FetchBehavior = forceReload ? .CacheAndNetwork : .CacheFirst
            let query = TagCategoriesQuery(name: name)
            Task {
                do {
                    for try await response in Network.shared.apollo.fetchAsync(query: query, fetchBehavior: fetchBehavior) {
                        guard let data = response.data else {
                            error = response.errors?.first?.localizedDescription
                            return
                        }
                        categories = data.tagsCategories.map { TagCategory(id: $0.id, name: $0.name) }
                    }
                } catch {
                    self.error = error.localizedDescription
                }
            }
        }

        func createCategory(_ name: String) {
            Task {
                switch await Network.shared.apollo.performAsync(mutation: CreateTagCategoryMutation(name: name)) {
                case .success(let response):
                    if let error = response.errors?.first {
                        self.error = error.localizedDescription
                        return
                    }
                    setName(name)
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }

        func setName(_ name: String) {
            self.name = name
            loadData(forceReload: true)
        }
    }
}

import Foundation
import Apollo
import SwiftUI
import TeaElephantSchema

extension TagsEditor {
    @MainActor
    class Manager: ObservableObject {
        private let client: ApolloClient
        private var loadTask: Task<Void, Never>?
        private var loadVersion = 0
        @Published var tags = [Tag]()
        @Published private(set) var category: TagCategory?
        @Published var model = Model()
        @Published var color: Color = .red
        @Published var error: String?

        init(client: ApolloClient? = nil) {
            self.client = client ?? Network.shared.apollo
        }

        deinit { loadTask?.cancel() }

        func loadData(forceReload: Bool = false) {
            loadTask?.cancel()
            loadVersion += 1
            guard let category else { return }
            let version = loadVersion
            let query = TagsQuery(name: .some(model.name), category: .some(category.name))
            let fetchBehavior: FetchBehavior = forceReload ? .NetworkOnly : .CacheFirst
            error = nil
            loadTask = Task { [weak self, client] in
                do {
                    for try await response in client.fetchAsync(query: query, fetchBehavior: fetchBehavior) {
                        guard !Task.isCancelled, let self, self.loadVersion == version else { return }
                        let data = try response.validatedData()
                        self.tags = data.tagsCategories.flatMap { category in
                            category.tags.map { tag in
                                Tag(id: tag.id, name: tag.name, color: tag.color,
                                    category: TagCategory(id: category.id, name: category.name))
                            }
                        }
                    }
                } catch {
                    guard !Task.isCancelled, let self, self.loadVersion == version else { return }
                    self.error = error.localizedDescription
                }
            }
        }

        func setColor(_ color: Color) { self.color = color }

        func createTag(_ name: String) {
            guard let category else {
                error = "Выберите категорию."
                return
            }
            let mutation = CreateTagMutation(name: name, color: color.hex(), category: category.id)
            Task {
                do {
                    let response = try await client.performAsync(mutation: mutation).get()
                    _ = try response.validatedData()
                    loadData(forceReload: true)
                } catch { self.error = error.localizedDescription }
            }
        }

        func setCategory(_ category: TagCategory?) {
            self.category = category
            model.category = category?.name ?? ""
            tags = []
            error = nil
            loadData()
        }
    }

    @MainActor
    class CategoryManager: ObservableObject {
        private let client: ApolloClient
        private var loadTask: Task<Void, Never>?
        private var loadVersion = 0
        @Published var categories = [TagCategory]()
        @Published var name = ""
        @Published var error: String?

        init(client: ApolloClient? = nil) {
            self.client = client ?? Network.shared.apollo
            loadData()
        }

        deinit { loadTask?.cancel() }

        func loadData(forceReload: Bool = false) {
            loadTask?.cancel()
            loadVersion += 1
            let version = loadVersion
            let query = TagCategoriesQuery(name: name)
            let fetchBehavior: FetchBehavior = forceReload ? .NetworkOnly : .CacheFirst
            error = nil
            loadTask = Task { [weak self, client] in
                do {
                    for try await response in client.fetchAsync(query: query, fetchBehavior: fetchBehavior) {
                        guard !Task.isCancelled, let self, self.loadVersion == version else { return }
                        let data = try response.validatedData()
                        self.categories = data.tagsCategories.map { TagCategory(id: $0.id, name: $0.name) }
                    }
                } catch {
                    guard !Task.isCancelled, let self, self.loadVersion == version else { return }
                    self.error = error.localizedDescription
                }
            }
        }

        func createCategory(_ name: String) {
            Task {
                do {
                    let response = try await client.performAsync(mutation: CreateTagCategoryMutation(name: name)).get()
                    _ = try response.validatedData()
                    setName(name)
                } catch { self.error = error.localizedDescription }
            }
        }

        func setName(_ name: String) {
            self.name = name
            loadData(forceReload: true)
        }
    }
}

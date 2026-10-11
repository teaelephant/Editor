import Foundation
import Apollo
import TeaElephantSchema

@MainActor
class TagsSelectManager: ObservableObject {
    @Published var categories = [TagCategory]()
    @Published var tags = [Tag]()
    @Published var error: String?
    @Published private(set) var isMutating = false
    private let client: ApolloClient
    var tea: String
    var onChange: (() async -> Void)?

    init(_ tea: String, client: ApolloClient? = nil) {
        self.client = client ?? Network.shared.apollo
        self.tea = tea
    }

    func loadData(forceReload: Bool = false) async {
        error = nil
        do {
            for try await response in client.fetchAsync(
                query: TagsMetaQuery(), fetchBehavior: forceReload ? .NetworkOnly : .CacheFirst
            ) {
                let data = try response.validatedData()
                tags = data.tagsCategories.flatMap { category in
                    category.tags.map {
                        Tag(id: $0.id, name: $0.name, color: $0.color,
                            category: TagCategory(id: category.id, name: category.name))
                    }
                }
                categories = data.tagsCategories.map { TagCategory(id: $0.id, name: $0.name) }
            }
        } catch {
            if !Task.isCancelled { self.error = error.localizedDescription }
        }
    }

    func addTag(_ tag: Tag) async {
        guard !isMutating, !tea.isEmpty else { return }
        isMutating = true
        error = nil
        defer { isMutating = false }
        do {
            let response = try await client.performAsync(mutation: AddTagMutation(tea: tea, tag: tag.id)).get()
            let updated = try response.validatedData().addTagToTea
            guard updated.id == tea else {
                throw EditorRequestError(message: "Сервер не подтвердил добавление тега.")
            }
            await onChange?()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func removeTag(_ tag: Tag) async {
        guard !isMutating, !tea.isEmpty else { return }
        isMutating = true
        error = nil
        defer { isMutating = false }
        do {
            let response = try await client.performAsync(mutation: RemoveTagMutation(tea: tea, tag: tag.id)).get()
            let updated = try response.validatedData().deleteTagFromTea
            guard updated.id == tea else {
                throw EditorRequestError(message: "Сервер не подтвердил удаление тега.")
            }
            await onChange?()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

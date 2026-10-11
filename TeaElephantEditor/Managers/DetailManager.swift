import Foundation
import Apollo
import TeaElephantSchema

@MainActor
class DetailManager: ObservableObject {
    private let client: ApolloClient
    @Published private(set) var id: String
    @Published private(set) var detail: TeaDataWithID?
    @Published var error: String?
    @Published var saved = false
    @Published private(set) var isLoading = false
    @Published private(set) var loadFailed = false
    @Published private(set) var isSaving = false
    @Published private(set) var isDeleting = false
    @Published private(set) var isGenerating = false
    @Published private(set) var deleted = false
    let tagsManager: TagsSelectManager

    init(_ id: String, client: ApolloClient? = nil) {
        let client = client ?? Network.shared.apollo
        self.client = client
        self.id = id
        tagsManager = TagsSelectManager(id, client: client)
        tagsManager.onChange = { [weak self] in
            await self?.loadData(forceReload: true)
        }
    }

    func loadData(forceReload: Bool = false) async {
        guard !id.isEmpty, !deleted, !isLoading else { return }
        isLoading = true
        loadFailed = false
        error = nil
        defer { isLoading = false }
        do {
            for try await response in client.fetchAsync(
                query: GetQuery(id: id), fetchBehavior: forceReload ? .NetworkOnly : .CacheFirst
            ) {
                let data = try response.validatedData()
                guard let tea = data.tea else {
                    detail = nil
                    throw EditorRequestError(message: "Запись не найдена или была удалена.")
                }
                detail = TeaDataWithID(
                    ID: tea.id, name: tea.name,
                    type: TeaType(rawValue: tea.type.rawValue) ?? .other,
                    description: tea.description,
                    tags: tea.tags.map { tag in
                        Tag(id: tag.id, name: tag.name, color: tag.color,
                            category: TagCategory(id: tag.category.id, name: tag.category.name))
                    }
                )
            }
            if detail == nil {
                throw EditorRequestError(message: "Не удалось загрузить запись.")
            }
        } catch {
            if !Task.isCancelled {
                self.error = error.localizedDescription
                loadFailed = true
            }
        }
    }

    func save(_ data: TeaData) async throws {
        guard !isSaving, !isDeleting, !deleted else { return }
        isSaving = true
        saved = false
        error = nil
        defer { isSaving = false }
        do {
            if id.isEmpty {
                let response = try await client.performAsync(mutation: CreateMutation(tea: data)).get()
                let created = try response.validatedData().newTea
                guard !created.id.isEmpty else {
                    throw EditorRequestError(message: "Сервер не подтвердил создание записи.")
                }
                id = created.id
                tagsManager.tea = created.id
                detail = TeaDataWithID(
                    ID: created.id, name: data.name,
                    type: TeaType(rawValue: data.type.rawValue) ?? .other,
                    description: data.description, tags: []
                )
            } else {
                let response = try await client.performAsync(mutation: UpdateMutation(id: id, tea: data)).get()
                let updated = try response.validatedData().updateTea
                detail = TeaDataWithID(
                    ID: id, name: updated.name,
                    type: TeaType(rawValue: updated.type.rawValue) ?? .other,
                    description: updated.description, tags: detail?.tags ?? []
                )
            }
            await loadData(forceReload: true)
            saved = true
        } catch {
            self.error = error.localizedDescription
            throw error
        }
    }

    func create(_ data: TeaData) async throws {
        try await save(data)
    }

    func update(_ data: TeaData) async throws {
        try await save(data)
    }

    func delete() async throws {
        guard !id.isEmpty, !isDeleting, !isSaving, !deleted else { return }
        isDeleting = true
        saved = false
        error = nil
        defer { isDeleting = false }
        do {
            let response = try await client.performAsync(mutation: DeleteMutation(id: id)).get()
            guard try response.validatedData().deleteTea == id else {
                throw EditorRequestError(message: "Сервер не подтвердил удаление записи.")
            }
            detail = nil
            deleted = true
            tagsManager.tea = ""
        } catch {
            self.error = error.localizedDescription
            throw error
        }
    }

    func generateDescription(name: String) async -> String? {
        guard !isGenerating else { return nil }
        isGenerating = true
        error = nil
        defer { isGenerating = false }
        do {
            for try await response in client.fetchAsync(
                query: DescGenQuery(name: name), fetchBehavior: .NetworkOnly
            ) {
                let description = try response.validatedData().generateDescription
                guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    throw EditorRequestError(message: "Не удалось сгенерировать описание: сервер вернул пустой ответ.")
                }
                return description
            }
            throw EditorRequestError(message: "Не удалось сгенерировать описание.")
        } catch {
            if !Task.isCancelled { self.error = error.localizedDescription }
            return nil
        }
    }
}

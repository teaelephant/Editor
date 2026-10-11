import Foundation
import Apollo
import TeaElephantSchema

@MainActor
class ListManager: ObservableObject {
    private let client: ApolloClient
    @Published var list = [TeaListElement]()
    @Published var error: String?
    private var onCreate: Task<Void, Never>?
    private var onUpdate: Task<Void, Never>?
    private var onDelete: Task<Void, Never>?
    private var onAddTag: Task<Void, Never>?
    private var onRemoveTag: Task<Void, Never>?

    init(client: ApolloClient? = nil) {
        self.client = client ?? Network.shared.apollo
    }

    deinit {
        onCreate?.cancel()
        onUpdate?.cancel()
        onDelete?.cancel()
        onAddTag?.cancel()
        onRemoveTag?.cancel()
    }

    func loadData(forceReload: Bool = false) async {
        error = nil
        do {
            for try await response in client.fetchAsync(
                query: ListQuery(), fetchBehavior: forceReload ? .NetworkOnly : .CacheFirst
            ) {
                let data = try response.validatedData()
                list = data.teas.map { tea in
                    TeaListElement(ID: tea.id, name: tea.name,
                                   type: TeaType(rawValue: tea.type.rawValue) ?? .other,
                                   tags: tea.tags.map { ListTag(id: $0.id, color: $0.color) })
                }
                subscribeOnChange()
            }
        } catch {
            if !Task.isCancelled { self.error = error.localizedDescription }
        }
    }

    private func upsert(_ tea: TeaListElement) {
        if let row = list.firstIndex(where: { $0.ID == tea.ID }) {
            list[row] = tea
        } else {
            list.append(tea)
        }
    }

    private func updateTags(for id: String, tags: [ListTag]) {
        guard let row = list.firstIndex(where: { $0.ID == id }) else { return }
        let tea = list[row]
        list[row] = TeaListElement(ID: tea.ID, name: tea.name, type: tea.type, tags: tags)
    }

    func subscribeOnChange() {
        onCreate?.cancel()
        onUpdate?.cancel()
        onDelete?.cancel()
        onAddTag?.cancel()
        onRemoveTag?.cancel()
        onCreate = client.subscribeAsync(subscription: OnCreateSubscription()) { [weak self] result in
            guard let self else { return }
            do {
                let tea = try result.get().validatedData().onCreateTea
                self.upsert(TeaListElement(
                    ID: tea.id, name: tea.name,
                    type: TeaType(rawValue: tea.type.rawValue) ?? .other,
                    tags: tea.tags.map { ListTag(id: $0.id, color: $0.color) }
                ))
            } catch { self.error = error.localizedDescription }
        }
        onUpdate = client.subscribeAsync(subscription: OnUpdateSubscription()) { [weak self] result in
            guard let self else { return }
            do {
                let tea = try result.get().validatedData().onUpdateTea
                guard let row = self.list.firstIndex(where: { $0.ID == tea.id }) else { return }
                self.list[row] = TeaListElement(
                    ID: tea.id, name: tea.name,
                    type: TeaType(rawValue: tea.type.rawValue) ?? .other,
                    tags: tea.tags.map { ListTag(id: $0.id, color: $0.color) }
                )
            } catch { self.error = error.localizedDescription }
        }
        onAddTag = client.subscribeAsync(subscription: OnAddTagSubscription()) { [weak self] result in
            guard let self else { return }
            do {
                let tea = try result.get().validatedData().onAddTagToTea
                self.updateTags(for: tea.id, tags: tea.tags.map { ListTag(id: $0.id, color: $0.color) })
            } catch { self.error = error.localizedDescription }
        }
        onRemoveTag = client.subscribeAsync(subscription: OnRemoveTagSubscription()) { [weak self] result in
            guard let self else { return }
            do {
                let tea = try result.get().validatedData().onDeleteTagFromTea
                self.updateTags(for: tea.id, tags: tea.tags.map { ListTag(id: $0.id, color: $0.color) })
            } catch { self.error = error.localizedDescription }
        }
        onDelete = client.subscribeAsync(subscription: OnDeleteSubscription()) { [weak self] result in
            guard let self else { return }
            do {
                let id = try result.get().validatedData().onDeleteTea
                self.list.removeAll { $0.ID == id }
            } catch { self.error = error.localizedDescription }
        }
    }
}

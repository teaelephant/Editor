//
// Created by Andrew Khasanov on 12.01.2021.
//

import Foundation
import Apollo
import TeaElephantSchema

@available(macOS 12.0.0, *)
@MainActor
class ListManager: ObservableObject {
	@Published var list: [TeaListElement]
	@Published var error: String?
	var onCreate: Task<Void, Never>?
	var onUpdate: Task<Void, Never>?
	var onDelete: Task<Void, Never>?

	init() {
		print("running loadData")
		list = [TeaListElement]()
	}

	deinit {
		if onCreate != nil {
			onCreate?.cancel()
		}
		if onUpdate != nil {
			onUpdate?.cancel()
		}
		if onDelete != nil {
			onDelete?.cancel()
		}
	}

	@MainActor
	func loadData(forceReload: Bool = false) async -> Void {
		let fetchBehavior: FetchBehavior = forceReload ? .NetworkOnly : .CacheFirst
        do {
            for try await result in Network.shared.apollo.fetchAsync(query: ListQuery(), fetchBehavior: fetchBehavior) {
                guard let data = result.data else {
                    guard let errors = result.errors else {
                        print("Failure! Unexpected error")
                        return
                    }
                    if errors.count > 0 {
                        self.error = errors[0].localizedDescription
                    }
                    print("Failure! Error: \(errors)")
                    return
                }
                self.list = data.teas.map { tea in
                    TeaListElement(
                                    ID: tea.id,
                                    name: tea.name,
                                    type: TeaType(rawValue: tea.type.rawValue) ?? TeaType.other,
                                    tags: tea.tags.map { tag in
                                        ListTag(id: tag.id, color: tag.color)
                                    })
                }
                subscribeOnChange()
            }
        } catch {
            self.error = error.localizedDescription
            print("Failure! Error: \(error)")
        }
	}

	func subscribeOnChange() {
		onCreate?.cancel()
		onUpdate?.cancel()
		onDelete?.cancel()
		onCreate = Network.shared.apollo
						.subscribeAsync(subscription: OnCreateSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let tea = graphQLResult.data?.onCreateTea {
                                // A tea was created - append it to the list.
					self.list.append(TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea, tags: []))
				} // else, something went wrong and you should check `graphQLResult.error` for problems
			case .failure(let error):
				// Not included here: Show some kind of alert
				print(error)
			}
		}
		onUpdate = Network.shared.apollo
						.subscribeAsync(subscription: OnUpdateSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let tea = graphQLResult.data?.onUpdateTea {
                                // A tea was updated - refresh it in the list.
					if let row = self.list.firstIndex(where: { $0.ID == tea.id }) {
						self.list[row] = TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea, tags: [])
					}
					// self.loadData(forceReload: true)
				} // else, something went wrong and you should check `graphQLResult.error` for problems
			case .failure(let error):
				// Not included here: Show some kind of alert
				print(error)
			}
		}
		onDelete = Network.shared.apollo
						.subscribeAsync(subscription: OnDeleteSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let deletedTeaID = graphQLResult.data?.onDeleteTea {
                                // A tea was deleted - remove it from the list.
					if let row = self.list.firstIndex(where: { $0.ID == deletedTeaID }) {
						self.list.remove(at: row)
					}
				} // else, something went wrong and you should check `graphQLResult.error` for problems
			case .failure(let error):
				// Not included here: Show some kind of alert
				print(error)
			}
		}
	}
}

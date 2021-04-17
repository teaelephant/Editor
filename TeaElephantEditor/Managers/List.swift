//
// Created by Andrew Khasanov on 12.01.2021.
//

import Foundation
import Apollo

extension String: Identifiable {
	public var id: String {
		self
	}
}

class ListManager: ObservableObject {
	@Published var list: [TeaListElement]
	var onCreate: Cancellable?
	var onUpdate: Cancellable?
	var onDelete: Cancellable?

	init() {
		print("running loadData")
		list = [TeaListElement]()
		loadData()
		subscribeOnChange()
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

	func loadData(forceReload: Bool = false) {
		let cachePolicy: CachePolicy
		if forceReload {
			cachePolicy = .returnCacheDataAndFetch
		} else {
			cachePolicy = .returnCacheDataElseFetch
		}
		Network.shared.apollo.fetch(query: ListQuery(), cachePolicy: cachePolicy, resultHandler: { result in
			switch result {
			case .success(let graphQLResult):
				self.list = graphQLResult.data!.getTeas.map { tea in
					TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea, tags: tea.tags.map { tag in
						ListTag(id: tag.id, color: tag.color)
					})
				}
			case .failure(let error):
				print("Failure! Error: \(error)")
			}
		})
	}

	func subscribeOnChange() {
		onCreate = Network.shared.apollo
						.subscribe(subscription: OnCreateSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let tea = graphQLResult.data?.onCreateTea {
					// A review was added - append it to the list then reload the data.
					self.list.append(TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea, tags: []))
				} // else, something went wrong and you should check `graphQLResult.error` for problems
			case .failure(let error):
				// Not included here: Show some kind of alert
				print(error)
			}
		}
		onUpdate = Network.shared.apollo
						.subscribe(subscription: OnUpdateSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let tea = graphQLResult.data?.onUpdateTea {
					// A review was added - append it to the list then reload the data.
					if let row = self.list.firstIndex(where: { $0.ID == tea.id }) {
						self.list[row] = TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea, tags: [])
					}
				} // else, something went wrong and you should check `graphQLResult.error` for problems
			case .failure(let error):
				// Not included here: Show some kind of alert
				print(error)
			}
		}
		onDelete = Network.shared.apollo
						.subscribe(subscription: OnDeleteSubscription()) { [weak self] result in
			guard let self = self else {
				return
			}

			switch result {
			case .success(let graphQLResult):
				if let tea = graphQLResult.data?.onDeleteTea {
					// A review was added - append it to the list then reload the data.
					if let row = self.list.firstIndex(where: { $0.ID == tea.id }) {
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

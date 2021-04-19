//
//  DetailView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 16.01.2021.
//

import Foundation
import Apollo

class DetailManager: ObservableObject {
	var id: String
	@Published var detail: TeaDataWithID?
	@Published var error: String?

	init(_ id: String) {
		self.id = id
		loadData()
	}

	func loadData(forceReload: Bool = false) {
		let cachePolicy: CachePolicy = forceReload ? .returnCacheDataAndFetch : .returnCacheDataElseFetch
		Network.shared.apollo.fetch(query: GetQuery(id: id), cachePolicy: cachePolicy, resultHandler: { result in
			switch result {
			case .success(let graphQLResult):
				guard let data = graphQLResult.data else {
					guard let errors = graphQLResult.errors else {
						print("Failure! Unexpected error")
						return
					}
					if errors.count > 0 {
						self.error = errors[0].localizedDescription
					}
					print("Failure! Error: \(errors)")
					return
				}
				guard let tea = data.getTea else {
					return
				}
				self.detail = TeaDataWithID(
								ID: tea.id,
								name: tea.name,
								type: TeaType(rawValue: tea.type.rawValue) ?? TeaType.other,
								description: tea.description,
								tags: tea.tags.map { tag in
									Tag(id: tag.id, name: tag.name, color: tag.color, category: TagCategory(id: tag.category.id, name: tag.category.name))
								}
				)
			case .failure(let error):
				self.error = error.localizedDescription
				print("Failure! Error: \(error)")
			}
		})
	}

	func update(_ data: TeaData) throws {
		Network.shared.apollo.perform(mutation: UpdateMutation(id: id, tea: data)) { [self] result in
			switch result {
			case .success(let graphQLResult):
				if let errors = graphQLResult.errors {
					print(errors)
					return
				}
				guard let updatedTea = graphQLResult.data?.updateTea else {
					print("updatedTea is nil")
					return
				}
				detail = TeaDataWithID(
								ID: id,
								name: updatedTea.name,
								type: TeaType(rawValue: updatedTea.type.rawValue)!,
								description: updatedTea.description,
								tags: []
				)
				loadData(forceReload: true)
			case .failure(let error):
				self.error = error.localizedDescription
				print(error)
			}
		}
		loadData(forceReload: true)
	}

	func create(_ data: TeaData) throws {
		Network.shared.apollo.perform(mutation: CreateMutation(tea: data)) { result in
			switch result {
			case .success(let graphQLResult):
				if let errors = graphQLResult.errors {
					print(errors)
					return
				}
				guard let createdTea = graphQLResult.data?.newTea else {
					return
				}
				self.detail = TeaDataWithID(
								ID: createdTea.id,
								name: data.name,
								type: TeaType(rawValue: data.type.rawValue)!,
								description: data.description,
								tags: []
				)
			case .failure(let error):
				self.error = error.localizedDescription
				print(error)
			}
		}
		loadData(forceReload: true)
	}

	func delete() throws {
		print("delete \(id)")
		Network.shared.apollo.perform(mutation: DeleteMutation(id: id))
		loadData(forceReload: true)
	}
}

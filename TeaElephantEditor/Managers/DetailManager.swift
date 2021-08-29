//
//  DetailView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 16.01.2021.
//

import Foundation
import Apollo
import SwiftUI

@available(macOS 12.0.0, *)
class DetailManager: ObservableObject {
	var id: String
	@Published var detail: TeaDataWithID?
	@Published var error: String?

	init(_ id: String) {
		self.id = id
	}

    @MainActor
	func loadData(forceReload: Bool = false) async {
        let cachePolicy: CachePolicy = forceReload ? .fetchIgnoringCacheCompletely : .returnCacheDataElseFetch
        let result = await Network.shared.apollo.fetchAsync(query: GetQuery(id: id), cachePolicy: cachePolicy)
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
	}

	func update(_ data: TeaData) async throws {
		let result = await Network.shared.apollo.performAsync(mutation: UpdateMutation(id: id, tea: data))
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
        case .failure(let error):
            self.error = error.localizedDescription
            print(error)
        }
		await loadData(forceReload: true)
	}

	func create(_ data: TeaData) async throws {
		let result = await Network.shared.apollo.performAsync(mutation: CreateMutation(tea: data))
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
		await loadData(forceReload: true)
	}

	func delete() async throws {
		print("delete \(id)")
		_ = await Network.shared.apollo.performAsync(mutation: DeleteMutation(id: id))
		await loadData(forceReload: true)
	}
}

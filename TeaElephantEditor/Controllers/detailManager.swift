//
//  detailManager.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 16.01.2021.
//

import Foundation
import Apollo

class DetailManager: ObservableObject {
    var id: String
    @Published var detail: TeaDataWithID?

    init(_ id: String) {
        self.id = id
        print("running detail manager loadData")
        loadData()
    }

    func loadData() {
        Network.shared.apollo.fetch(query: GetQuery(id: id), resultHandler: { result in
            switch result {
            case .success(let graphQLResult):
                let tea = graphQLResult.data!.getTea
                if tea != nil {
                    self.detail = TeaDataWithID(
                            ID: tea!.id,
                            name: tea!.name,
                            type: TeaType(rawValue: tea!.type.rawValue) ?? TeaType.other,
                            description: tea!.description
                    )
                }
            case .failure(let error):
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
                    return
                }
                detail = TeaDataWithID(
                        ID: id,
                        name: updatedTea.name,
                        type: TeaType(rawValue: updatedTea.type.rawValue)!,
                        description: updatedTea.description
                )
            case .failure(let error):
                print(error)
            }
        }
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
                        description: data.description
                )
            case .failure(let error):
                print(error)
            }
        }
    }

    func delete() throws {
        print("delete \(id)")
        Network.shared.apollo.perform(mutation: DeleteMutation(id: id))
    }
}

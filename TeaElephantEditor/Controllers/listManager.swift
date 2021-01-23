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
        let _ = Detector()
        print("running loadData")
        list = [TeaListElement]()
        loadData()
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

    func loadData() {
        Network.shared.apollo.fetch(query: ListQuery(), resultHandler: { result in
            switch result {
            case .success(let graphQLResult):
                self.list.removeAll()
                for tea in graphQLResult.data!.getTeas {
                    self.list.append(TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea))
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        })
    }

    func subscribeOnCreate() {
        onCreate = Network.shared.apollo
                .subscribe(subscription: OnCreateSubscription()) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let tea = graphQLResult.data?.onCreateTea {
                    // A review was added - append it to the list then reload the data.
                    self.list.append(TeaListElement(ID: tea.id, name: tea.name, type: TeaType.tea))
                } // else, something went wrong and you should check `graphQLResult.error` for problems
            case .failure(let error):
                    // Not included here: Show some kind of alert
                    print(error)
            }
        }
    }
}

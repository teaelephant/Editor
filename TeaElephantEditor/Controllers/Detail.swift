//
// Created by Andrew Khasanov on 16.01.2021.
//

import SwiftUI

@available(macOS 12.0.0, *)
struct DetailController: View {
    var id: String
    @ObservedObject var manager: DetailManager
    
    init(id: String) {
        self.id = id
        manager = DetailManager(id)
    }
    
    var body: some View {
        Group{
            if id == "" {
                Detail(
                    update: manager.create,
                    delete: manager.delete,
                    tea: nil,
                    id: nil,
                    saved: $manager.saved
                )
            } else if manager.detail == nil {
                ProgressView().task{
                    await manager.loadData()
                }
            } else {
                Detail(update: manager.update, delete: manager.delete, tea: manager.detail!, id: manager.id, saved: $manager.saved)
                    .alert(item: $manager.error) { err in
                        Alert(title: Text("load data error"), message: Text(err), dismissButton: .cancel())
                    }
            }
        }
    }
}

@available(macOS 12.0.0, *)
struct DetailController_Previews: PreviewProvider {
    static var previews: some View {
        DetailController(id: "")
    }
}

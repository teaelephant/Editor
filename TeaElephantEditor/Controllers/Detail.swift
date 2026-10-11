import SwiftUI

struct DetailController: View {
    @StateObject private var manager: DetailManager
    @Environment(\.dismiss) private var dismiss

    init(id: String) {
        _manager = StateObject(wrappedValue: DetailManager(id))
    }

    var body: some View {
        Group {
            if manager.deleted {
                ContentUnavailableView("Запись удалена", systemImage: "trash")
            } else if manager.id.isEmpty || manager.detail != nil {
                Detail(manager: manager)
            } else if manager.loadFailed {
                VStack {
                    ContentUnavailableView("Не удалось загрузить запись", systemImage: "exclamationmark.triangle")
                    Button("Повторить") {
                        Task { await manager.loadData(forceReload: true) }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            if manager.detail == nil { await manager.loadData() }
        }
        .onChange(of: manager.deleted) {
            if manager.deleted { dismiss() }
        }
        .errorAlert("Ошибка", error: $manager.error)
    }
}

struct DetailController_Previews: PreviewProvider {
    static var previews: some View {
        DetailController(id: "")
    }
}

import SwiftUI

extension TagsEditor {
    struct Controller: SwiftUI.View {
        @StateObject var manager = Manager()

        var body: some SwiftUI.View {
            HStack(alignment: .top) {
                CategoryView(selected: Binding(
                    get: { manager.category },
                    set: { manager.setCategory($0) }
                ))
                View(manager: manager)
            }
            .errorAlert("Ошибка", error: $manager.error)
        }
    }
}

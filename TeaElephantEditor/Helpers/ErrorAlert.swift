import SwiftUI

private struct ErrorAlertItem: Identifiable {
    let message: String
    var id: String { message }
}

extension View {
    func errorAlert(_ title: LocalizedStringKey, error: Binding<String?>) -> some View {
        let item = Binding<ErrorAlertItem?>(
            get: { error.wrappedValue.map { ErrorAlertItem(message: $0) } },
            set: { error.wrappedValue = $0?.message }
        )
        return alert(item: item) { item in
            Alert(title: Text(title), message: Text(item.message), dismissButton: .cancel())
        }
    }
}

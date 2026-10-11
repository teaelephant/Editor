import SwiftUI
import TeaElephantSchema

struct Detail: View {
    @ObservedObject var manager: DetailManager
    @ObservedObject private var tagsManager: TagsSelectManager
    @State private var name: String
    @State private var type: TeaType
    @State private var description: String

    init(manager: DetailManager) {
        self.manager = manager
        self.tagsManager = manager.tagsManager
        _name = State(initialValue: manager.detail?.name ?? "")
        _type = State(initialValue: manager.detail?.type ?? .tea)
        _description = State(initialValue: manager.detail?.description ?? "")
    }

    private var busy: Bool {
        manager.isSaving || manager.isDeleting || manager.isGenerating || tagsManager.isMutating
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("Имя", text: $name)
                Picker("Тип напитка", selection: $type) {
                    Text(TeaType.tea.rawValue).tag(TeaType.tea)
                    Text(TeaType.coffee.rawValue).tag(TeaType.coffee)
                    Text(TeaType.herb.rawValue).tag(TeaType.herb)
                    Text(TeaType.other.rawValue).tag(TeaType.other)
                }
                TextEditor(text: $description)
                    .frame(minHeight: 120)
                    .overlay {
                        if manager.isGenerating { ProgressView() }
                    }
                Button("Generate description") {
                    Task {
                        if let generated = await manager.generateDescription(name: name) {
                            description = generated
                        }
                    }
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                if !manager.id.isEmpty {
                    TagsView(tags: manager.detail?.tags ?? [], remove: tagsManager.removeTag)
                    TagSelector(manager: tagsManager)
                }
                HStack {
                    Spacer()
                    if !manager.id.isEmpty {
                        Button("Delete", role: .destructive) {
                            Task { try? await manager.delete() }
                        }
                        .padding(.horizontal)
                    }
                    Button {
                        Task { try? await save() }
                    } label: {
                        if manager.saved {
                            Image(systemName: "checkmark").foregroundColor(.green)
                                .task {
                                    do { try await Task.sleep(nanoseconds: 500_000_000) }
                                    catch { return }
                                    manager.saved = false
                                }
                        } else {
                            Text("Save")
                        }
                    }
                    .padding(.horizontal)
                    .foregroundColor(.green)
                    .animation(.default, value: manager.saved)
                }
            }
            .padding()
            .disabled(busy)
        }
    }

    private func save() async throws {
        let input = TeaData(name: name, type: GraphQLEnum(Type_Enum(rawValue: type.rawValue) ?? .other), description: description)
        try await manager.save(input)
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(manager: DetailManager(""))
    }
}

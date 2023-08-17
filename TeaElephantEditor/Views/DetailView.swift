//
//  DetailView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import SwiftUI
import TeaElephantSchema

@available(macOS 12.0.0, *)
struct Detail: View {
    var update: (TeaData) async throws -> Void
    var delete: () async throws -> Void
    var tagsManager: TagsSelectManager?
    @State private var name = ""
    @State private var type = TeaType.tea
    @State private var description = ""
    @State private var loading = false
    private var tags = [Tag]()
    @Binding var saved: Bool
    
    init(update: @escaping (TeaData) async throws -> Void, delete: @escaping () async throws -> Void, tea: TeaDataWithID?, id: String?, saved: Binding<Bool>) {
        self.update = update
        self.delete = delete
        self._saved = saved
        
        if id != nil {
            tagsManager = TagsSelectManager(id!)
        }
        
        guard let t = tea else {
            return
        }
        
        _name = State(initialValue: t.name)
        _type = State(initialValue: t.type)
        _description = State(initialValue: t.description)
        tags = t.tags
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("Имя", text: $name)
                Picker(selection: $type, label: Text("Тип напитка")) {
                    Text(TeaType.tea.rawValue).tag(TeaType.tea)
                    Text(TeaType.coffee.rawValue).tag(TeaType.coffee)
                    Text(TeaType.herb.rawValue).tag(TeaType.herb)
                }
                Spacer()
                if loading {
                    ProgressView()
                } else {
                    TextEditor(text: $description)
                }
                Button(action: {
                    withAnimation{
                        loading = true
                        Task{
                            guard let description = await tagsManager?.generateDescription(name:name) else { return }
                            if description == "" {
                                return
                            }
                            DispatchQueue.main.async {
                                self.description = description
                                loading = false
                            }
                        }
                    }
                }) {
                    Text("Generate description")
                }.animation(.default, value: loading)
                if tagsManager != nil {
                    if tags.count > 0 {
                        TagsView(tags: tags, remove: tagsManager!.removeTag)
                    }
                    TagSelector(manager: tagsManager!)
                }
                HStack {
                    Spacer()
                    Button("Delete", action: {
                        Task.init{
                            await remove()
                        }
                    }).padding(.horizontal).foregroundColor(.red).animation(.default, value: saved)
                    Button{
                        withAnimation { }
                        Task{
                            await save()
                        }
                    } label:{
                        if saved {
                            Image(systemName: "checkmark").foregroundColor(.green).onAppear{
                                Task{
                                    try await Task.sleep(nanoseconds: 500_000_000)
                                    DispatchQueue.main.async {
                                        self.saved = false
                                    }
                                }
                            }
                        } else {
                            Text("Save")
                        }
                    }.padding(.horizontal).foregroundColor(.green).animation(.default, value: saved)
                }
            }.padding()
        }
    }
    
    func remove() async {
        do {
            try await delete()
        } catch {
            print(error)
            return
        }
    }
    
    func save() async {
        do {
            try await update(TeaData(name: name, type: GraphQLEnum(Type_Enum(rawValue: type.rawValue)!), description: description))
        } catch {
            print(error)
            return
        }
    }
}

struct Demo {
    func remove() throws {
    }
    
    func save(_ data: TeaData) throws {
        print(data)
    }
}

@available(macOS 12.0.0, *)
struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(update: Demo().save, delete: Demo().remove, tea: TeaDataWithID(ID: "", name: "", type: TeaType.tea, description: "", tags: []), id: nil, saved: .constant(true))
    }
}

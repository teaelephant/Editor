//
//  Detail.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import SwiftUI

struct Detail: View {
    var update: (TeaData) throws -> Void
    var delete: () throws -> Void
    @State private var name = ""
    @State private var type = TeaType.tea
    @State private var description = ""

    init(update: @escaping (TeaData) throws -> Void, delete: @escaping () throws -> Void, tea: TeaDataWithID?) {
        self.update = update
        self.delete = delete
        if tea != nil {
            _name = State(initialValue: tea!.name)
            _type = State(initialValue: tea!.type)
            _description = State(initialValue: tea!.description)
        }
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
                TextEditor(text: $description)
                HStack {
                    Spacer()
                    Button("Delete", action: remove).padding(.horizontal).foregroundColor(.red)
                    Button("Save", action: save).padding(.horizontal).foregroundColor(.green)
                }
            }.padding()
        }
    }

    func remove() {
        do {
            try delete()
        } catch {
            print(error)
            return
        }
    }

    func save() {
        do {
            try update(TeaData(name: name, type: Type(rawValue: type.rawValue)!, description: description))
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

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(update: Demo().save, delete: Demo().remove, tea: TeaDataWithID(ID: "", name: "", type: TeaType.tea, description: ""))
    }
}

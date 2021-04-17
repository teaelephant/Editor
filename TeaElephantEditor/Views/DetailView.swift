//
//  DetailView.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import SwiftUI

struct Detail: View {
	var update: (TeaData) throws -> Void
	var delete: () throws -> Void
	var tagsManager: TagsSelectManager?
	@State private var name = ""
	@State private var type = TeaType.tea
	@State private var description = ""
	@State private var tags = [Tag]()

	init(update: @escaping (TeaData) throws -> Void, delete: @escaping () throws -> Void, tea: TeaDataWithID?, id: String?) {
		self.update = update
		self.delete = delete

		if id != nil {
			tagsManager = TagsSelectManager(id!)
		}

		guard let t = tea else {
			return
		}

		_name = State(initialValue: t.name)
		_type = State(initialValue: t.type)
		_description = State(initialValue: t.description)
		_tags = State(initialValue: t.tags)
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
				if tagsManager != nil {
					Text("Тэги")
					if tags.count > 0 {
						TagsView(tags: tags, remove: tagsManager!.removeTag)
					}
					TagSelector(manager: tagsManager!)
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
		Detail(update: Demo().save, delete: Demo().remove, tea: TeaDataWithID(ID: "", name: "", type: TeaType.tea, description: "", tags: []), id: nil)
	}
}

//
//  Table.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import SwiftUI

@available(macOS 12.0.0, *)
struct Table: View {
	@ObservedObject private var manager = ListManager()
	@State var newData: TeaDataWithID = TeaDataWithID(ID: "", name: "", type: TeaType.tea, description: "", tags: [])
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Button(action: { Task.init {
						await manager.loadData(forceReload: true)
					} }) {
						Image(systemName: "arrow.2.circlepath")
					}.foregroundColor(.blue)
					NavigationLink(
									destination: DetailController(id: ""),
									label: {
										Image(systemName: "plus.circle")
									}).foregroundColor(.green)
				}
				NavigationLink(
								destination: TagsEditor.Controller(),
								label: {
									Text("tags editor")
								}).foregroundColor(.orange)
				List(manager.list, id: \.self.ID) { tea in
					NavigationLink(
									destination: DetailController(id: tea.ID),
									label: {
										VStack(alignment: .leading) {
											Text("\(tea.name)").bold()
											HStack {
												Text("\(tea.type.rawValue)").font(.subheadline).italic()
												ForEach(tea.tags, id: \.self.id) { tag in
													Circle()
																	.fill(Color(hex: tag.color))
																	.frame(width: 10, height: 10)
												}
											}
										}
									})
				}
			}.task {
				await manager.loadData()
			}
		}.alert(item: $manager.error) { err in
			Alert(title: Text("load data error"), message: Text(err), dismissButton: .cancel())
		}
	}
}


@available(macOS 12.0.0, *)
struct Table_Previews: PreviewProvider {
	static var previews: some View {
		Table()
	}
}

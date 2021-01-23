//
//  Table.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import SwiftUI

struct Table: View {
    @ObservedObject private var manager = ListManager()
    @State var newData: TeaDataWithID = TeaDataWithID(ID: "", name: "", type: TeaType.tea, description: "")
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: manager.loadData) {
                        Image(systemName: "arrow.2.circlepath")
                    }.foregroundColor(.blue)
                    NavigationLink(
                            destination: DetailController(id: ""),
                            label: {
                                Image(systemName: "plus.circle")
                            }).foregroundColor(.green)
                }
                List(manager.list, id: \.self.ID) { tea in
                    NavigationLink(
                            destination: DetailController(id: tea.ID),
                            label: {
                                VStack(alignment: .leading) {
                                    Text("\(tea.name)").bold()
                                    Text("\(tea.type.rawValue)").font(.subheadline).italic()
                                }
                            })
                }
            }
        }
    }
}


struct Table_Previews: PreviewProvider {
    static var previews: some View {
        Table()
    }
}

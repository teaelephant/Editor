//
// Created by Andrew Khasanov on 16.01.2021.
//

import SwiftUI

struct DetailController: View {
	var id: String
	@ObservedObject var manager: DetailManager

	init(id: String) {
		self.id = id
		manager = DetailManager(id)
	}

	var body: some View {
		if id == "" {
			Detail(update: manager.create, delete: manager.delete, tea: nil, id: nil)
		} else if manager.detail == nil {
			Text("Loading...")
		} else {
			Detail(update: manager.update, delete: manager.delete, tea: manager.detail!, id: manager.id)
							.alert(item: $manager.error) { err in
								Alert(title: Text("load data error"), message: Text(err), dismissButton: .cancel())
							}
		}
	}
}

struct DetailController_Previews: PreviewProvider {
	static var previews: some View {
		DetailController(id: "")
	}
}

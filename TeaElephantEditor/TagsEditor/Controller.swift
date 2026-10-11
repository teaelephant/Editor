//
// Created by Andrew Khasanov on 18.04.2021.
//

import SwiftUI

extension TagsEditor {
	struct Controller: SwiftUI.View {
		@ObservedObject var manager = Manager()
		@State var error: String?
		var body: some SwiftUI.View {
			HStack(alignment: .top) {
				CategoryView(selected: .init(
								get: { manager.category },
								set: {
									guard let category = $0 else {
										print("category is nil")
										error = "category is empty"
										return
									}
									print("set category of tag \(category)")
									manager.setCategory(category)
								})).errorAlert("Category set error", error: $error)
				View(manager: manager)
			}.errorAlert("load data error", error: $manager.error)
		}
	}
}

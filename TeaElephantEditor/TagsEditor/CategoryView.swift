//
// Created by Andrew Khasanov on 18.04.2021.
//

import SwiftUI

extension TagsEditor {
	struct CategoryView: SwiftUI.View {
		@StateObject var model = Model()
		@Binding var selected: TagCategory?
		@StateObject var manager = CategoryManager()
		@State var isSaveDisabled = true
		var body: some SwiftUI.View {
			VStack {
				HStack(alignment: .top) {
					TextField("Категория", text: $model.category).onChange(of: model.category) {
						manager.setName(model.category)
					}.validation(model.categoryValidation)
					Button {
						manager.createCategory(model.category)
					} label: {
						Image(systemName: "plus.circle.fill").foregroundColor(.green)
					}.disabled(isSaveDisabled)
				}
				List {
					ForEach(manager.categories, id: \.self.id) { category in
						if category.id == selected?.id {
							Button {
								selected = nil
							} label: {
								Text(category.name)
							}.foregroundColor(.green)
						} else {
							Button {
								selected = category
							} label: {
								Text(category.name)
							}
						}
					}
				}
			}.onReceive(model.categoryValidation) { validation in
				self.isSaveDisabled = !validation.isSuccess
			}.errorAlert("Category error", error: $manager.error)
		}
	}

	struct CategoryView_Previews: PreviewProvider {
		static var previews: some SwiftUI.View {
			CategoryView(selected: .constant(TagCategory(id: "", name: "Категория")))
		}
	}

}

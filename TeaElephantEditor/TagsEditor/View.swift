//
// Created by Andrew Khasanov on 18.04.2021.
//

import SwiftUI
import Combine

extension TagsEditor {
	struct View: SwiftUI.View {
		@ObservedObject var manager: Manager
		@State var isSaveDisabled = true
		@State private var color: Color = .red
		var body: some SwiftUI.View {
			VStack {
				HStack(alignment: .top) {
					TextField("Имя", text: $manager.model.name).onChange(of: manager.model.name) { newValue in
						manager.model.name = newValue
					}.validation(manager.model.nameValidation)
					ColorPicker("", selection: $color)
					Button {
						manager.setColor(color)
						manager.createTag(manager.model.name)
					} label: {
						Image(systemName: "plus.circle.fill").foregroundColor(.green)
					}.disabled(isSaveDisabled)
				}
				List(manager.tags, id: \.self.id) { tag in
					HStack {
						Text(tag.name).frame(height: 15)
						Spacer()
						Circle().foregroundColor(Color(hex: tag.color)).frame(height: 15)
					}
				}
			}.onReceive(manager.model.allValidation) { validation in
				self.isSaveDisabled = !validation.isSuccess
			}
		}
	}

	struct View_Previews: PreviewProvider {
		static var previews: some SwiftUI.View {
			View(manager: Manager())
		}
	}
}
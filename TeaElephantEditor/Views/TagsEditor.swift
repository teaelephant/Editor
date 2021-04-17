//
// Created by Andrew Khasanov on 09.02.2021.
//

import SwiftUI

struct TagsEditor: View {
	@ObservedObject var manager = TagsManager()
	var body: some View {
		HStack(alignment: .top) {
			TagCategoryView(selected: .init(get: { manager.category },
							set: {
								print("set category of tag \($0)")
								manager.setCategory($0)
							}))
			TagEditorView(manager: manager)
		}
	}
}

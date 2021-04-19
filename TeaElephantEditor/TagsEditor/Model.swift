//
// Created by Andrew Khasanov on 18.04.2021.
//

import SwiftUI
import Combine

extension TagsEditor {
	class Model: ObservableObject {
		@Published var category: String = ""
		@Published var name: String = ""
		lazy var nameValidation: ValidationPublisher = {
			$name.nonEmptyValidator("Имя не может быть пустым")
		}()
		lazy var categoryValidation: ValidationPublisher = {
			$category.nonEmptyValidator("Категория не может быть пустой")
		}()
		lazy var allValidation: ValidationPublisher = {
			Publishers.CombineLatest(
							nameValidation,
							categoryValidation
			).map { v1, v2 in
				print("nameValidation: \(v1)")
				print("categoryValidation: \(v2)")
				return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
			}.eraseToAnyPublisher()
		}()
	}
}
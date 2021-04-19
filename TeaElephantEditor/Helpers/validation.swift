//
// Created by Andrew Khasanov on 18.04.2021.
//

import SwiftUI
import Combine
import Regex

extension View {
	func validation(_ validationPublisher: ValidationPublisher) -> some View {
		self.modifier(ValidationModifier(validationPublisher: validationPublisher))
	}
}

enum Validation {
	case success
	case failure(message: String)
	var isSuccess: Bool {
		if case .success = self {
			return true
		}
		return false
	}
}

typealias ValidationPublisher = AnyPublisher<Validation, Never>
typealias ValidationErrorClosure = () -> String

struct ValidationModifier: ViewModifier {
	@State var latestValidation: Validation = .success
	let validationPublisher: ValidationPublisher

	func body(content: Content) -> some View {
		VStack(alignment: .leading) {
			content
			validationMessage
		}.onReceive(validationPublisher) { validation in
			self.latestValidation = validation
		}
	}

	var validationMessage: some View {
		switch latestValidation {
		case .success:
			return AnyView(EmptyView())
		case .failure(let message):
			let text = Text(message)
							.foregroundColor(Color.red)
							.font(.caption)
			return AnyView(text)
		}
	}
}

enum ValidationPublishers {
	static func nonEmptyValidation(for publisher: Published<String>.Publisher,
	                               errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		publisher.map { value in
							guard value.count > 0 else {
								return .failure(message: errorMessage())
							}
							return .success
						}
						.dropFirst()
						.eraseToAnyPublisher()
	}

	static func matcherValidation(for publisher: Published<String>.Publisher,
	                              withPattern pattern: Regex,
	                              errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		publisher.map { value in
							guard pattern.matches(value) else {
								return .failure(message: errorMessage())
							}
							return .success
						}
						.dropFirst()
						.eraseToAnyPublisher()
	}

	static func dateValidation(for publisher: Published<Date>.Publisher,
	                           afterDate after: Date = .distantPast,
	                           beforeDate before: Date = .distantFuture,
	                           errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		publisher.map { date in
			date > after && date < before ? .success : .failure(message: errorMessage())
		}.eraseToAnyPublisher()
	}
}

extension Published.Publisher where Value == String {
	func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		ValidationPublishers.nonEmptyValidation(for: self, errorMessage: errorMessage())
	}

	func matcherValidation(_ pattern: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		ValidationPublishers.matcherValidation(for: self, withPattern: pattern.r!, errorMessage: errorMessage())
	}
}

extension Published.Publisher where Value == Date {
	func dateValidation(afterDate after: Date = .distantPast,
	                    beforeDate before: Date = .distantFuture,
	                    errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
		ValidationPublishers.dateValidation(for: self, afterDate: after, beforeDate: before, errorMessage: errorMessage())
	}
}
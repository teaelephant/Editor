//
//  Tag.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 07.02.2021.
//

import Foundation

struct TagCategory: Codable, Identifiable, Hashable {
	let id: String
	let name: String
}

struct Tag: Codable {
	let id: String
	let name: String
	let color: String
	let category: TagCategory
}

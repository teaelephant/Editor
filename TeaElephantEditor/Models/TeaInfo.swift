//
//  TeaInfo.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import Foundation

enum TeaType: String, Codable {
    case tea = "tea"
    case coffee = "coffee"
    case herb = "herb"
    case other = "other"
}

struct TeaDataWithID: Codable {
    let ID: String
    let name: String
    let type: TeaType
    let description: String
}

struct TeaListElement: Codable {
    let ID: String
    let name: String
    let type: TeaType
}

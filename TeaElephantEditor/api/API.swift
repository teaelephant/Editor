// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct TeaData: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - name
  ///   - type
  ///   - description
  public init(name: String, type: `Type`, description: String) {
    graphQLMap = ["name": name, "type": type, "description": description]
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var type: `Type` {
    get {
      return graphQLMap["type"] as! `Type`
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var description: String {
    get {
      return graphQLMap["description"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }
}

public enum `Type`: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case unknown
  case tea
  case coffee
  case herb
  case other
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "unknown": self = .unknown
      case "tea": self = .tea
      case "coffee": self = .coffee
      case "herb": self = .herb
      case "other": self = .other
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .unknown: return "unknown"
      case .tea: return "tea"
      case .coffee: return "coffee"
      case .herb: return "herb"
      case .other: return "other"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: `Type`, rhs: `Type`) -> Bool {
    switch (lhs, rhs) {
      case (.unknown, .unknown): return true
      case (.tea, .tea): return true
      case (.coffee, .coffee): return true
      case (.herb, .herb): return true
      case (.other, .other): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [`Type`] {
    return [
      .unknown,
      .tea,
      .coffee,
      .herb,
      .other,
    ]
  }
}

public final class CreateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation create($tea: TeaData!) {
      newTea(tea: $tea) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "create"

  public var tea: TeaData

  public init(tea: TeaData) {
    self.tea = tea
  }

  public var variables: GraphQLMap? {
    return ["tea": tea]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("newTea", arguments: ["tea": GraphQLVariable("tea")], type: .nonNull(.object(NewTea.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(newTea: NewTea) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "newTea": newTea.resultMap])
    }

    public var newTea: NewTea {
      get {
        return NewTea(unsafeResultMap: resultMap["newTea"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "newTea")
      }
    }

    public struct NewTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class DeleteMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation delete($id: ID!) {
      deleteTea(id: $id)
    }
    """

  public let operationName: String = "delete"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteTea", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteTea: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteTea": deleteTea])
    }

    public var deleteTea: GraphQLID {
      get {
        return resultMap["deleteTea"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteTea")
      }
    }
  }
}

public final class UpdateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation update($id: ID!, $tea: TeaData!) {
      updateTea(id: $id, tea: $tea) {
        __typename
        id
        name
        description
        type
      }
    }
    """

  public let operationName: String = "update"

  public var id: GraphQLID
  public var tea: TeaData

  public init(id: GraphQLID, tea: TeaData) {
    self.id = id
    self.tea = tea
  }

  public var variables: GraphQLMap? {
    return ["id": id, "tea": tea]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateTea", arguments: ["id": GraphQLVariable("id"), "tea": GraphQLVariable("tea")], type: .nonNull(.object(UpdateTea.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateTea: UpdateTea) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateTea": updateTea.resultMap])
    }

    public var updateTea: UpdateTea {
      get {
        return UpdateTea(unsafeResultMap: resultMap["updateTea"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "updateTea")
      }
    }

    public struct UpdateTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(`Type`.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, description: String, type: `Type`) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id, "name": name, "description": description, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var type: `Type` {
        get {
          return resultMap["type"]! as! `Type`
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}

public final class GetQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query get($id: ID!) {
      getTea(id: $id) {
        __typename
        id
        name
        description
        type
      }
    }
    """

  public let operationName: String = "get"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTea", arguments: ["id": GraphQLVariable("id")], type: .object(GetTea.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTea: GetTea? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTea": getTea.flatMap { (value: GetTea) -> ResultMap in value.resultMap }])
    }

    public var getTea: GetTea? {
      get {
        return (resultMap["getTea"] as? ResultMap).flatMap { GetTea(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "getTea")
      }
    }

    public struct GetTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(`Type`.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, description: String, type: `Type`) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id, "name": name, "description": description, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var type: `Type` {
        get {
          return resultMap["type"]! as! `Type`
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}

public final class ListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query list {
      getTeas {
        __typename
        id
        name
        type
      }
    }
    """

  public let operationName: String = "list"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTeas", type: .nonNull(.list(.nonNull(.object(GetTea.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTeas: [GetTea]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTeas": getTeas.map { (value: GetTea) -> ResultMap in value.resultMap }])
    }

    public var getTeas: [GetTea] {
      get {
        return (resultMap["getTeas"] as! [ResultMap]).map { (value: ResultMap) -> GetTea in GetTea(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetTea) -> ResultMap in value.resultMap }, forKey: "getTeas")
      }
    }

    public struct GetTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(`Type`.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, type: `Type`) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id, "name": name, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var type: `Type` {
        get {
          return resultMap["type"]! as! `Type`
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}

public final class OnCreateSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription onCreate {
      onCreateTea {
        __typename
        id
        name
        type
        description
      }
    }
    """

  public let operationName: String = "onCreate"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("onCreateTea", type: .nonNull(.object(OnCreateTea.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(onCreateTea: OnCreateTea) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "onCreateTea": onCreateTea.resultMap])
    }

    public var onCreateTea: OnCreateTea {
      get {
        return OnCreateTea(unsafeResultMap: resultMap["onCreateTea"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "onCreateTea")
      }
    }

    public struct OnCreateTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(`Type`.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, type: `Type`, description: String) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id, "name": name, "type": type, "description": description])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var type: `Type` {
        get {
          return resultMap["type"]! as! `Type`
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }
    }
  }
}

public final class OnDeleteSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription onDelete {
      onDeleteTea
    }
    """

  public let operationName: String = "onDelete"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("onDeleteTea", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(onDeleteTea: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "onDeleteTea": onDeleteTea])
    }

    public var onDeleteTea: GraphQLID {
      get {
        return resultMap["onDeleteTea"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "onDeleteTea")
      }
    }
  }
}

public final class OnUpdateSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription onUpdate {
      onUpdateTea {
        __typename
        id
        name
        type
        description
      }
    }
    """

  public let operationName: String = "onUpdate"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("onUpdateTea", type: .nonNull(.object(OnUpdateTea.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(onUpdateTea: OnUpdateTea) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "onUpdateTea": onUpdateTea.resultMap])
    }

    public var onUpdateTea: OnUpdateTea {
      get {
        return OnUpdateTea(unsafeResultMap: resultMap["onUpdateTea"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "onUpdateTea")
      }
    }

    public struct OnUpdateTea: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tea"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(`Type`.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, type: `Type`, description: String) {
        self.init(unsafeResultMap: ["__typename": "Tea", "id": id, "name": name, "type": type, "description": description])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var type: `Type` {
        get {
          return resultMap["type"]! as! `Type`
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateTagMutation: GraphQLMutation {
  public static let operationName: String = "createTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createTag($name: String!, $color: String!, $category: ID!) { createTag(name: $name, color: $color, category: $category) { __typename id name color } }"#
    ))

  public var name: String
  public var color: String
  public var category: ID

  public init(
    name: String,
    color: String,
    category: ID
  ) {
    self.name = name
    self.color = color
    self.category = category
  }

  public var __variables: Variables? { [
    "name": name,
    "color": color,
    "category": category
  ] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("createTag", CreateTag.self, arguments: [
        "name": .variable("name"),
        "color": .variable("color"),
        "category": .variable("category")
      ]),
    ] }

    public var createTag: CreateTag { __data["createTag"] }

    /// CreateTag
    ///
    /// Parent Type: `Tag`
    public struct CreateTag: TeaElephantSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Tag }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("color", String.self),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var color: String { __data["color"] }
    }
  }
}

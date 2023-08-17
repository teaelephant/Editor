// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TagCategoriesQuery: GraphQLQuery {
  public static let operationName: String = "tagCategories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query tagCategories($name: String!) { tagsCategories(name: $name) { __typename id name } }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  public var __variables: Variables? { ["name": name] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tagsCategories", [TagsCategory].self, arguments: ["name": .variable("name")]),
    ] }

    /// Get categories of tags
    public var tagsCategories: [TagsCategory] { __data["tagsCategories"] }

    /// TagsCategory
    ///
    /// Parent Type: `TagCategory`
    public struct TagsCategory: TeaElephantSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.TagCategory }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
    }
  }
}

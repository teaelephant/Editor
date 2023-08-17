// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TagsQuery: GraphQLQuery {
  public static let operationName: String = "tags"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query tags($name: String, $category: String) { tagsCategories(name: $category) { __typename id name tags(name: $name) { __typename id name color } } }"#
    ))

  public var name: GraphQLNullable<String>
  public var category: GraphQLNullable<String>

  public init(
    name: GraphQLNullable<String>,
    category: GraphQLNullable<String>
  ) {
    self.name = name
    self.category = category
  }

  public var __variables: Variables? { [
    "name": name,
    "category": category
  ] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tagsCategories", [TagsCategory].self, arguments: ["name": .variable("category")]),
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
        .field("tags", [Tag].self, arguments: ["name": .variable("name")]),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var tags: [Tag] { __data["tags"] }

      /// TagsCategory.Tag
      ///
      /// Parent Type: `Tag`
      public struct Tag: TeaElephantSchema.SelectionSet {
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
}

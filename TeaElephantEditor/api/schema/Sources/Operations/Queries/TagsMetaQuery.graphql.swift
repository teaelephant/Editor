// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TagsMetaQuery: GraphQLQuery {
  public static let operationName: String = "tagsMeta"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query tagsMeta { tagsCategories { __typename id name tags { __typename id name color } } }"#
    ))

  public init() {}

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tagsCategories", [TagsCategory].self),
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
        .field("tags", [Tag].self),
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

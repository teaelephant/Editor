// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct TagsMetaQuery: GraphQLQuery {
  public static let operationName: String = "tagsMeta"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query tagsMeta { tagsCategories { __typename id name tags { __typename id name color } } }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("tagsCategories", [TagsCategory].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      TagsMetaQuery.Data.self
    ] }

    /// Get categories of tags
    public var tagsCategories: [TagsCategory] { __data["tagsCategories"] }

    /// TagsCategory
    ///
    /// Parent Type: `TagCategory`
    nonisolated public struct TagsCategory: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.TagCategory }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("tags", [Tag].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        TagsMetaQuery.Data.TagsCategory.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var tags: [Tag] { __data["tags"] }

      /// TagsCategory.Tag
      ///
      /// Parent Type: `Tag`
      nonisolated public struct Tag: TeaElephantSchema.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tag }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", TeaElephantSchema.ID.self),
          .field("name", String.self),
          .field("color", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          TagsMetaQuery.Data.TagsCategory.Tag.self
        ] }

        public var id: TeaElephantSchema.ID { __data["id"] }
        public var name: String { __data["name"] }
        public var color: String { __data["color"] }
      }
    }
  }
}

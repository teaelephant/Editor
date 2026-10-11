// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct TagCategoriesQuery: GraphQLQuery {
  public static let operationName: String = "tagCategories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query tagCategories($name: String!) { tagsCategories(name: $name) { __typename id name } }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  @_spi(Unsafe) public var __variables: Variables? { ["name": name] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("tagsCategories", [TagsCategory].self, arguments: ["name": .variable("name")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      TagCategoriesQuery.Data.self
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
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        TagCategoriesQuery.Data.TagsCategory.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UpdateTagCategoryMutation: GraphQLMutation {
  public static let operationName: String = "updateTagCategory"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation updateTagCategory($id: ID!, $name: String!) { updateTagCategory(id: $id, name: $name) { __typename id name } }"#
    ))

  public var id: ID
  public var name: String

  public init(
    id: ID,
    name: String
  ) {
    self.id = id
    self.name = name
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "name": name
  ] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("updateTagCategory", UpdateTagCategory.self, arguments: [
        "id": .variable("id"),
        "name": .variable("name")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateTagCategoryMutation.Data.self
    ] }

    public var updateTagCategory: UpdateTagCategory { __data["updateTagCategory"] }

    /// UpdateTagCategory
    ///
    /// Parent Type: `TagCategory`
    nonisolated public struct UpdateTagCategory: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.TagCategory }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateTagCategoryMutation.Data.UpdateTagCategory.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
    }
  }
}

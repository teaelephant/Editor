// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CreateTagCategoryMutation: GraphQLMutation {
  public static let operationName: String = "createTagCategory"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createTagCategory($name: String!) { createTagCategory(name: $name) { __typename id name } }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  @_spi(Unsafe) public var __variables: Variables? { ["name": name] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("createTagCategory", CreateTagCategory.self, arguments: ["name": .variable("name")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CreateTagCategoryMutation.Data.self
    ] }

    public var createTagCategory: CreateTagCategory { __data["createTagCategory"] }

    /// CreateTagCategory
    ///
    /// Parent Type: `TagCategory`
    nonisolated public struct CreateTagCategory: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.TagCategory }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CreateTagCategoryMutation.Data.CreateTagCategory.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
    }
  }
}

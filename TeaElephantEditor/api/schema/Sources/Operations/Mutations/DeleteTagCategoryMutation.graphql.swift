// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct DeleteTagCategoryMutation: GraphQLMutation {
  public static let operationName: String = "deleteTagCategory"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation deleteTagCategory($id: ID!) { deleteTagCategory(id: $id) }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteTagCategory", TeaElephantSchema.ID.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DeleteTagCategoryMutation.Data.self
    ] }

    public var deleteTagCategory: TeaElephantSchema.ID { __data["deleteTagCategory"] }
  }
}

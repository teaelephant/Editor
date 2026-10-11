// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct OnDeleteSubscription: GraphQLSubscription {
  public static let operationName: String = "onDelete"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onDelete { onDeleteTea }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("onDeleteTea", TeaElephantSchema.ID.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      OnDeleteSubscription.Data.self
    ] }

    public var onDeleteTea: TeaElephantSchema.ID { __data["onDeleteTea"] }
  }
}

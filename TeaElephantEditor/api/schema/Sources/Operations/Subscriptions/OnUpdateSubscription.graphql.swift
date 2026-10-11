// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct OnUpdateSubscription: GraphQLSubscription {
  public static let operationName: String = "onUpdate"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onUpdate { onUpdateTea { __typename id name type description } }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("onUpdateTea", OnUpdateTea.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      OnUpdateSubscription.Data.self
    ] }

    public var onUpdateTea: OnUpdateTea { __data["onUpdateTea"] }

    /// OnUpdateTea
    ///
    /// Parent Type: `Tea`
    nonisolated public struct OnUpdateTea: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("type", GraphQLEnum<TeaElephantSchema.Type_Enum>.self),
        .field("description", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        OnUpdateSubscription.Data.OnUpdateTea.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var type: GraphQLEnum<TeaElephantSchema.Type_Enum> { __data["type"] }
      public var description: String { __data["description"] }
    }
  }
}

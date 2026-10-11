// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct OnCreateSubscription: GraphQLSubscription {
  public static let operationName: String = "onCreate"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onCreate { onCreateTea { __typename id name type description } }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("onCreateTea", OnCreateTea.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      OnCreateSubscription.Data.self
    ] }

    public var onCreateTea: OnCreateTea { __data["onCreateTea"] }

    /// OnCreateTea
    ///
    /// Parent Type: `Tea`
    nonisolated public struct OnCreateTea: TeaElephantSchema.SelectionSet {
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
        OnCreateSubscription.Data.OnCreateTea.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var type: GraphQLEnum<TeaElephantSchema.Type_Enum> { __data["type"] }
      public var description: String { __data["description"] }
    }
  }
}

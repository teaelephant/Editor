// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct OnAddTagSubscription: GraphQLSubscription {
  public static let operationName: String = "onAddTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onAddTag { onAddTagToTea { __typename id tags { __typename id color } } }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("onAddTagToTea", OnAddTagToTea.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      OnAddTagSubscription.Data.self
    ] }

    public var onAddTagToTea: OnAddTagToTea { __data["onAddTagToTea"] }

    /// OnAddTagToTea
    ///
    /// Parent Type: `Tea`
    nonisolated public struct OnAddTagToTea: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("tags", [Tag].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        OnAddTagSubscription.Data.OnAddTagToTea.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var tags: [Tag] { __data["tags"] }

      /// OnAddTagToTea.Tag
      ///
      /// Parent Type: `Tag`
      nonisolated public struct Tag: TeaElephantSchema.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tag }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", TeaElephantSchema.ID.self),
          .field("color", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          OnAddTagSubscription.Data.OnAddTagToTea.Tag.self
        ] }

        public var id: TeaElephantSchema.ID { __data["id"] }
        public var color: String { __data["color"] }
      }
    }
  }
}
